#  This just test script to verify that something is working. 


$Date = Get-Date -UFormat "%Y-%m-%d_%H-%m-%S"
$LogFileName = "DriveMapping-" + "Detect-" + $date + ".log"
Start-Transcript -Path $(Join-Path $env:temp $LogFileName)



# For troubleshooting
Write-Output "Listing all mapped drives on system."
Get-PSDrive -PSProvider FileSystem
Write-Output "Get currently logged on user"
(Get-ChildItem Env:\USERNAME).Value

Stop-Transcript