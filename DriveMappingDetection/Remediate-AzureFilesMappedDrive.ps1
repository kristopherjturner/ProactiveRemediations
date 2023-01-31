<#
.DESCRIPTION
    Remediate script will run if detect script passed.  The script will then find the next available drive letter and map the Azur File share.  
    After which the script will configure a scheduled task to make rue the mapped drive stays mapped.

.NOTES
	Author and Edited: Kristopher Turner (InvokeLLC)
	Make sure to change change variables!!!

#>

$ShareName = "" # - Azure File Name
$DriveLabel = "" # - Drive Label
$StorageAccount = "" # - Storage Account

$Date = Get-Date -UFormat "%Y-%m-%d_%H-%m-%S"
$LogFileName = "DriveMapping-" + "Remediate-" + $ShareName + $date + ".log"
Start-Transcript -Path $(Join-Path $env:temp $LogFileName)

function Test-RunningAsSystem {
    [CmdletBinding()]
    param()
    process {
        return [bool]($(whoami -user) -match "S-1-5-18")
    }
}

$Path = "\\$StorageAccount.file.core.windows.net\$ShareName"
$ProviderName = Get-WmiObject win32_logicaldisk | select-object ProviderName | where-object { $_.ProviderName -eq "$Path" }
$DriveLetter = (68..90 | ForEach-Object { $L = [char]$_; if ((Get-PSDrive).Name -notContains $L) { $L } })[0]
Write-Host ("$DriveLetter is next available.")

if ($ProviderName) {
    Write-Host $Path ("already exist.")
    Write-Host ("Exiting Script")
    Exit
}
else {
    Write-Host ("Mapped drive will continue.")
}


$connectTestResult = Test-NetConnection -ComputerName "$storageaccount.file.core.windows.net" -Port 445
if ($connectTestResult.TcpTestSucceeded) {
    Write-Host ("Connection to storage account via 443 succesful. Script will continue.")
}
else {
    Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
    Write-Host ("Skipping drive creation due to connectivity.")
    Exit
}



if (-not (Test-RunningAsSystem)) {

    $psDrives = Get-PSDrive | Where-Object { $_.Provider.Name -eq "FileSystem" -and $_.Root -notin @("$env:SystemDrive\", "D:\") } `
    | Select-Object @{N = "DriveLetter"; E = { $_.Name } }, @{N = "Path"; E = { $_.DisplayRoot } }

    try {
        #check if variable in unc path exists, e.g. for $env:USERNAME -> resolving
        if ($Path -match '\$env:') {
            $Path = $ExecutionContext.InvokeCommand.ExpandString($Path)
        }

        #if label is null we need to set it to empty in order to avoid error
        if ($null -eq $DriveLabel) {
            $DriveLabel = ""
        }

        $exists = $psDrives | Where-Object { $_.Path -eq $Path -or $_.DriveLetter -eq $DriveLetter }
        $process = $true

        if ($null -ne $exists -and $($exists.Path -eq $Path -and $exists.DriveLetter -eq $DriveLetter )) {
            Write-Output "Drive '$($DriveLetter):\' '$($Path)' already exists with correct Drive Letter and Path"
            $process = $false

        }
        else {
            # Mapped with wrong config -> Delete it
            Get-PSDrive | Where-Object { $_.DisplayRoot -eq $Path -or $_.Name -eq $DriveLetter } | Remove-PSDrive -EA SilentlyContinue
        }

        if ($process) {
            Write-Output "Mapping network drive $($Path)"
            $null = New-PSDrive -PSProvider FileSystem -Name $DriveLetter -Root $Path -Description $DriveLabel -Persist -Scope global -EA SilentlyContinue
				(New-Object -ComObject Shell.Application).NameSpace("$($DriveLetter):").Self.Name = $DriveLabel
        }
    }
    catch {
        $available = Test-Path $($Path)
        if (-not $available) {
            Write-Error "Unable to access path '$($Path)' verify permissions and authentication!"
        }
        else {
            Write-Error $_.Exception.Message
            Exit 1
        }
    }


    # Remove unassigned drives
    if ($removeStaleDrives -and $null -ne $psDrives) {
        $diff = Compare-Object -ReferenceObject $driveMappingConfig -DifferenceObject $psDrives -Property "DriveLetter" -PassThru | Where-Object { $_.SideIndicator -eq "=>" }
        foreach ($unassignedDrive in $diff) {
            Write-Warning "Drive '$($unassignedDrive.DriveLetter)' has not been assigned - removing it..."
            Remove-SmbMapping -LocalPath "$($unassignedDrive.DriveLetter):" -Force -UpdateProfile
        }
    }

    # Fix to ensure drives are mapped as persistent!
    $null = Get-ChildItem -Path HKCU:\Network -ErrorAction SilentlyContinue | ForEach-Object { New-ItemProperty -Name ConnectionType -Value 1 -Path $_.PSPath -Force -ErrorAction SilentlyContinue }
}
Stop-Transcript