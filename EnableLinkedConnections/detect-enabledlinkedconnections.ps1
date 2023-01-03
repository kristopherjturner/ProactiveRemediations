<#
.DESCRIPTION
	Detects if Registry Key and Value exist.  If True then script will end and compliant.  If false it will end with Not compliant and trigger the remediation script.


.NOTES
	Author and Edited: Kristopher Turner (InvokeLLC)
	
#>


$Date = Get-Date -UFormat "%Y-%m-%d_%H-%m-%S"
$LogFileName = "Detect-" + "EnableLinkedConnections-" + $date + ".log"
Start-Transcript -Path $(Join-Path $env:temp $LogFileName)

$Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$Name = "EnableLinkedConnections"
$Value = "1"


try {
	$Registry = Get-ItemProperty -Path $Path -Name $Name -ErrorAction Stop | Select-Object -ExpandProperty $Name
	If ($Registry -eq $Value) {
		Write-Out "Compliant"
		Exit 0
	}
	Write-Warning "Not Compliant"
	Exit 1

}
catch { 
	Write-Warning "Not Compliant"
	exit 1 
}

Stop-Transcript