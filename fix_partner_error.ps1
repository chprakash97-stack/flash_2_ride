Write-Host "Fixing Partner Screen Files and Imports..." -ForegroundColor Green

$trackingDir = "$PWD\lib\screens\tracking"
$oldFile = "$trackingDir\searching_captain_screen.dart"
$newFile = "$trackingDir\searching_partner_screen.dart"
$capsFile = "$trackingDir\searching_Partner_screen.dart"

# 1. searching_captain_screen.dart నుండి searching_partner_screen.dart ఫైల్ ను క్రియేట్ చేస్తుంది
if (Test-Path $oldFile) {
    Copy-Item $oldFile $newFile -Force
    Copy-Item $oldFile $capsFile -Force
    Write-Host "[OK] Created searching_partner_screen.dart" -ForegroundColor Green
}

# 2. ప్రాజెక్ట్ లోని అన్ని ఫైల్స్ లో ఇంపోర్ట్ సరిచేస్తుంది
Get-ChildItem -Path "$PWD\lib" -Filter *.dart -Recurse | ForEach-Object {
    $filePath = $_.FullName
    $content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)
    $changed = $false

    if ($content -match 'searching_Partner_screen\.dart|searching_captain_screen\.dart') {
        $content = $content -replace 'searching_Partner_screen\.dart', 'searching_partner_screen.dart' `
                            -replace 'searching_captain_screen\.dart', 'searching_partner_screen.dart'
        $changed = $true
    }

    if ($changed) {
        [System.IO.File]::WriteAllText($filePath, $content, [System.Text.Encoding]::UTF8)
        Write-Host "[FIXED IMPORT] in: $($_.Name)" -ForegroundColor Yellow
    }
}

# 3. క్లాస్ నేమ్ ఎర్రర్ రాకుండా SearchingPartnerscreen మరియు SearchingPartnerScreen రెండింటినీ యాడ్ చేస్తుంది
if (Test-Path $newFile) {
    $code = [System.IO.File]::ReadAllText($newFile, [System.Text.Encoding]::UTF8)
    if (!($code -match 'typedef SearchingPartnerscreen')) {
        $extra = @"

// Alias to prevent any casing errors
typedef SearchingPartnerscreen = SearchingPartnerScreen;
typedef SearchingCaptainScreen = SearchingPartnerScreen;
"@
        $code += $extra
        [System.IO.File]::WriteAllText($newFile, $code, [System.Text.Encoding]::UTF8)
        [System.IO.File]::WriteAllText($capsFile, $code, [System.Text.Encoding]::UTF8)
    }
}

# 4. పాత searching_captain_screen.dart ఎక్కడైనా వాడినా ఎర్రర్ రాకుండా చేస్తుంది
if (Test-Path $oldFile) {
    $exportCode = "export 'searching_partner_screen.dart';"
    [System.IO.File]::WriteAllText($oldFile, $exportCode, [System.Text.Encoding]::UTF8)
}

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "All files, names, and imports fixed successfully!" -ForegroundColor Green
Write-Host "You can now run: flutter run" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan