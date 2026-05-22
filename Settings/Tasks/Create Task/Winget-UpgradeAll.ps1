$TaskFolder = "C:\Tasks"
$ScriptPath = Join-Path $TaskFolder "Winget-UpgradeAll.ps1"
$LogPath = Join-Path $TaskFolder "Winget-UpgradeAll.log"
$TaskName = "Upgrade All Packages"

if (-not (Test-Path $TaskFolder)) {
    New-Item -Path $TaskFolder -ItemType Directory -Force | Out-Null
}

$ScriptContent = @'
$Log = "C:\Tasks\Winget-UpgradeAll.log"
$ErrorActionPreference = "Stop"

function Write-Log {
    param (
        [string]$Message,
        [string]$Level = "INFO"
    )

    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "[$Timestamp] [$Level] $Message" | Out-File $Log -Append
}

try {
    Write-Log "===== Run Started ====="

    $WingetPath = Get-Command winget -ErrorAction Stop
    Write-Log "winget found at: $($WingetPath.Source)"

    Write-Log "Starting winget upgrade..."

    $StdOutFile = "C:\Tasks\Winget-UpgradeAll-stdout.log"
    $StdErrFile = "C:\Tasks\Winget-UpgradeAll-stderr.log"

    & winget upgrade --all --silent --accept-package-agreements --accept-source-agreements --disable-interactivity `
        1> $StdOutFile `
        2> $StdErrFile

    $ExitCode = $LASTEXITCODE

    if (Test-Path $StdOutFile) {
        Write-Log "--- winget stdout ---"
        Get-Content $StdOutFile | Out-File $Log -Append
    }

    if (Test-Path $StdErrFile) {
        $StdErr = Get-Content $StdErrFile

        if ($StdErr) {
            Write-Log "--- winget stderr ---" "ERROR"
            $StdErr | Out-File $Log -Append
        }
    }

    if ($ExitCode -eq 0) {
        Write-Log "winget completed successfully. ExitCode: $ExitCode"
    }
    else {
        Write-Log "winget completed with a non-zero exit code. ExitCode: $ExitCode" "ERROR"
    }

    Remove-Item $StdOutFile, $StdErrFile -ErrorAction SilentlyContinue

    Write-Log "===== Run Finished =====`n"

    exit $ExitCode
}
catch {
    Write-Log "Script failed: $($_.Exception.Message)" "ERROR"
    Write-Log "Exception type: $($_.Exception.GetType().FullName)" "ERROR"

    if ($_.ScriptStackTrace) {
        Write-Log "Stack trace: $($_.ScriptStackTrace)" "ERROR"
    }

    Write-Log "===== Run Failed =====`n" "ERROR"

    exit 1
}
'@
$ScriptContent | Out-File -FilePath $ScriptPath -Encoding UTF8 -Force
$Action = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`""
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
    -RestartCount 1 `
    -RestartInterval (New-TimeSpan -Hours 1) `
    -ExecutionTimeLimit (New-TimeSpan -Hours 4) `
    -MultipleInstances IgnoreNew `
    -RunOnlyIfNetworkAvailable


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
    -Description "Runs winget upgrade --all silently and logs output to $LogPath"

Write-Host "Created script: $ScriptPath"
Write-Host "Created scheduled task: $TaskName"
Write-Host "Log file will be written to: $LogPath"