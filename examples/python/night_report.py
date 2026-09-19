"""Training fixture: build a night-batch settlement report."""

from dataclasses import dataclass
from pathlib import Path


@dataclass
class Transaction:
    account: str
    amount: int
    status: str


class NightReport:
    def __init__(self, business_date: str) -> None:
        self.business_date = business_date
        self.transactions: list[Transaction] = []

    def read_input(self, input_path: Path) -> None:
        for raw_line in input_path.read_text().splitlines():
            account, amount, status = raw_line.split(",")
            self.transactions.append(Transaction(account, int(amount), status))

    def calculate_summary(self) -> dict[str, int]:
        success = sum(item.status == "OK" for item in self.transactions)
        errors = sum(item.status == "ER" for item in self.transactions)
        total = sum(item.amount for item in self.transactions if item.status == "OK")
        return {"count": len(self.transactions), "success": success, "errors": errors, "total": total}

    def write_report(self, output_path: Path) -> None:
        summary = self.calculate_summary()
        output_path.write_text(f"{self.business_date},{summary}\n")


def run_night_batch(root: Path, business_date: str) -> Path:
    report = NightReport(business_date)
    report.read_input(root / "data/input/transactions.csv")
    output_path = root / "data/output/python-report.txt"
    report.write_report(output_path)
    return output_path


if __name__ == "__main__":
    run_night_batch(Path.cwd(), "20260919")
