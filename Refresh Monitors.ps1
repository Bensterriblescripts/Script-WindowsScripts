Start-Process -FilePath "DisplaySwitch.exe" -ArgumentList "/internal"
Start-Sleep -Seconds 2
Start-Process -FilePath "DisplaySwitch.exe" -ArgumentList "/extend"