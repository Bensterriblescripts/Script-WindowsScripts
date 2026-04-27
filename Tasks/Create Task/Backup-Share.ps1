$TaskFolder = "C:\Tasks"
$ScriptPath = Join-Path $TaskFolder "Backup-Share.cmd"
$TaskName = "Backup Share Folder"

# Create task/script folder
if (-not (Test-Path $TaskFolder)) {
    New-Item -Path $TaskFolder -ItemType Directory -Force | Out-Null
}

$ScriptContent = @'
robocopy "D:\Share" "E:\Share" /E /COPY:DAT /DCOPY:DAT /R:3 /W:5 /MT:16 /TEE /LOG+:"C:\Tasks\Backup-Share.log" /NJH /NP
'@
$ScriptContent | Out-File -FilePath $ScriptPath -Encoding UTF8 -Force

$Action = New-ScheduledTaskAction `
    -Execute "cmd.exe" `
    -Argument "/d /c `"`"$ScriptPath`"`"" `
    -WorkingDirectory $TaskFolder
$Trigger = New-ScheduledTaskTrigger `
    -Weekly `
    -DaysOfWeek Friday `
    -At 11:00AM
$CurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$Principal = New-ScheduledTaskPrincipal `
    -UserId $CurrentUser `
    -LogonType S4U `
    -RunLevel Highest
$Settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -RestartCount 5 `
    -RestartInterval (New-TimeSpan -Hours 1) `
    -ExecutionTimeLimit (New-TimeSpan -Hours 4) `
    -MultipleInstances IgnoreNew

$ExistingTask = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
if ($ExistingTask) {
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
}

Register-ScheduledTask `
    -TaskName $TaskName `
    -Action $Action `
    -Trigger $Trigger `
    -Principal $Principal `
    -Settings $Settings `
    -Description "Runs Backup-Share.cmd from $TaskFolder"

Write-Host "Scheduled task created: $TaskName"
Write-Host "Command file: $ScriptPath"