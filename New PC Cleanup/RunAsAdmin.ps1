# Turn Off Hibernation
powercfg -h off


## Context Menus

# Remove Home from File Explorer
New-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}" -Name "HiddenByDefault" -Value 1 -PropertyType DWord

# Remove Pin to Quick Access from Recycle Bin
New-Item -Path "Registry::HKEY_CLASSES_ROOT\Folder\shell\pintohome" -Force
New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Folder\shell\pintohome" -Name "AppliesTo" -Value 'NOT System.ParsingName:=\"::{645FF040-5081-101B-9F08-00AA002F954E}\"' -PropertyType String -Force

# Remove Scan with Defender - Folders
Remove-Item -Path "Registry::HKEY_CLASSES_ROOT\Directory\shellex\ContextMenuHandlers\EPP"
# Remove Pin to Start - Folders 
Remove-Item -Path "Registry::HKEY_CLASSES_ROOT\Folder\ShellEx\ContextMenuHandlers\pintostart"
# Remove Pin to Home - Folders
Remove-Item -Path "Registry::HKEY_CLASSES_ROOT\Folder\shell\pintohome"