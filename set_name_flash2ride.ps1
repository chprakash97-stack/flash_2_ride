Write-Host "Setting Application Label to Single Word 'Flash2Ride' (No Gaps)..." -ForegroundColor Green

$projectDir = "C:\Users\DELL\Desktop\flash_2_ride"
Set-Location $projectDir

# 1. Update AndroidManifest.xml with "Flash2Ride" (Single word, No spaces)
$manifestPath = Join-Path $projectDir "android\app\src\main\AndroidManifest.xml"
if (Test-Path $manifestPath) {
    $content = Get-Content $manifestPath -Raw
    $content = $content -replace 'android:label="[^"]*"', 'android:label="Flash2Ride"'
    Set-Content -Path $manifestPath -Value $content -Encoding UTF8
    Write-Host "Updated Android Application Label to 'Flash2Ride'!" -ForegroundColor Green
}

# 2. Update Android strings.xml
$stringsDir = Join-Path $projectDir "android\app\src\main\res\values"
if (Test-Path $stringsDir) {
    $stringsPath = Join-Path $stringsDir "strings.xml"
    @'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">Flash2Ride</string>
</resources>
'@ | Set-Content -Path $stringsPath -Encoding UTF8
}

# 3. Update Web App Title & Manifest
$webIndex = Join-Path $projectDir "web\index.html"
if (Test-Path $webIndex) {
    $c = Get-Content $webIndex -Raw
    $c = $c -replace '<title>[^<]*</title>', '<title>Flash2Ride</title>'
    Set-Content -Path $webIndex -Value $c -Encoding UTF8
}

$manifestJson = Join-Path $projectDir "web\manifest.json"
if (Test-Path $manifestJson) {
    $c = Get-Content $manifestJson -Raw
    $c = $c -replace '"name":\s*"[^"]*"', '"name": "Flash2Ride"'
    $c = $c -replace '"short_name":\s*"[^"]*"', '"short_name": "Flash2Ride"'
    Set-Content -Path $manifestJson -Value $c -Encoding UTF8
}

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " App Label Successfully Set to Single Word 'Flash2Ride'!                      " -ForegroundColor Green
Write-Host " Icons & Screens 1 to 5 are 100% UNTOUCHED!                                   " -ForegroundColor Green
Write-Host " Run 'flutter run' to apply on your mobile!                                   " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green