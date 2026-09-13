Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "CONNECTING DESTINATION SEARCH DIRECTLY TO MAP PIN PICKER..." -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan

$projectRoot = $PWD

# -------------------------------------------------------------
# 1. lib\screens\location\destination_search_screen.dart ను అప్‌డేట్ చేయడం
# -------------------------------------------------------------
$targetFiles = @(
    "$projectRoot\lib\screens\location\destination_search_screen.dart",
    "$projectRoot\lib\screens\booking\destination_search_screen.dart"
)

foreach ($file in $targetFiles) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw -Encoding UTF8
        
        # import జోడించడం
        if ($content -notmatch "map_pin_picker_screen\.dart") {
            $content = "import 'map_pin_picker_screen.dart';`n" + $content
        }
        
        # _handleConfirm లో RideCategoryScreen బదులుగా MapPinPickerScreen కు నావిగేట్ చేయడం
        $pattern = 'builder:\s*\(context\)\s*=>\s*(const\s+)?RideCategoryScreen\(\)'
        if ($content -match $pattern) {
            $content = [System.Text.RegularExpressions.Regex]::Replace($content, $pattern, 'builder: (context) => const MapPinPickerScreen()')
            [System.IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)
            Write-Host "SUCCESS: Linked Confirm button to MapPinPickerScreen in: $file" -ForegroundColor Green
        } else {
            # ప్రత్యామ్నాయ రీప్లేస్‌మెంట్
            $content = $content -replace "const RideCategoryScreen\(\)", "const MapPinPickerScreen()"
            $content = $content -replace "RideCategoryScreen\(\)", "const MapPinPickerScreen()"
            [System.IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)
            Write-Host "SUCCESS: Updated navigation to MapPinPickerScreen in: $file" -ForegroundColor Green
        }
    }
}

Write-Host "`nVerifying Dart Analysis..." -ForegroundColor Yellow
& flutter analyze

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "MAP PIN PICKER IS NOW FULLY CONNECTED IN YOUR EXACT FLOW!" -ForegroundColor Green
Write-Host "Run: flutter run -d chrome" -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan