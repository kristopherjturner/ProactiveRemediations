<#
.DESCRIPTION
	Detects if user already has Azure File Share mapped.  If detected it will exit script and not run remediation script.
	If not detected it will then detected if user can connect to Azure File Share via port 445. If user can connect via port 445 the remediation
	script will run. If user can't connect it will exit.


.NOTES
	Author and Edited: Kristopher Turner (InvokeLLC)
	Make sure to change change variables!!!

#>

$ShareName = "audittestomid"
$StorageAccount = "pnwfs10fileshare"


$Date = Get-Date -UFormat "%Y-%m-%d_%H-%m-%S"
$LogFileName = "DriveMapping-" + "Detect-" + $ShareName + "-" + $date + ".log"
Start-Transcript -Path $(Join-Path $env:temp $LogFileName)

$RegistryKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2\##$storageaccount.file.core.windows.net#$sharename"

Write-Host "Looking to see if registry key exist."
$RegistryKey

# For troubleshooting

try {
	if(-NOT (Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2\##$storageaccount.file.core.windows.net#$sharename")){ Exit 1 };
}
catch { 
	Write-Warning "Drive Not Mapped"
	Exit 1 }
Exit 0

Stop-Transcript
