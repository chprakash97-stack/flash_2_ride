# ==========================================================
# Flash2Ride - Only Remove Unnecessary Const from Blue Color
# ==========================================================
Write-Host "Removing unnecessary const keyword from Blue Color..." -ForegroundColor Cyan

$file = "lib\screens\home\home_screen.dart"

if (Test-Path $file) {
    # Only remove 'const ' before Color(0xFF2563EB) - touches nothing else
    (Get-Content $file -Raw).Replace("const Color(0xFF2563EB)", "Color(0xFF2563EB)") | Set-Content $file -Encoding UTF8
    Write-Host "[OK] Removed unnecessary const cleanly without touching any other code!" -ForegroundColor Green
}

Write-Host "`nRunning flutter analyze verification..." -ForegroundColor Cyan
flutter analyze