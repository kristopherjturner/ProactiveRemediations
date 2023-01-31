<#
.DESCRIPTION
		Remediates and createsthe registry key CloudKerberosTicketRetrievalEnabled and
		assigns the correct value to enable it.


.NOTES
	Author and Edited: Kristopher Turner (InvokeLLC)
#>

$Date = Get-Date -UFormat "%Y-%m-%d_%H-%m-%S"
$LogFileName = "Remediate-" + "CloudKerberosTicketRetrievalEnabled-" + $date + ".log"
Start-Transcript -Path $(Join-Path $env:temp $LogFileName)


#># Reg2CI (c) 2022 by Roger Zander
if ((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\Kerberos\Parameters") -ne $true) { New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\Kerberos\Parameters" -force -ea SilentlyContinue };
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\Kerberos\Parameters' -Name 'CloudKerberosTicketRetrievalEnabled' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue;


Stop-Transcript