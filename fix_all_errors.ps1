# ==========================================================
# Flash2Ride - Final Fix for 0 Issues
# ==========================================================
Write-Host "Fixing the final issue in location_search_screen.dart..." -ForegroundColor Cyan

$locScreen = "lib\screens\home\location_search_screen.dart"
if (Test-Path $locScreen) {
    $lines = [System.Collections.Generic.List[string]](Get-Content $locScreen)
    if ($lines.Count -ge 165) {
        $targetLine = $lines[164] # Line 165
        Write-Host "Current Line 165: $targetLine" -ForegroundColor Yellow
        
        # Replace _allPlaces[index] with _allPlaces.first
        $fixedLine = $targetLine -replace '_allPlaces(\[index\])?', '_allPlaces.first'
        $lines[164] = $fixedLine
        Set-Content -Path $locScreen -Value $lines -Encoding UTF8
        Write-Host "Fixed Line 165: $fixedLine" -ForegroundColor Green
    }
}

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "RUNNING FLUTTER ANALYZE VERIFICATION..." -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
flutter analyze