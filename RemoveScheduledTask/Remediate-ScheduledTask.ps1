<#
.DESCRIPTION
	Remediates a machine by removing the detected scheduled task that is installed.


.NOTES
	Author and Edited: Kristopher Turner (InvokeLLC)
	Make sure to change change variables!!!

#>


$LogFileName = "Remediate-IntuneDriveMappingScheduledTask-AuditTestOmid-" + $date + ".log"
Start-Transcript -Path $(Join-Path -Path $env:temp -ChildPath "$LogFileName")
Write-Output "Running as System --> removing scheduled task which will ran on user logon"

Write-Host "Removing AuditTestOmid Scheduled Task."
Unregister-ScheduledTask -TaskName 'IntuneDriveMapping-audittestomid' -Confirm:$false


Stop-Transcript
