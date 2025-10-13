# # # Created by Ben
#  Based on the batch version: https://answers.microsoft.com/en-us/windows/forum/all/how-toreset-windows-update-components-in-windows/14b86efd-1420-4916-9832-829125b1e8a3

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
$Services = @("BITS","wuauserv","appidsvc","cryptsvc", "msiserver", "usosvc", "waasmedicsvc", "dosvc")
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

# Clear Component Store Cache
Write-Host "Clearing Component Store cache..."
DISM /Online /Cleanup-Image /StartComponentCleanup /ResetBase

# Delete pending.xml
Write-Host "Removing pending.xml if it exists..."
if (Test-Path "$env:systemroot\WinSxS\pending.xml") {
    takeown /f "$env:systemroot\WinSxS\pending.xml"
    icacls "$env:systemroot\WinSxS\pending.xml" /grant administrators:F
    Remove-Item "$env:systemroot\WinSxS\pending.xml" -Force -ErrorAction SilentlyContinue
}

# Clear (potentially) locked CBS Logs
Write-Host "Clearing CBS logs..."
if (Test-Path "$env:systemroot\Logs\CBS\CBS.log") {
    Remove-Item "$env:systemroot\Logs\CBS\*.log" -Force -ErrorAction SilentlyContinue
}
# Clear CBS Sessions folder (different from logs)
Write-Host "Clearing CBS Sessions..."
if (Test-Path "$env:systemroot\servicing\Sessions") {
    takeown /f "$env:systemroot\servicing\Sessions" /r /d y
    icacls "$env:systemroot\servicing\Sessions" /grant administrators:F /t
    Remove-Item "$env:systemroot\servicing\Sessions\*" -Recurse -Force -ErrorAction SilentlyContinue
}

# Fix Windows Update service registry corruption
Write-Host "Repairing Windows Update service registry..."
$wuRegPath = "HKLM:\SYSTEM\CurrentControlSet\Services\wuauserv"
if (Test-Path $wuRegPath) {
    Set-ItemProperty -Path $wuRegPath -Name Start -Value 3 -Force
    Set-ItemProperty -Path $wuRegPath -Name Type -Value 32 -Force -ErrorAction SilentlyContinue
}

# Repair WSUS Registries
Write-Host "Removing WSUS server configuration..."
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name WUServer -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name WUStatusServer -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name UseWUServer -ErrorAction SilentlyContinue

# Perform Group Policy Update
Write-Host "Clearing Group Policy cache..."
Remove-Item "$env:systemroot\System32\GroupPolicy\Machine\Registry.pol" -Force -ErrorAction SilentlyContinue
Remove-Item "$env:systemroot\System32\GroupPolicy\User\Registry.pol" -Force -ErrorAction SilentlyContinue
echo N | gpupdate /force


# Clear DataStore and Download Folders
Write-Host "Clearing SoftwareDistribution subfolders..."
Remove-Item "$env:systemroot\SoftwareDistribution\DataStore\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$env:systemroot\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue


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
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" -Name SusClientIdValidation -ErrorAction SilentlyContinue

# Reset the windows sockets api
Write-Host "Resetting the WinSock..."
cmd.exe /c netsh winsock reset
cmd.exe /c netsh winhttp reset proxy
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
Start-Process usoclient -ArgumentList "StartScan" -Wait -NoNewWindow -PassThru

# Install .NET Framework 3.5 - Update issue on 24H2 systems
Write-Host "`nInstalling the .NET Framework (3.5)"
DISM /Online /Enable-Feature /FeatureName:NetFx3 /All
if ($LASTEXITCODE -ne 0) {
    Write-Host "Retrying .NET 3.5 with Windows Update as source..."
    DISM /Online /Enable-Feature /FeatureName:NetFx3 /All /LimitAccess:false
}

# Scan for any errors after retrieving the new image
Write-Host "`nScanning for corrupted files..."
$rerun = $false
sfc /scannow
$LASTEXITCODE = 0
if ($LASTEXITCODE -eq 2) {
    Write-Host "SFC: Found corrupted files but couldn't repair them. Adding another sfc after the DISM..." -ForegroundColor Red
    $rerun = $true
}

# Add corrupted packages
Write-Host "Checking for corrupt packages..."
DISM /Online /Get-Packages | Select-String "Install Pending|Staged|Superseded"

# Refresh the windows update image
Write-Host "`nRestoring image health..."
DISM /Online /Cleanup-Image /RestoreHealth
# If that failed, update source
if ($LASTEXITCODE -ne 0) {
    Write-Host "Retrying with explicit Windows Update source..."
    DISM /Online /Cleanup-Image /RestoreHealth /Source:WU
}

# If the last SFC failed, run it again.
if ($rerun) {
    sfc /scannow
    if ($LASTEXITCODE -eq 2) {
        Write-Host "SFC: Found corrupted files but couldn't repair them." -ForegroundColor Red
    }
}

Restart-Computer -Force