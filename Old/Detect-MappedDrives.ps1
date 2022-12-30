<#
.DESCRIPTION
	Detects if user already has Azure File Share mapped.  If detected it will exit script and not run remediation script.
	If not detected it will then detected if user can connect to Azure File Share via port 445. If user can connect via port 445 the remediation
	script will run. If user can't connect it will exit.


.NOTES
	Author and Edited: Kristopher Turner (InvokeLLC)
	Make sure to change change variables!!!

#>

$ShareName = "Documentation"
$StorageAccount = "pnwfs10fileshare"


$Date = Get-Date -UFormat "%Y-%m-%d_%H-%m-%S"
$LogFileName = "DriveMapping-" + "Detect-" + $ShareName + "-" + $date + ".log"
Start-Transcript -Path $(Join-Path $env:temp $LogFileName)


$Path = "\\$StorageAccount.file.core.windows.net\$ShareName"

# For troubleshooting
$PSDrive = Get-PSDrive | Where-Object{$_.DisplayRoot -eq $path}
$PSDrive

try {
	if (Get-PSDrive | Where-Object{$_.DisplayRoot -eq $path}) {
		Write-Host "Drive is mapped"
		Exit 0
	} else {
		Write-Host "Drive is not mapped"
	}
}
catch {
	$errMsg = $_.Exception.Message
	Write-Host $errMsg
	Exit 1
}
Stop-Transcript
