type JobStatus = "READY" | "RUNNING" | "SUCCESS" | "ERROR";

interface JobResult {
  jobId: string;
  status: JobStatus;
  message: string;
}

class NightJob {
  constructor(private readonly jobId: string) {}

  validateInput(path: string): JobResult {
    if (!path.endsWith(".csv")) {
      return { jobId: this.jobId, status: "ERROR", message: "CSV required" };
    }
    return { jobId: this.jobId, status: "READY", message: "input accepted" };
  }

  convert(inputPath: string, outputPath: string): JobResult {
    const input = this.validateInput(inputPath);
    if (input.status === "ERROR") return input;
    return { jobId: this.jobId, status: "SUCCESS", message: `${inputPath} -> ${outputPath}` };
  }
}

export function executeNightJob(jobId: string): JobResult {
  return new NightJob(jobId).convert(`${jobId}.csv`, `${jobId}.xls`);
}
