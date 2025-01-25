:: Remove Gallery from File Explorer
reg add HKEY_CURRENT_USER\Software\Classes\CLSID\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c} /f /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 0x00000000