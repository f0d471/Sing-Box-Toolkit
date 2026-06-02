# Sing-Box Toolkit - Stop Proxy
$ScriptDir = Split-Path $MyInvocation.MyCommand.Path -Parent
. "$ScriptDir\env.ps1"
$p = Get-Process -Name "sing-box" -ErrorAction SilentlyContinue
if ($p) { Write-Host "Stopping Sing-Box (PID: $($p.Id))..." -ForegroundColor Yellow; $p | Stop-Process -Force; Start-Sleep -Seconds 1; Write-Host "OK: Stopped" -ForegroundColor Green }
else { Write-Host "Sing-Box is not running" -ForegroundColor DarkGray }
Write-Host ""
Read-Host "Press Enter to return"
