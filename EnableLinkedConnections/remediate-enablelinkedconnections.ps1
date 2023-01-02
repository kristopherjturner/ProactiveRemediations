<#
.DESCRIPTION
	Remediates EnableLinkedConnection Registry Value from 0 to 1.


.NOTES
	Author and Edited: Kristopher Turner (InvokeLLC)
	
#>


$Date = Get-Date -UFormat "%Y-%m-%d_%H-%m-%S"
$LogFileName = "Remediate-" + "EnableLinkedConnections-" + $date + ".log"
Start-Transcript -Path $(Join-Path $env:temp $LogFileName)


if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -force -ea SilentlyContinue };
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'EnableLinkedConnections' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue;


Stop-Transcript