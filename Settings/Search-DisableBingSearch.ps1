# Disable Windows Web Search
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Value 0
# Disable Store Search - Didn't work
#Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "DisableSearchBoxSuggestions" -Value 1