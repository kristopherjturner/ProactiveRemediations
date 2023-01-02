try {
	if(-NOT (Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")){ Exit 1 };
	if((Get-ItemPropertyValue -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'EnableLinkedConnections' -ea SilentlyContinue) -eq 0) {  } else { Exit 1 };
}
catch { exit 1 }
return $true