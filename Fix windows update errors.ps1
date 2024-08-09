# # Copied from a facebook comment, based on the batch version: https://answers.microsoft.com/en-us/windows/forum/all/how-toreset-windows-update-components-in-windows/14b86efd-1420-4916-9832-829125b1e8a3
$ErrorActionPreference = "SilentlyContinue"

# Clear settings visibility (sometimes hides options)
$Value = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer").SettingsPageVisibility
if ($Value) {
    Write-Host "Removing Settings Page Visibility Config: $($Value)"
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name SettingsPageVisibility | Out-Null
    $Verify = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer").SettingsPageVisibility
    if (!($Verify)) { 
        Write-Host "Successfully Cleared Settings" 
    } 
    else { 
        Write-Host "Failed to Clear Settings" 
    }
} 
else { 
    Write-Host "Settings Page Visibility Config already Cleared" 
}

# Enable system level windows update
$Value2 = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\WindowsUpdate").DisableWindowsUpdateAccess
if ($Value2 -eq 1) {
    Write-Host "Re-enabling Windows Updates for System Level"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\WindowsUpdate" -Name DisableWindowsUpdateAccess -Value 0 | Out-Null
    $Verify2 = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\WindowsUpdate").DisableWindowsUpdateAccess
    if ($Verify2 -eq 0) { 
        Write-Host "Successfully Cleared Settings" 
    } else { 
        Write-Host "Failed to Clear Settings" 
    }
} 
else { 
    Write-Host "Windows update already enabled for System level" 
}

# Stop update services
$Services = @("BITS","wuauserv","appidsvc","cryptsvc")
ForEach ($Service in $Services) {
    Write-Host "Stopping Service: " -NoNewline
    Write-Host "$($Service)" -ForegroundColor Green
    Stop-Service -Name "$($Service)" | Out-Null
}

# Remove QMGR files
Write-Host "Remove QMGR Data Files..."
Remove-Item "$env:allusersprofile\Application Data\Microsoft\Network\Downloader\qmgr*.dat" -ErrorAction SilentlyContinue

# Rename the software dist & carroot folder to create a new one
Write-Host "Renaming the Software Distribution and CatRoot Folder..."
if (Get-Item -Path $env:systemroot\SoftwareDistribution.bak) { 
    Remove-Item -Path $env:systemroot\SoftwareDistribution.bak -Recurse -Force -Confirm:$False 
}
Rename-Item $env:systemroot\SoftwareDistribution SoftwareDistribution.bak -ErrorAction SilentlyContinue
if (Get-Item -Path $env:systemroot\system32\catroot2.bak) { 
    Remove-Item -Path $env:systemroot\system32\catroot2.bak -Recurse -Force -Confirm:$False 
}
Rename-Item $env:systemroot\System32\Catroot2 catroot2.bak -ErrorAction SilentlyContinue

# Clear the previous update log
Write-Host "Removing old Windows Update log..."
if (Get-Item -Path $env:systemroot\WindowsUpdate.log) { 
    Remove-Item $env:systemroot\WindowsUpdate.log -Force -Confirm:$False -ErrorAction SilentlyContinue 
}

# Set windows update to default
Write-Host "Resetting the Windows Update Services to defualt settings..."
"sc.exe sdset bits D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)"
"sc.exe sdset wuauserv D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)"

# Re-register the DLLs
Set-Location $env:systemroot\system32
$DLLs = @(
"atl.dll","urlmon.dll","mshtml.dll","shdocvw.dll","browseui.dll","jscript.dll","vbscript.dll","scrrun.dll","msxml.dll",
"msxml3.dll","msxml6.dll","actxprxy.dll","softpub.dll","wintrust.dll","dssenh.dll","rsaenh.dll","gpkcsp.dll","sccbase.dll",
"slbcsp.dll","cryptdlg.dll","oleaut32.dll","ole32.dll","shell32.dll","initpki.dll","wuapi.dll","wuaueng.dll","wuaueng1.dll",
"wucltui.dll","wups.dll","wups2.dll","wuweb.dll","qmgr.dll","qmgrprxy.dll","wucltux.dll","muweb.dll","wuwebv.dll")
ForEach ($DLL in $DLLs) {
    Write-Host "Registering DLL: " -NoNewline
    Write-Host "$($DLL)" -ForegroundColor Green
    Start-Process regsvr32.exe -ArgumentList "/s $($DLL)" -Wait -NoNewWindow -PassThru
}

# Remove the windows update registry entries
Write-Host "Removing Windows Update RegKeys"
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" -Name AccountDomainSid | Out-Null
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" -Name PingID | Out-Null
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" -Name SusClientId | Out-Null

# Reset the network adaptor
Write-Host "Resetting the WinSock..."
netsh winsock reset
netsh winhttp reset proxy
Write-Host "Delete all BITS jobs..."
Get-BitsTransfer | Remove-BitsTransfer

# Start the update services again
ForEach ($Service in $Services) {
    Write-Host "Starting Service: " -NoNewline
    Write-Host "$($Service)" -ForegroundColor Green
    Start-Service -Name "$($Service)" | Out-Null
}

# Enable update discovery again
Write-Host "Forcing Discovery..."
Start-Process wuauclt -ArgumentList "/resetauthorization /detectnow" -Wait -NoNewWindow -PassThru