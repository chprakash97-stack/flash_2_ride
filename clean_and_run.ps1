Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "CLEANING UNUSED IMPORTS & VERIFYING ALL 30 SCREENS..." -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan

$parcelFiles = @(
    "$PWD\lib\screens\booking\flash_parcel_screen.dart",
    "$PWD\lib\screens\booking\parcel_booking_screen.dart"
)

foreach ($pf in $parcelFiles) {
    if (Test-Path $pf) {
        $txt = Get-Content $pf -Raw -Encoding UTF8
        $txt = $txt -replace "import 'payment_method_screen\.dart';`r?`n?", ""
        [System.IO.File]::WriteAllText($pf, $txt, [System.Text.Encoding]::UTF8)
    }
}

Write-Host "Code cleaned! Running Flutter analyze..." -ForegroundColor Yellow
& flutter analyze

Write-Host "`nLaunching Flash 2 Ride on Chrome..." -ForegroundColor Green
& flutter run -d chrome