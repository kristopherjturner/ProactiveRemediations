<#
.DESCRIPTION
    Installs cumulative update KB5007253 - 2021-11 Cumulative Update Preview for Windows 10.

.NOTES
    Author and Edited: Kristopher Turner (InvokeLLC)
#>

$Date = Get-Date -UFormat "%Y-%m-%d_%H-%m-%S"
$LogFileName = "Remediate" + "WindowsUpdate-KB5007253-" + $date + ".log"
Start-Transcript -Path $(Join-Path $env:temp $LogFileName)

# Install Update
Start-Process -FilePath "wusa.exe" -ArgumentList "/quiet /norestart /install /KB4565503" -Wait

Stop-Transcript

