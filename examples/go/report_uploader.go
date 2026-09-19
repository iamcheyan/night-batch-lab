package nightbatch

import (
	"fmt"
	"path/filepath"
)

type UploadResult struct {
	JobID   string
	Success bool
	Message string
}

type ReportUploader struct {
	RemoteDirectory string
}

func (u ReportUploader) ValidateReport(path string) UploadResult {
	if filepath.Ext(path) != ".xls" {
		return UploadResult{Success: false, Message: "XLS required"}
	}
	return UploadResult{Success: true, Message: "report accepted"}
}

func (u ReportUploader) Upload(jobID string, reportPath string) UploadResult {
	validation := u.ValidateReport(reportPath)
	if !validation.Success {
		validation.JobID = jobID
		return validation
	}
	return UploadResult{JobID: jobID, Success: true, Message: fmt.Sprintf("upload to %s", u.RemoteDirectory)}
}
