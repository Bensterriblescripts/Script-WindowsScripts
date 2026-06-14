$ErrorActionPreference = 'Stop'

$MenuName = 'Launch Claude'
$MenuText = 'Launch Claude'

$WtExe = (Get-Command wt.exe -ErrorAction Stop).Source
$PowerShellExe = (Get-Command powershell.exe -ErrorAction Stop).Source

$ClaudeCommand = Get-Command claude -ErrorAction Stop | Select-Object -First 1
$ClaudePath = $ClaudeCommand.Source

if ([string]::IsNullOrWhiteSpace($ClaudePath)) {
    $ClaudePath = $ClaudeCommand.Definition
}

if ([string]::IsNullOrWhiteSpace($ClaudePath)) {
    throw 'Claude was found, but its executable path could not be determined.'
}

$DefaultIcon = (Get-ItemProperty 'Registry::HKEY_CLASSES_ROOT\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\DefaultIcon' -Name '(default)' -ErrorAction SilentlyContinue).'(default)'
$IconPath = if (Test-Path -LiteralPath $ClaudePath) { $ClaudePath } elseif ($DefaultIcon) { $DefaultIcon } else { "$env:SystemRoot\System32\imageres.dll,-109" }

$QuotedClaudePath = "'" + ($ClaudePath -replace "'", "''") + "'"
$ClaudeInvocation = "& $QuotedClaudePath --dangerously-skip-permissions"
$EncodedCommand = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($ClaudeInvocation))

$Targets = @(
    @{
        KeyPath = "HKCU:\Software\Classes\Directory\shell\$MenuName"
        Command = "`"$WtExe`" -d `"%1`" `"$PowerShellExe`" -NoExit -ExecutionPolicy Bypass -EncodedCommand $EncodedCommand"
    },
    @{
        KeyPath = "HKCU:\Software\Classes\Directory\Background\shell\$MenuName"
        Command = "`"$WtExe`" -d `"%V`" `"$PowerShellExe`" -NoExit -ExecutionPolicy Bypass -EncodedCommand $EncodedCommand"
    }
)

foreach ($Target in $Targets) {
    $MenuKey = $Target.KeyPath
    $CommandKey = Join-Path $MenuKey 'command'

    New-Item -Path $MenuKey -Force | Out-Null
    New-Item -Path $CommandKey -Force | Out-Null

    New-ItemProperty -Path $MenuKey -Name '(Default)' -Value $MenuText -PropertyType String -Force | Out-Null
    New-ItemProperty -Path $MenuKey -Name 'Icon' -Value $IconPath -PropertyType String -Force | Out-Null
    New-ItemProperty -Path $CommandKey -Name '(Default)' -Value $Target.Command -PropertyType String -Force | Out-Null
}
