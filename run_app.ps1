Write-Host "Cleaning up unused imports..." -ForegroundColor Yellow

$files = @(
    "$PWD\lib\screens\ride\finding_driver_screen.dart",
    "$PWD\lib\screens\ride\live_tracking_screen.dart",
    "$PWD\lib\screens\tracking\live_tracking_screen.dart"
)

foreach ($f in $files) {
    if (Test-Path $f) {
        $txt = Get-Content $f -Raw -Encoding UTF8
        $txt = $txt -replace "import '\.\./\.\./core/config/routes\.dart';`r?`n?", ""
        $txt = $txt -replace "import '\.\./ride/cancel_ride_dialog\.dart';`r?`n?", ""
        [System.IO.File]::WriteAllText($f, $txt, [System.Text.Encoding]::UTF8)
    }
}

Write-Host "Launching Flutter Web on Chrome..." -ForegroundColor Green
flutter run -d chrome