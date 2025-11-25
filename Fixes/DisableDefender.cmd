REM Needs to be run in safe mode

REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WinDefend" /v "DependOnService" /t REG_MULTI_SZ /d "RpcSs-DISABLED" /f