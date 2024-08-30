New-Item -Path "Registry::HKEY_CLASSES_ROOT\Folder\shell\pintohome" -Force
New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Folder\shell\pintohome" -Name "AppliesTo" -Value 'NOT System.ParsingName:=\"::{645FF040-5081-101B-9F08-00AA002F954E}\"' -PropertyType String -Force

Stop-Process -Name explorer -Force
Start-Sleep -Seconds 1
Start-Process explorer.exe