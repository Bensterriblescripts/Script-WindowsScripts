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

# Pin to Start
Remove-Item -Path "Registry::HKEY_CLASSES_ROOT\*\shellex\ContextMenuHandlers\{a2a9545d-a0c2-42b4-9708-a0b2badd77c8}" -Force

# Remove AMD
New-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked"
New-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{6767B3BC-8FF7-11EC-B909-0242AC120002}" -Value 'AMDSoftwareAdrenalinEdition' -PropertyType String -Force

# Remove Restore Previous Versions
New-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Value '' -PropertyType String -Force




# Potential Locations
# HKEY_CLASSES_ROOT\AllFilesystemObjects\shellex\ContextMenuHandlers\
# HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved
# Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\shellex
# Also try: Easy Context Menu software