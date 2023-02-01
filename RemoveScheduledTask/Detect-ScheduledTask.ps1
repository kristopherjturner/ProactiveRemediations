<#
.DESCRIPTION
	Detects if user a scheduled task is installed.  If not, machine is compliant.


.NOTES
	Author and Edited: Kristopher Turner (InvokeLLC)
	Make sure to change change variables!!!

#>

$LogFileName = "Detect-IntuneDriveMappingScheduledTask-AuditTestOmid" + $date + ".log"
Start-Transcript -Path $(Join-Path -Path $env:temp -ChildPath "$LogFileName")
Write-Output "Running as System --> removing scheduled task which will ran on user logon"

try {
    if (Get-ScheduledTask -TaskName 'IntuneDriveMapping-audittestomid'){
        # Remediate on exit code 1
        Write-Host "AuditTestOmid Task Exist"
        exit 1
    } else {
        Write-Host "AuditTestOmid does not exits"
        exit 0
    }
}
catch {
	$errMsg = $_.Exception.Message
	Write-Host $errMsg
	exit 1
}

Stop-Transcript