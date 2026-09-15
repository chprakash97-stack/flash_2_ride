# Flash 2 Ride - Screen Audit Script
$screensDir = "lib/screens"
$expectedScreens = @(
    "login_screen.dart",
    "register_screen.dart",
    "home_screen.dart",
    "ride_booking_screen.dart",
    "tracking_screen.dart",
    "profile_screen.dart"
)

$foundCount = 0
$totalExpected = $expectedScreens.Count

Write-Host "--- Starting Screen Audit ---" -ForegroundColor Cyan

foreach ($screen in $expectedScreens) {
    $fullPath = Join-Path $screensDir $screen
    if (Test-Path $fullPath) {
        Write-Host "[FOUND] $screen" -ForegroundColor Green
        $foundCount++
    } else {
        Write-Host "[MISSING] $screen" -ForegroundColor Red
    }
}

$pct = [math]::Round(($foundCount / $totalExpected) * 100)

$color = "Yellow"
if ($foundCount -eq $totalExpected) { $color = "Green" }

Write-Host "-----------------------------"
Write-Host "Found: $foundCount / $totalExpected" -ForegroundColor $color
Write-Host "Completion: $pct %" -ForegroundColor $color