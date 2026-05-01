$MenuName = 'Launch Codex'
@(
  "HKCU:\Software\Classes\Directory\shell\$MenuName",
  "HKCU:\Software\Classes\Directory\Background\shell\$MenuName"
) | ForEach-Object {
  Remove-Item -LiteralPath $_ -Recurse -Force -ErrorAction SilentlyContinue
}

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
  Start-Process powershell.exe -Verb RunAs -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-File',('"{0}"'-f$PSCommandPath); exit
}

@(
  "HKLM:\Software\Classes\Directory\shell\$MenuName",
  "HKLM:\Software\Classes\Directory\Background\shell\$MenuName"
) | ForEach-Object {
  Remove-Item -LiteralPath $_ -Recurse -Force -ErrorAction SilentlyContinue
}
