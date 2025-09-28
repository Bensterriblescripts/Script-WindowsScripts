## Most often want these

# Home - File Explorer
New-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}" -Name "HiddenByDefault" -Value 1 -PropertyType DWord

# Pin to Quick Access - Recycle Bin
New-Item -Path "Registry::HKEY_CLASSES_ROOT\Folder\shell\pintohome" -Force
New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Folder\shell\pintohome" -Name "AppliesTo" -Value 'NOT System.ParsingName:=\"::{645FF040-5081-101B-9F08-00AA002F954E}\"' -PropertyType String -Force

# Remove Scan with Defender - Folders
Remove-Item -Path "Registry::HKEY_CLASSES_ROOT\Directory\shellex\ContextMenuHandlers\EPP"
Remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\shellex\ContextMenuHandlers\EPP"
Remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\*\shellex\ContextMenuHandlers\EPP"
# Pin to Start - Folders 
Remove-Item -Path "Registry::HKEY_CLASSES_ROOT\Folder\ShellEx\ContextMenuHandlers\pintostart"
Remove-Item -Path "Registry::HKEY_CLASSES_ROOT\*\shellex\ContextMenuHandlers\{a2a9545d-a0c2-42b4-9708-a0b2badd77c8}" -Force
# Pin to Home - Folders
Remove-Item -Path "Registry::HKEY_CLASSES_ROOT\Folder\shell\pintohome"
Remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Folder\*\shell\pintohomefile"

# AMD
New-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked"
New-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{6767B3BC-8FF7-11EC-B909-0242AC120002}" -Value 'AMDSoftwareAdrenalinEdition' -PropertyType String -Force

# Restore Previous Versions
New-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Value '' -PropertyType String -Force

# Visual Studio
Remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\shell\AnyCode"

# Encryption Menu
Remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\shellex\ContextMenuHandlers\EncryptionMenu"
Remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Folder\*\shell\UpdateEncryptionSettingsWork"
Remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Folder\*\shellex\ContextMenuHandlers\Open With EncryptionMenu"

# Share
Remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\shellex\ContextMenuHandlers\Sharing"
Remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\shellex\CopyHookHandlers\Sharing"
Remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\shellex\PropertySheetHandlers\Sharing"
Remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Folder\*\shellex\ContextMenuHandlers\Sharing"

# Open in new tab
Remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Folder\shell\opennewtab"

# LIbrary
Remove-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Folder\ShellEx\ContextMenuHandlers\Library Location"






# Potential Locations
# HKEY_CLASSES_ROOT\AllFilesystemObjects\shellex\ContextMenuHandlers\
# HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved
# Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\shellex
# Also try: Easy Context Menu software