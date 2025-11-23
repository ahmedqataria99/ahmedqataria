# PowerShell helper: run Flutter analyze and save output to analyze.txt
# Usage: Open PowerShell in the project root and run:
#   .\scripts\run_analyze.ps1

Param()

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $projectRoot

Write-Host "Running 'flutter pub get'..." -ForegroundColor Cyan
flutter pub get

Write-Host "Running 'flutter analyze' and saving output to 'analyze.txt'..." -ForegroundColor Cyan
# Run analyze, capture both stdout and stderr, and save to analyze.txt
flutter analyze 2>&1 | Tee-Object -FilePath analyze.txt

if (Test-Path analyze.txt) {
    $full = Join-Path (Get-Location) 'analyze.txt'
    Write-Host "Analyze finished. Output saved to:`n$full" -ForegroundColor Green
    Write-Host "Opening analyze.txt in Notepad..." -ForegroundColor Cyan
    Start-Process notepad.exe $full
} else {
    Write-Host "analyze.txt not found - please check Flutter SDK and environment." -ForegroundColor Red
}
