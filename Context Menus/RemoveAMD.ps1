if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
  Start-Process powershell.exe -Verb RunAs -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-File',('"{0}"'-f$PSCommandPath); exit
}

$traditional = @(
    "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell",
    "Registry::HKEY_CLASSES_ROOT\Directory\Background\shellex\ContextMenuHandlers",
    "Registry::HKEY_CLASSES_ROOT\Directory\shell",
    "Registry::HKEY_CLASSES_ROOT\Directory\shellex\ContextMenuHandlers"
)

foreach ($path in $traditional) {
    Get-ChildItem $path -ErrorAction SilentlyContinue |
    Where-Object { $_.PSChildName -match "AMD|Radeon|NvCpl|Nvidia|NVIDIA" } |
    ForEach-Object { Remove-Item -Path $_.PSPath -Recurse -Force -ErrorAction SilentlyContinue }
}

Remove-Item -Path "HKLM:\SOFTWARE\Classes\PackagedCom\Package\AdvancedMicroDevicesInc-RSXCM_22.10.0.0_x64__v2es6h43hjn86" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "HKLM:\SOFTWARE\Classes\PackagedCom\ClassIndex\{FDADFEE3-02D1-4E7C-A511-380F4C98D73B}" -Recurse -Force -ErrorAction SilentlyContinue

Stop-Process -Name explorer -Force
Start-Process explorer