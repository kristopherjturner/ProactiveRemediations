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

$connectTestResult = Test-NetConnection -ComputerName "$storageaccount.file.core.windows.net" -Port 445
$connectTestResult.TcpTestSucceeded

# For troubleshooting

try {
	if (-NOT (Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2\##$storageaccount.file.core.windows.net#$sharename")) { Exit 1 }
	if ($connectTestResult.TcpTestSucceeded) {
		# Continue With script
		Write-Host ("Connection to storage account via 443 succesful. Script will continue.")
	}
	else {
		Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
		Exit 1
	}
}
catch { 
	Write-Warning "Not Compliant"
	Exit 1 
}

Stop-Transcript
