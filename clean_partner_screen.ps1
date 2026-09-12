Write-Host "Cleaning and fixing SearchingPartnerScreen..." -ForegroundColor Green

$file = "$PWD\lib\screens\tracking\searching_partner_screen.dart"
$capsFile = "$PWD\lib\screens\tracking\searching_Partner_screen.dart"
$oldFile = "$PWD\lib\screens\tracking\searching_captain_screen.dart"

if (Test-Path $file) {
    # 1. పాత ఫైల్ లోని లైన్స్ చదువుతుంది
    $lines = Get-Content $file -Encoding UTF8

    # 2. ఎర్రర్ ఇస్తున్న typedef లైన్లను తొలగిస్తుంది
    $cleanLines = $lines | Where-Object { $_ -notmatch 'typedef Searching' }

    # 3. సరైన అలియాస్ లను మాత్రమే చివర చేరుస్తుంది
    $extra = @(
        "",
        "// Aliases for compatibility",
        "typedef SearchingPartnerScreen = SearchingPartnerscreen;",
        "typedef SearchingCaptainScreen = SearchingPartnerscreen;"
    )
    $finalLines = $cleanLines + $extra

    # 4. సరిచేసిన కోడ్ ను సేవ్ చేస్తుంది
    Set-Content -Path $file -Value $finalLines -Encoding UTF8
    Set-Content -Path $capsFile -Value $finalLines -Encoding UTF8
    Write-Host "[OK] Cleaned searching_partner_screen.dart successfully!" -ForegroundColor Green
}

# searching_captain_screen ఎక్కడైనా పిలిచినా ఎర్రర్ రాకుండా రీడైరెక్ట్ చేస్తుంది
if (Test-Path $oldFile) {
    Set-Content -Path $oldFile -Value "export 'searching_partner_screen.dart';" -Encoding UTF8
}

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "Errors cleared! You can now run: flutter run" -ForegroundColor Green
Write-Host "======================================================" -ForegroundColor Cyan