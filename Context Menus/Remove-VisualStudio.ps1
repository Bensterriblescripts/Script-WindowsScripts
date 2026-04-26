if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
  Start-Process powershell.exe -Verb RunAs -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-File',('"{0}"'-f$PSCommandPath); exit
}

$ErrorActionPreference = 'Continue'

$keys = @(
    'Registry::HKEY_CLASSES_ROOT\Directory\shell\AnyCode',
    'Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\AnyCode',
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\shell\AnyCode',
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\Background\shell\AnyCode'
)

foreach ($key in $keys) {
    try {
        if (Test-Path -LiteralPath $key) {
            Remove-Item -LiteralPath $key -Recurse -Force -ErrorAction Stop
            Write-Host "Removed: $key"
        } else {
            Write-Host "Not found: $key"
        }
    }
    catch {
        Write-Error "Failed: $key -- $($_.Exception.Message)"
    }
}