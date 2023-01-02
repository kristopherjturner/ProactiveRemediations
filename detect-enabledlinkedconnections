try {
	if(-NOT (Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")){ return $false };
	if((Get-ItemPropertyValue -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'EnableLinkedConnections' -ea SilentlyContinue) -eq 1) {  } else { return $false };
}
catch { return $false }
return $true


# https://reg2ps.azurewebsites.net/
# https://www.fmsinc.com/microsoftaccess/developer/mapped_drives_not_available.htm
