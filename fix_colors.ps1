# ==========================================================
# Flash2Ride - Fix Colors in home_screen.dart (0 Issues)
# ==========================================================
Write-Host "Fixing colors in home_screen.dart..." -ForegroundColor Cyan

$file = "lib\screens\home\home_screen.dart"

if (Test-Path $file) {
    $raw = Get-Content $file -Raw
    
    # Replace AppColors with direct Flutter Colors (No imports needed)
    $raw = $raw.Replace("AppColors.primaryLight", "const Color(0xFFE8F8F0)")
    $raw = $raw.Replace("AppColors.primary", "const Color(0xFF00A859)")
    
    Set-Content -Path $file -Value $raw -Encoding UTF8
    Write-Host "[OK] Colors fixed cleanly without touching any other code!" -ForegroundColor Green
}

Write-Host "`nRunning flutter analyze verification..." -ForegroundColor Cyan
flutter analyze