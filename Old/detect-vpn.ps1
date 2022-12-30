try {
    if (Get-VpnConnection -AllUserConnection -Name "VPN" -ErrorAction Stop)
{Write-Host "Success"
Exit 0
}
}
catch {
    $errMSg = $_.Exception.Message
    write-host $errMSg
    Exit 1
}