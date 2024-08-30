# Set the menu item text and the base URL
$menuText = "Search CRM"
$baseUrl = "https://www.google.com/search?q="
$userRegPath = "Registry::HKEY_CURRENT_USER\Software\Classes"

# Function to clean text (remove symbols and non-letter characters)
$cleanTextFunction = @'
function Clean-Text {
    param([string]$text)
    return ($text -replace '[^a-zA-Z]', '').Trim()
}
'@
New-Item -Path "$userRegPath\*\shell\SearchCRM" -Force
Set-ItemProperty -Path "$userRegPath\*\shell\SearchCRM" -Name "(Default)" -Value $menuText
New-Item -Path "$userRegPath\*\shell\SearchCRM\command" -Force
$command = "powershell.exe -Command `"& { $cleanTextFunction ; `$selectedText = `$args[0]; if (`$selectedText) { `$cleanedText = Clean-Text `$selectedText; Start-Process '$baseUrl' + [System.Web.HttpUtility]::UrlEncode(`$cleanedText) } else { `$wordAtCursor = Clean-Text (Get-Clipboard -Raw); Start-Process '$baseUrl' + [System.Web.HttpUtility]::UrlEncode(`$wordAtCursor) }}`" %1"
Set-ItemProperty -Path "$userRegPath\*\shell\SearchCRM\command" -Name "(Default)" -Value $command

# Empty Space
New-Item -Path "$userRegPath\Directory\Background\shell\SearchCRM" -Force
Set-ItemProperty -Path "$userRegPath\Directory\Background\shell\SearchCRM" -Name "(Default)" -Value "$menuText Clipboard"
New-Item -Path "$userRegPath\Directory\Background\shell\SearchCRM\command" -Force

$command = "powershell.exe -Command `"& { $cleanTextFunction ; `$clipboardContent = Get-Clipboard -Raw; if (`$clipboardContent) { `$cleanedText = Clean-Text `$clipboardContent; Start-Process '$baseUrl' + [System.Web.HttpUtility]::UrlEncode(`$cleanedText) } sleep(2)}`""
Set-ItemProperty -Path "$userRegPath\Directory\Background\shell\SearchCRM\command" -Name "(Default)" -Value $command

Stop-Process -Name explorer -Force
Start-Sleep -Seconds 1
Start-Process explorer.exe