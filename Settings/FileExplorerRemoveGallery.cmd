@echo off
net session >nul 2>&1
if %errorlevel% neq 0 (
    mshta "vbscript:CreateObject(""Shell.Application"").ShellExecute(""cmd.exe"", ""/c """"%~f0"""" "", """", ""runas"", 1)(window.close)"
    exit /b
)

reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c} /f