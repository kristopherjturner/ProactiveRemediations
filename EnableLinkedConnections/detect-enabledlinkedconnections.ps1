<#
.DESCRIPTION
	Detects if Registry Key and Value exist.  If True then script will end and compliant.  If false it will end with Not compliant and trigger the remediation script.


.NOTES
	Author and Edited: Kristopher Turner (InvokeLLC)
#>


$Date = Get-Date -UFormat "%Y-%m-%d_%H-%m-%S"
$LogFileName = "Detect-" + "EnableLinkedConnections-" + $date + ".log"
Start-Transcript -Path $(Join-Path $env:temp $LogFileName)

try {
	if (-NOT (Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")) {
		# Remediate on exit code 1
		Write-Host "Registry Key Doesn't Exist."
		exit 1
	};
	if((Get-ItemPropertyValue -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'EnableLinkedConnections' -ea SilentlyContinue) -eq 1) {
		Write-Host "EnableLinkedConnection exist and is enabled"
		exit 0
	} else { 
		Write-Host "EnableLinkedConnection doesn't exist"
		exit 1 };
}
catch {
	$errMsg = $_.Exception.Message
	Write-Host $errMsg
	exit 1
}

Stop-Transcript