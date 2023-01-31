<#
.DESCRIPTION
    Detects if the cumulative update KB5007253 - 2021-11 Cumulative Update Preview for Windows 10 is installed.
    If the installed it will marked as compliant.  If it isn't installed it will be marked as non-compliant then remediated.

.NOTES
    Author and Edited: Kristopher Turner (InvokeLLC)
#>

$Date = Get-Date -UFormat "%Y-%m-%d_%H-%m-%S"
$LogFileName = "Detect-" + "WindowsUpdate-KB5007253-" + $date + ".log"
Start-Transcript -Path $(Join-Path $env:temp $LogFileName)

$update = Get-Hotfix -Id KB5007253
try {
    if ($update -eq $null) {
        # Install the update
        Write-Host "KB5007253 Needed"
        Exit 1
    }
    else {
        # Update is already installed
        Write-Host "KB5007253 update is already installed"
        Exit 0
    };
}
catch {
    $errMsg = $_.Exception.Message
    Write-Host $errMsg
    exit 1
}

Stop-Transcript