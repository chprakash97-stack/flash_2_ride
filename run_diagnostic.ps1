Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "RUNNING COMPLETE PROJECT FLOW & ROUTING DIAGNOSTIC..." -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan

$report = @()
$report += "=== FLASH2RIDE NAVIGATION & FLOW DIAGNOSTIC REPORT ==="
$report += "Timestamp: $(Get-Date)"
$report += ""

# 1. Inspect main.dart and routes.dart
$report += "--- 1. APP ENTRY POINT & ROUTE CONFIGURATION ---"
if (Test-Path "lib\main.dart") {
    $report += "[lib\main.dart]"
    $mainLines = Get-Content "lib\main.dart" | Where-Object { $_ -match "initialRoute|routes|onGenerateRoute|home:" }
    $report += $mainLines
}
if (Test-Path "lib\core\config\routes.dart") {
    $report += "`n[lib\core\config\routes.dart]"
    $routeLines = Get-Content "lib\core\config\routes.dart" | Where-Object { $_ -match "static const|case|return _buildRoute" }
    $report += $routeLines
}

# 2. Find ALL files containing "Confirm" button
$report += "`n--- 2. ALL FILES & CODE WITH 'Confirm' BUTTON ---"
$dartFiles = Get-ChildItem -Path "lib" -Recurse -Filter "*.dart"
foreach ($file in $dartFiles) {
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    if ($content -match "Confirm|confirm") {
        $relPath = $file.FullName.Replace($PWD.Path, '')
        $report += "FILE: $relPath"
        $lines = Get-Content $file.FullName
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match "Confirm|confirm") {
                $start = [Math]::Max(0, $i - 3)
                $end = [Math]::Min($lines.Count - 1, $i + 5)
                $snippet = ($lines[$start..$end] -join "`n")
                $report += "  Line $($i+1):`n$snippet`n"
            }
        }
    }
}

# 3. Find ALL files containing "Pickup Location" or "Where to"
$report += "`n--- 3. ALL SCREENS WITH 'Pickup' OR 'Where to' ---"
foreach ($file in $dartFiles) {
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    if ($content -match "Pickup Location|pickup|Where to") {
        $relPath = $file.FullName.Replace($PWD.Path, '')
        $report += "FILE: $relPath"
        $lines = Get-Content $file.FullName
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match "class |Pickup Location|Where to") {
                $report += "  Line $($i+1): $($lines[$i].Trim())"
            }
        }
    }
}

# 4. Find where "Choose Ride Type" or "rideSelection" or "RideCategory" is navigated to
$report += "`n--- 4. ALL NAVIGATION CALLS TO 'rideSelection' OR 'RideCategory' ---"
foreach ($file in $dartFiles) {
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    if ($content -match "rideSelection|RideCategory|Choose Ride Type") {
        $relPath = $file.FullName.Replace($PWD.Path, '')
        $report += "FILE: $relPath"
        $lines = Get-Content $file.FullName
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match "rideSelection|RideCategory|Choose Ride Type|Navigator\.push") {
                $report += "  Line $($i+1): $($lines[$i].Trim())"
            }
        }
    }
}

# 5. Check if map_pin_picker_screen.dart exists anywhere
$report += "`n--- 5. MAP PIN PICKER SCREEN STATUS ---"
$pickerFiles = Get-ChildItem -Path "lib" -Recurse -Filter "*pin*picker*.dart"
if ($pickerFiles.Count -eq 0) {
    $report += "NO map_pin_picker_screen.dart file found in lib/!"
} else {
    foreach ($pf in $pickerFiles) {
        $relPath = $pf.FullName.Replace($PWD.Path, '')
        $report += "FOUND: $relPath (Size: $($pf.Length) bytes)"
    }
}

$reportText = $report -join "`n"
[System.IO.File]::WriteAllText("$PWD\diagnosis_report.txt", $reportText, [System.Text.Encoding]::UTF8)

Write-Host $reportText
Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "DIAGNOSIS COMPLETE! Report saved to: diagnosis_report.txt" -ForegroundColor Green
Write-Host "Copy the text from diagnosis_report.txt and paste it here." -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan