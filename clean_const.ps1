# ==========================================================
# Flash2Ride - Remove Unnecessary Const (Zero Issues)
# ==========================================================
Write-Host "Cleaning unnecessary const keywords..." -ForegroundColor Cyan

$file = "lib\screens\home\home_screen.dart"

if (Test-Path $file) {
    $raw = Get-Content $file -Raw
    $raw = $raw.Replace("const Color(0xFF00A859)", "Color(0xFF00A859)")
    Set-Content -Path $file -Value $raw -Encoding UTF8
    Write-Host "[OK] Cleaned unnecessary const keywords in home_screen.dart" -ForegroundColor Green
}

Write-Host "`nRunning flutter analyze verification..." -ForegroundColor Cyan
flutter analyze