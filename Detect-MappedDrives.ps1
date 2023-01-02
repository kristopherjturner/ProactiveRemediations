$ShareName = "DMS"
$StorageAccount = "pnwfs10fileshare"


$Date = Get-Date -UFormat "%Y-%m-%d_%H-%m-%S"
$LogFileName = "DriveMapping-" + "Detect-" + $ShareName + "-" + $date + ".log"
Start-Transcript -Path $(Join-Path $env:temp $LogFileName)


$Path = "\\$StorageAccount.file.core.windows.net\$ShareName"

function Test-RunningAsSystem {
    [CmdletBinding()]
    param()
    process {
        return [bool]($(whoami -user) -match "S-1-5-18")
    }
}

if (-not (Test-RunningAsSystem)) {

    # For troubleshooting
    $PSDrive = Get-PSDrive | Where-Object { $_.DisplayRoot -eq $path }
    $PSDrive
    Write-Output "Looking for mapped drive" $Path
    Write-Output "Listing all mapped drives on system."
    Get-PSDrive -PSProvider FileSystem

    Get-PSDrive | Where-Object { $_.DisplayRoot -eq $path }


    try {
        if (Get-PSDrive | Where-Object { $_.DisplayRoot -eq $Path }) {
            Write-Host "Drive is mapped"
            Exit 0
        }
        else {
            Write-Host "Drive is not mapped"
        }
    }
    catch {
        $errMsg = $_.Exception.Message
        Write-Host $errMsg
        Exit 1
    }
}   
Stop-Transcript
