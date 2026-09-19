package lab.nightbatch;

import java.nio.file.Path;
import java.util.List;

public final class NightBatchRunner {
    private final String businessDate;

    public NightBatchRunner(String businessDate) {
        this.businessDate = businessDate;
    }

    public JobResult validateInput(Path inputFile) {
        if (!inputFile.toString().endsWith(".csv")) {
            return JobResult.error("CSV required");
        }
        return JobResult.success("input accepted");
    }

    public JobResult process(List<String> records) {
        if (records.isEmpty()) {
            return JobResult.error("no records");
        }
        return JobResult.success("processed " + records.size() + " records for " + businessDate);
    }

    public record JobResult(boolean success, String message) {
        public static JobResult success(String message) {
            return new JobResult(true, message);
        }

        public static JobResult error(String message) {
            return new JobResult(false, message);
        }
    }
}
