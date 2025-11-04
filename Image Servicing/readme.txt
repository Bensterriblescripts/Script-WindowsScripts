Mount the windows image

&'C:\Users\Ben\Downloads\tiny11.ps1' -ISO E -SCRATCH C
E is the iso image mount letter
C is obvious

Write the image using rufus and set any up any local account settings

After installing, do not install the internet drivers and pase windows update.

Install drivers

Restart

https://github.com/Bensterriblescripts/Script-WindowsScripts
Run the scripts you want

Restart


DISABLING DRIVER INSTALLATION VIA WINDOWS UPDATE: 
Through Device Installation Settings (simple)

On Windows 10/11, go to Settings → System → About → Advanced system settings → Hardware tab → Device Installation Settings.

Via Group Policy (Pro/Enterprise editions)
Open gpedit.msc.
Navigate to: Computer Configuration → Administrative Templates → Windows Components → Windows Update → Manage updates offered from Windows Update.

Locate the policy “Do not include drivers with Windows Updates”. Set it to Enabled. 
Windows Central

Also under Computer Configuration → Administrative Templates → System → Device Installation → Device Installation Restrictions, you can enable “Prevent installation of devices not described by other policy settings”. 
Microsoft Learn

Via Registry tweaks (for Home or scripting automation)

Example: Under HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate, set ExcludeWUDriversInQualityUpdate (DWORD) = 1. 
How-To Geek
Another: Under HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching, set SearchOrderConfig DWORD = 0 to block search order for drivers. 
pureinfotech.com