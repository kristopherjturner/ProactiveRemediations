<#
.DESCRIPTION
	Detects if the registry key CloudKerberosTicketRetrievalEnabled exist and it is enabled.
	If the value set on it is correct and be marked as compiant.  If it is it doesn't exist  or the value is incorrect
	it will be markd as non-compliant then remediated.

.NOTES
	Author and Edited: Kristopher Turner (InvokeLLC)
#>


$Date = Get-Date -UFormat "%Y-%m-%d_%H-%m-%S"
$LogFileName = "Detect-" + "CloudKerberosTicketRetrievalEnabled-" + $date + ".log"
Start-Transcript -Path $(Join-Path $env:temp $LogFileName)

try {
	if (-NOT (Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\Kerberos\Parameters")) {
		# Remediate on ext code 1
		Write-Host "Registry key doesn't exist"
		exit 1
	};
	if ((Get-ItemPropertyValue -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\Kerberos\Parameters' -Name 'CloudKerberosTicketRetrievalEnabled' -ea SilentlyContinue) -eq 1) {
		Write-Host "CloudKerberosTicketRetrievalEnabled exist and is enabled"
		exit 0
	}
 else {
		Write-Host "CloudKerberosTicketRetrievalEnabled doesn't exist or is not enabled"
		exit 1
	};
}
catch {
	$errMsg = $_.Exception.Message
	Write-Host $errMsg
	exit 1
}

Stop-Transcript