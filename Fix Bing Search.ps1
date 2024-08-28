if (Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -ErrorAction SilentlyContinue) {
    $val = Get-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -ErrorAction SilentlyContinue
    if ($val -and $val.BingSearchEnabled -eq 0) {
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Value 1
    }
    elseif ($val -and $val.BingSearchEnabled -eq 1) {
        New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Force
        New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Value 0 -Force
        Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Value 0
    }
}
else {
    New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Force
    New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Value 0 -Force
}

Stop-Process -Name explorer -Force
Start-Sleep -Seconds 1
Start-Process explorer.exe