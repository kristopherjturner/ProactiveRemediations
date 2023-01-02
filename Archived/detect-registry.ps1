# Reg2CI (c) 2022 by Roger Zander
try {
	if(-NOT (Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2\##pnwfs10fileshare.file.core.windows.net#audittestomid")){ return $false };
}
catch { return $false }
return $true
