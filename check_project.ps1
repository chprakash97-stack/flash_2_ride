Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "FLASH2RIDE PROJECT DIAGNOSTIC REPORT" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. ప్రస్తుత ఫోల్డర్ & ప్రాజెక్ట్ లొకేషన్
Write-Host "`n[1. PROJECT DIRECTORY & PUBSPEC]" -ForegroundColor Yellow
$current = Get-Location
Write-Host "Current Directory: $current"
$pubspecs = Get-ChildItem -Filter pubspec.yaml -Recurse -Depth 3 -ErrorAction SilentlyContinue
if ($pubspecs) {
    $pubspecs | ForEach-Object { Write-Host "Found pubspec at: $($_.FullName)" }
} else {
    Write-Host "WARNING: pubspec.yaml not found in current or child folders!" -ForegroundColor Red
}

# 2. హోమ్ స్క్రీన్ మరియు వాలెట్ ఫైల్స్ వివరాలు
Write-Host "`n[2. DETECTED SCREEN FILES]" -ForegroundColor Yellow
$homeFiles = Get-ChildItem -Filter *home*screen*.dart -Recurse -Depth 4 -ErrorAction SilentlyContinue
$walletFiles = Get-ChildItem -Filter *wallet*screen*.dart -Recurse -Depth 4 -ErrorAction SilentlyContinue

Write-Host "--- Home Screen Files ---"
$homeFiles | Select-Object FullName, Length, LastWriteTime | Format-Table -AutoSize | Out-String | Write-Host

Write-Host "--- Wallet Screen Files ---"
$walletFiles | Select-Object FullName, Length, LastWriteTime | Format-Table -AutoSize | Out-String | Write-Host

# 3. హోమ్ స్క్రీన్‌లోని త్రీ డాట్స్ / మెనూ కోడ్
Write-Host "`n[3. CURRENT CODE AROUND THREE DOTS & WALLET IN HOME SCREEN]" -ForegroundColor Yellow
foreach ($hf in $homeFiles) {
    Write-Host "`nChecking: $($hf.FullName)" -ForegroundColor Cyan
    $content = Get-Content $hf.FullName
    $found = $false
    for ($i = 0; $i -lt $content.Count; $i++) {
        if ($content[$i] -match "more_vert|PopupMenu|onSelected|Flash Wallet|_openWallet") {
            $found = $true
            $start = [Math]::Max(0, $i - 4)
            $end = [Math]::Min($content.Count - 1, $i + 20)
            for ($j = $start; $j -le $end; $j++) {
                Write-Host ("{0,4}: {1}" -f ($j + 1), $content[$j])
            }
            break
        }
    }
    if (-not $found) {
        Write-Host "No Three Dots or PopupMenu found in this file!" -ForegroundColor Red
    }
}

# 4. రౌట్స్ కాన్ఫిగరేషన్ చెక్
Write-Host "`n[4. ROUTES CONFIGURATION FOR WALLET]" -ForegroundColor Yellow
$routes = Get-ChildItem -Filter routes.dart -Recurse -Depth 4 -ErrorAction SilentlyContinue
foreach ($rf in $routes) {
    Write-Host "Checking: $($rf.FullName)" -ForegroundColor Cyan
    Get-Content $rf.FullName | Select-String -Pattern "wallet" -Context 2,2 | Out-String | Write-Host
}

# 5. వాలెట్ స్క్రీన్ ఫైల్ లోని మొదటి 25 లైన్లు
Write-Host "`n[5. WALLET SCREEN HEADER & BUILD]" -ForegroundColor Yellow
foreach ($wf in $walletFiles) {
    Write-Host "Checking: $($wf.FullName)" -ForegroundColor Cyan
    Get-Content $wf.FullName -TotalCount 25 | Out-String | Write-Host
}

# 6. ఫ్లట్టర్ అనలైజ్ (కోడ్‌లో ఏవైనా ఎర్రర్స్ ఉన్నాయా)
Write-Host "`n[6. FLUTTER ANALYZE (SYNTAX & COMPILATION CHECK)]" -ForegroundColor Yellow
if (Get-Command flutter -ErrorAction SilentlyContinue) {
    flutter analyze --no-fatal-infos
} else {
    Write-Host "Flutter command not in current PATH."
}

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "DIAGNOSTIC COMPLETE! PLEASE COPY AND PASTE THIS OUTPUT." -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan