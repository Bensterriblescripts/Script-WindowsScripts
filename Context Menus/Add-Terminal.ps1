$WtCommand = Get-Command wt.exe -ErrorAction SilentlyContinue
$WtLauncher = "$env:LOCALAPPDATA\Microsoft\WindowsApps\wt.exe"
if (-not (Test-Path $WtLauncher) -and $WtCommand -and (Test-Path $WtCommand.Source)) {
  $WtLauncher = $WtCommand.Source
}

$WtIcon = $null
$WtPackage = Get-AppxPackage Microsoft.WindowsTerminal -ErrorAction SilentlyContinue
if ($WtPackage) {
  $WtIcon = @(
    (Join-Path $WtPackage.InstallLocation 'Images\terminal_contrast-black.ico')
    (Join-Path $WtPackage.InstallLocation 'Images\terminal_contrast-white.ico')
    (Join-Path $WtPackage.InstallLocation 'WindowsTerminal.exe')
    (Join-Path $WtPackage.InstallLocation 'wt.exe')
  ) | Where-Object { Test-Path $_ } | Select-Object -First 1
}

if (-not $WtIcon -and $WtCommand -and (Test-Path $WtCommand.Source)) {
  $WtIcon = $WtCommand.Source
}

if (-not $WtIcon) {
  $WtIcon = "$env:SystemRoot\System32\shell32.dll,0"
}

foreach ($BaseKey in @(
  'HKCU:\Software\Classes\Directory\Background\shell\WindowsTerminal'
  'HKCU:\Software\Classes\Directory\shell\WindowsTerminal'
)) {
  New-Item -Path "$BaseKey\command" -Force | Out-Null
  Set-ItemProperty -Path $BaseKey -Name '(default)' -Value 'Open in Terminal'
  Set-ItemProperty -Path $BaseKey -Name 'Icon' -Value $WtIcon
  Set-ItemProperty -Path "$BaseKey\command" -Name '(default)' -Value ('"' + $WtLauncher + '" -d "%V"')
}
