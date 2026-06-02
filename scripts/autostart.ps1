# Sing-Box 开机自启管理
param([switch]$Remove)

$taskName = "Sing-Box"
$exePath = "E:\app\sing-box\sing-box.exe"
$configPath = "E:\app\sing-box\config.json"

if ($Remove) {
    Write-Host "移除开机自启..." -ForegroundColor Yellow
    try {
        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction Stop
        Write-Host "✅ 已取消开机自启" -ForegroundColor Green
    } catch {
        Write-Host "未找到开机自启任务" -ForegroundColor DarkGray
    }
} else {
    # 先删旧的（如果有）
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue

    Write-Host "设置开机自启..." -ForegroundColor Yellow

    $action = New-ScheduledTaskAction -Execute $exePath -Argument "run -c `"$configPath`""

    $trigger = New-ScheduledTaskTrigger -AtStartup

    $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

    $settings = New-ScheduledTaskSettingsSet `
        -AllowStartIfOnBatteries `
        -DontStopIfGoingOnBatteries `
        -StartWhenAvailable `
        -RestartCount 3 `
        -RestartInterval (New-TimeSpan -Minutes 1) `
        -MultipleInstances IgnoreNew

    # 注册计划任务
    Register-ScheduledTask -TaskName $taskName `
        -Action $action `
        -Trigger $trigger `
        -Principal $principal `
        -Settings $settings `
        -Description "Sing-Box 代理开机自动启动" `
        -Force | Out-Null

    Write-Host "✅ 开机自启已设置" -ForegroundColor Green
    Write-Host ""
    Write-Host "说明:" -ForegroundColor White
    Write-Host "  - 开机后自动以 SYSTEM 权限启动，无窗口" -ForegroundColor DarkGray
    Write-Host "  - 如果崩溃会自动重试 3 次（间隔 1 分钟）" -ForegroundColor DarkGray
    Write-Host "  - 双击 start.bat 不影响，会自动替换旧进程" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "取消: .\autostart.ps1 -Remove" -ForegroundColor DarkGray
}

Write-Host ""
Write-Host "按任意键退出..." -ForegroundColor DarkGray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
