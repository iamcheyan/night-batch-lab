// Training fixture: the external converter called by the Windows Batch job.

class CsvRecord {
  constructor(columns) {
    this.account = columns[0];
    this.amount = Number(columns[1]);
    this.status = columns[2];
  }
}

function parseCsv(input) {
  return input
    .trim()
    .split("\\n")
    .map((line) => new CsvRecord(line.split(",")));
}

function calculateSummary(records) {
  return records.reduce(
    (summary, record) => {
      summary.count += 1;
      summary.total += record.status === "OK" ? record.amount : 0;
      return summary;
    },
    { count: 0, total: 0 },
  );
}

function convertCsvToXls(inputPath, outputPath) {
  const fs = require("node:fs");
  const records = parseCsv(fs.readFileSync(inputPath, "utf8"));
  const summary = calculateSummary(records);
  fs.writeFileSync(outputPath, JSON.stringify(summary, null, 2));
}

function main() {
  const [, , inputPath, outputPath] = process.argv;
  if (!inputPath || !outputPath) {
    throw new Error("usage: csv2xls.js INPUT.csv OUTPUT.xls");
  }
  convertCsvToXls(inputPath, outputPath);
}

main();
