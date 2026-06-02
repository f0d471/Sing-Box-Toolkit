# Sing-Box Toolkit - Start Proxy
$ScriptDir = Split-Path $MyInvocation.MyCommand.Path -Parent
. "$ScriptDir\env.ps1"
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Sing-Box - Start" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
$old = Get-Process -Name "sing-box" -ErrorAction SilentlyContinue
if ($old) { Write-Host "Stopping old process..." -ForegroundColor DarkGray; $old | Stop-Process -Force; Start-Sleep -Seconds 1 }
Write-Host "Starting..." -ForegroundColor Green
Start-Process -FilePath $SingBoxExe -ArgumentList "run", "-c", $ConfigPath -Verb RunAs -WindowStyle Hidden
Start-Sleep -Seconds 3
$p = Get-Process -Name "sing-box" -ErrorAction SilentlyContinue
if ($p) { Write-Host "OK: Started (PID: $($p.Id))" -ForegroundColor Green; Write-Host ""; Write-Host "Browse the web directly, no proxy config needed." -ForegroundColor White }
else { Write-Host "FAIL: Run as Administrator?" -ForegroundColor Red }
Write-Host ""
Read-Host "Press Enter to return"
