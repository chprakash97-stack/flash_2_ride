Write-Host "======================================================" -ForegroundColor Cyan
Write-Host " Scanning entire project for any 'Captain' references..." -ForegroundColor Cyan
Write-Host " Updating ALL occurrences to 'Partner'..." -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan

$count = 0

# lib ఫోల్డర్ లోని ప్రతి .dart ఫైల్ ను వెతుకుతుంది
Get-ChildItem -Path "$PWD\lib" -Filter *.dart -Recurse | ForEach-Object {
    $filePath = $_.FullName
    $content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)

    if ($content -match 'captain|Captain|CAPTAIN') {
        $updated = $content `
            -replace 'Searching Captain', 'Searching Partner' `
            -replace 'Searching for nearby captain', 'Searching for nearby partner' `
            -replace 'Looking for captain in Nellore area', 'Looking for partner in Nellore area' `
            -replace 'Safe & Verified Captains', 'Safe & Verified Partners' `
            -replace 'Safe & Verified Captain', 'Safe & Verified Partner' `
            -replace 'Captain details will appear', 'Partner details will appear' `
            -replace 'Captain Assigned', 'Partner Assigned' `
            -replace 'Captain Arriving', 'Partner Arriving' `
            -replace 'Call Captain', 'Call Partner' `
            -replace 'Chat with Captain', 'Chat with Partner' `
            -replace 'Rate your Captain', 'Rate your Partner' `
            -replace 'Tip your Captain', 'Tip your Partner' `
            -replace 'Captains', 'Partners' `
            -replace 'captains', 'partners' `
            -replace 'Captain', 'Partner' `
            -replace 'captain', 'partner'

        [System.IO.File]::WriteAllText($filePath, $updated, [System.Text.Encoding]::UTF8)
        Write-Host "[UPDATED] $($_.FullName.Replace($PWD, ''))" -ForegroundColor Green
        $count++
    }
}

Write-Host "------------------------------------------------------" -ForegroundColor Cyan
if ($count -gt 0) {
    Write-Host "SUCCESS: Updated $count files to 'Partner' across the entire project!" -ForegroundColor Green
} else {
    Write-Host "All files are already clean and using 'Partner'!" -ForegroundColor Green
}
Write-Host "Please reload your Flutter app in Chrome (F5) or CMD ('R')." -ForegroundColor Yellow
Write-Host "======================================================" -ForegroundColor Cyan