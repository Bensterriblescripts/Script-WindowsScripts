## Run as Admin
## "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications"



## Microsoft Stuff Nobody Asked For

# Bing News
$bingNews = Get-ChildItem "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" | Where-Object {$_.Name -like "*BingNews_*"}
New-ItemProperty -Path $bingNews.PSPath -Name "Disabled" -Value 1
New-ItemProperty -Path $bingNews.PSPath -Name "DisabledByUser" -Value 1
New-ItemProperty -Path $bingNews.PSPath -Name "SleepDisabled" -Value 1
New-ItemProperty -Path $bingNews.PSPath -Name "IgnoreBatterySaver" -Value 0
New-ItemProperty -Path $bingNews.PSPath -Name "SleepIgnoreBatterySaver" -Value 0

# Bing Weather
$bingWeather = Get-ChildItem "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" | Where-Object {$_.Name -like "*BingWeather_*"}
New-ItemProperty -Path $bingWeather.PSPath -Name "Disabled" -Value 1
New-ItemProperty -Path $bingWeather.PSPath -Name "DisabledByUser" -Value 1
New-ItemProperty -Path $bingWeather.PSPath -Name "SleepDisabled" -Value 1
New-ItemProperty -Path $bingWeather.PSPath -Name "IgnoreBatterySaver" -Value 0
New-ItemProperty -Path $bingWeather.PSPath -Name "SleepIgnoreBatterySaver" -Value 0

# Bing Search
$bingSearch = Get-ChildItem "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" | Where-Object {$_.Name -like "*BingSearch_*"}
New-ItemProperty -Path $bingSearch.PSPath -Name "Disabled" -Value 1
New-ItemProperty -Path $bingSearch.PSPath -Name "DisabledByUser" -Value 1
New-ItemProperty -Path $bingSearch.PSPath -Name "SleepDisabled" -Value 1
New-ItemProperty -Path $bingSearch.PSPath -Name "IgnoreBatterySaver" -Value 0
New-ItemProperty -Path $bingSearch.PSPath -Name "SleepIgnoreBatterySaver" -Value 0

# Copilot
$copilot = Get-ChildItem "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" | Where-Object {$_.Name -like "*Copilot_*"}
New-ItemProperty -Path $copilot.PSPath -Name "Disabled" -Value 1
New-ItemProperty -Path $copilot.PSPath -Name "DisabledByUser" -Value 1
New-ItemProperty -Path $copilot.PSPath -Name "SleepDisabled" -Value 1
New-ItemProperty -Path $copilot.PSPath -Name "IgnoreBatterySaver" -Value 0
New-ItemProperty -Path $copilot.PSPath -Name "SleepIgnoreBatterySaver" -Value 0

# Widget Platform
$widgetPlatform = Get-ChildItem "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" | Where-Object {$_.Name -like "*WidgetsPlatformRuntime_*"}
New-ItemProperty -Path $widgetPlatform.PSPath -Name "Disabled" -Value 1
New-ItemProperty -Path $widgetPlatform.PSPath -Name "DisabledByUser" -Value 1
New-ItemProperty -Path $widgetPlatform.PSPath -Name "SleepDisabled" -Value 1
New-ItemProperty -Path $widgetPlatform.PSPath -Name "IgnoreBatterySaver" -Value 0
New-ItemProperty -Path $widgetPlatform.PSPath -Name "SleepIgnoreBatterySaver" -Value 0

# Dev Home
$devHome = Get-ChildItem "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" | Where-Object {$_.Name -like "*Windows.DevHome_*"}
New-ItemProperty -Path $devHome.PSPath -Name "Disabled" -Value 1
New-ItemProperty -Path $devHome.PSPath -Name "DisabledByUser" -Value 1
New-ItemProperty -Path $devHome.PSPath -Name "SleepDisabled" -Value 1
New-ItemProperty -Path $devHome.PSPath -Name "IgnoreBatterySaver" -Value 0
New-ItemProperty -Path $devHome.PSPath -Name "SleepIgnoreBatterySaver" -Value 0

# Clip Champ
$clipchamp = Get-ChildItem "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" | Where-Object {$_.Name -like "*ClipChamp_*"}
New-ItemProperty -Path $clipchamp.PSPath -Name "Disabled" -Value 1
New-ItemProperty -Path $clipchamp.PSPath -Name "DisabledByUser" -Value 1
New-ItemProperty -Path $clipchamp.PSPath -Name "SleepDisabled" -Value 1
New-ItemProperty -Path $clipchamp.PSPath -Name "IgnoreBatterySaver" -Value 0
New-ItemProperty -Path $clipchamp.PSPath -Name "SleepIgnoreBatterySaver" -Value 0


## Xbox

# Xbox TCUI
$xboxTCUI = Get-ChildItem "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" | Where-Object {$_.Name -like "*Xbox.TCUI_*"}
New-ItemProperty -Path $xboxTCUI.PSPath -Name "Disabled" -Value 1
New-ItemProperty -Path $xboxTCUI.PSPath -Name "DisabledByUser" -Value 1
New-ItemProperty -Path $xboxTCUI.PSPath -Name "SleepDisabled" -Value 1
New-ItemProperty -Path $xboxTCUI.PSPath -Name "IgnoreBatterySaver" -Value 0
New-ItemProperty -Path $xboxTCUI.PSPath -Name "SleepIgnoreBatterySaver" -Value 0

# Xbox Overlay
$xboxOverlay = Get-ChildItem "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" | Where-Object {$_.Name -like "*XboxGamingOverlay_*"}
New-ItemProperty -Path $xboxOverlay.PSPath -Name "Disabled" -Value 1
New-ItemProperty -Path $xboxOverlay.PSPath -Name "DisabledByUser" -Value 1
New-ItemProperty -Path $xboxOverlay.PSPath -Name "SleepDisabled" -Value 1
New-ItemProperty -Path $xboxOverlay.PSPath -Name "IgnoreBatterySaver" -Value 0
New-ItemProperty -Path $xboxOverlay.PSPath -Name "SleepIgnoreBatterySaver" -Value 0

# Xbox IDP
$xboxIDP = Get-ChildItem "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" | Where-Object {$_.Name -like "*XboxIdentityProvider_*"}
New-ItemProperty -Path $xboxIDP.PSPath -Name "Disabled" -Value 1
New-ItemProperty -Path $xboxIDP.PSPath -Name "DisabledByUser" -Value 1
New-ItemProperty -Path $xboxIDP.PSPath -Name "SleepDisabled" -Value 1
New-ItemProperty -Path $xboxIDP.PSPath -Name "IgnoreBatterySaver" -Value 0
New-ItemProperty -Path $xboxIDP.PSPath -Name "SleepIgnoreBatterySaver" -Value 0

# Xbox Speech to Text
$xboxSpeech = Get-ChildItem "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" | Where-Object {$_.Name -like "*XboxSpeechToTextOverlay_*"}
New-ItemProperty -Path $xboxSpeech.PSPath -Name "Disabled" -Value 1
New-ItemProperty -Path $xboxSpeech.PSPath -Name "DisabledByUser" -Value 1
New-ItemProperty -Path $xboxSpeech.PSPath -Name "SleepDisabled" -Value 1
New-ItemProperty -Path $xboxSpeech.PSPath -Name "IgnoreBatterySaver" -Value 0
New-ItemProperty -Path $xboxSpeech.PSPath -Name "SleepIgnoreBatterySaver" -Value 0



## External Software

# LG Monitor App
$lgMonitor = Get-ChildItem "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" | Where-Object {$_.Name -like "*LGElectronics.LGMonitorApp_*"}
New-ItemProperty -Path $lgMonitor.PSPath -Name "Disabled" -Value 1
New-ItemProperty -Path $lgMonitor.PSPath -Name "DisabledByUser" -Value 1
New-ItemProperty -Path $lgMonitor.PSPath -Name "SleepDisabled" -Value 1
New-ItemProperty -Path $lgMonitor.PSPath -Name "IgnoreBatterySaver" -Value 0
New-ItemProperty -Path $lgMonitor.PSPath -Name "SleepIgnoreBatterySaver" -Value 0



## Other Microsoft

# Gaming App
$gamingApp = Get-ChildItem "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" | Where-Object {$_.Name -like "*GamingApp_*"}
New-ItemProperty -Path $gamingApp.PSPath -Name "Disabled" -Value 1
New-ItemProperty -Path $gamingApp.PSPath -Name "DisabledByUser" -Value 1
New-ItemProperty -Path $gamingApp.PSPath -Name "SleepDisabled" -Value 1
New-ItemProperty -Path $gamingApp.PSPath -Name "IgnoreBatterySaver" -Value 0
New-ItemProperty -Path $gamingApp.PSPath -Name "SleepIgnoreBatterySaver" -Value 0

# StickyNotes
$stickyNotes = Get-ChildItem "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" | Where-Object {$_.Name -like "*MicrosoftStickyNotes_*"}
New-ItemProperty -Path $stickyNotes.PSPath -Name "Disabled" -Value 1
New-ItemProperty -Path $stickyNotes.PSPath -Name "DisabledByUser" -Value 1
New-ItemProperty -Path $stickyNotes.PSPath -Name "SleepDisabled" -Value 1
New-ItemProperty -Path $stickyNotes.PSPath -Name "IgnoreBatterySaver" -Value 0
New-ItemProperty -Path $stickyNotes.PSPath -Name "SleepIgnoreBatterySaver" -Value 0

# Zune Music
$zuneMusic = Get-ChildItem "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" | Where-Object {$_.Name -like "*ZuneMusic_*"}
New-ItemProperty -Path $zuneMusic.PSPath -Name "Disabled" -Value 1
New-ItemProperty -Path $zuneMusic.PSPath -Name "DisabledByUser" -Value 1
New-ItemProperty -Path $zuneMusic.PSPath -Name "SleepDisabled" -Value 1
New-ItemProperty -Path $zuneMusic.PSPath -Name "IgnoreBatterySaver" -Value 0
New-ItemProperty -Path $zuneMusic.PSPath -Name "SleepIgnoreBatterySaver" -Value 0

# Quick Assist
$quickAssist = Get-ChildItem "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" | Where-Object {$_.Name -like "*QuickAssist_*"}
New-ItemProperty -Path $quickAssist.PSPath -Name "Disabled" -Value 1
New-ItemProperty -Path $quickAssist.PSPath -Name "DisabledByUser" -Value 1
New-ItemProperty -Path $quickAssist.PSPath -Name "SleepDisabled" -Value 1
New-ItemProperty -Path $quickAssist.PSPath -Name "IgnoreBatterySaver" -Value 0
New-ItemProperty -Path $quickAssist.PSPath -Name "SleepIgnoreBatterySaver" -Value 0

# Feedback Hub
$feedbackHub = Get-ChildItem "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" | Where-Object {$_.Name -like "*WindowsFeedbackHub_*"}
New-ItemProperty -Path $feedbackHub.PSPath -Name "Disabled" -Value 1
New-ItemProperty -Path $feedbackHub.PSPath -Name "DisabledByUser" -Value 1
New-ItemProperty -Path $feedbackHub.PSPath -Name "SleepDisabled" -Value 1
New-ItemProperty -Path $feedbackHub.PSPath -Name "IgnoreBatterySaver" -Value 0
New-ItemProperty -Path $feedbackHub.PSPath -Name "SleepIgnoreBatterySaver" -Value 0

# Get Help
$getHelp = Get-ChildItem "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" | Where-Object {$_.Name -like "*GetHelp_*"}
New-ItemProperty -Path $getHelp.PSPath -Name "Disabled" -Value 1
New-ItemProperty -Path $getHelp.PSPath -Name "DisabledByUser" -Value 1
New-ItemProperty -Path $getHelp.PSPath -Name "SleepDisabled" -Value 1
New-ItemProperty -Path $getHelp.PSPath -Name "IgnoreBatterySaver" -Value 0
New-ItemProperty -Path $getHelp.PSPath -Name "SleepIgnoreBatterySaver" -Value 0

# Your Phone
$yourPhone = Get-ChildItem "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" | Where-Object {$_.Name -like "*YourPhone_*"}
New-ItemProperty -Path $yourPhone.PSPath -Name "Disabled" -Value 1
New-ItemProperty -Path $yourPhone.PSPath -Name "DisabledByUser" -Value 1
New-ItemProperty -Path $yourPhone.PSPath -Name "SleepDisabled" -Value 1
New-ItemProperty -Path $yourPhone.PSPath -Name "IgnoreBatterySaver" -Value 0
New-ItemProperty -Path $yourPhone.PSPath -Name "SleepIgnoreBatterySaver" -Value 0