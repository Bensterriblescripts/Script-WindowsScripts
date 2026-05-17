# In Background of Folder
New-Item -Path 'HKCU:\Software\Classes\Directory\Background\shell\WindowsTerminal\command' -Force | Out-Null; Set-ItemProperty -Path
'HKCU:\Software\Classes\Directory\Background\shell\WindowsTerminal' -Name '(default)' -Value 'Open in Terminal'; Set-ItemProperty -Path
'HKCU:\Software\Classes\Directory\Background\shell\WindowsTerminal' -Name 'Icon' -Value (Get-Command wt.exe | Select-Object
-ExpandProperty Source); Set-ItemProperty -Path 'HKCU:\Software\Classes\Directory\Background\shell\WindowsTerminal\command' -Name
'(default)' -Value ('"' + "$env:LOCALAPPDATA\Microsoft\WindowsApps\wt.exe" + '" -d "%V"')

# When Selecting Folder
New-Item -Path 'HKCU:\Software\Classes\Directory\shell\WindowsTerminal\command' -Force | Out-Null; Set-ItemProperty -Path 'HKCU:
\Software\Classes\Directory\shell\WindowsTerminal' -Name '(default)' -Value 'Open in Terminal'; Set-ItemProperty -Path 'HKCU:
\Software\Classes\Directory\shell\WindowsTerminal' -Name 'Icon' -Value (Get-Command wt.exe | Select-Object -ExpandProperty Source); Set-
ItemProperty -Path 'HKCU:\Software\Classes\Directory\shell\WindowsTerminal\command' -Name '(default)' -Value ('"' +
"$env:LOCALAPPDATA\Microsoft\WindowsApps\wt.exe" + '" -d "%V"')