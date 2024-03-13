# Turn Off Hibernation
powercfg -h off

# Remove Gallery from explorer
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace_41040327\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}"
Remote-Item -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace_41040327\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}"

# Remove Home from Explorer
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "HubMode" -PropertyType DWORD -Value 1
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace_36354489\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}"


## Context Menus

# Remove Pin to Quick Access from Recycle Bin
New-Item -Path "Registry::HKEY_CLASSES_ROOT\Folder\shell\pintohome" -Force
New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Folder\shell\pintohome" -Name "AppliesTo" -Value 'NOT System.ParsingName:=\"::{645FF040-5081-101B-9F08-00AA002F954E}\"' -PropertyType String -Force

# Remove Scan with Defender - Folders
Remove-Item -Path "Registry::HKEY_CLASSES_ROOT\Directory\shellex\ContextMenuHandlers\EPP"
# Remove Pin to Start - Folders 
Remove-Item -Path "Registry::HKEY_CLASSES_ROOT\Folder\ShellEx\ContextMenuHandlers\pintostart"
# Remove Pin to Home - Folders
Remove-Item -Path "Registry::HKEY_CLASSES_ROOT\Folder\shell\pintohome"

# Remove Personalize from Desktop
Remove-Item -Path "Registry::HKEY_CLASSES_ROOT\DesktopBackground\Shell\Personalize"