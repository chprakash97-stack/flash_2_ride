Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "SCANNING FLASH2RIDE PROJECT FOR ALL ERRORS & WARNINGS..." -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan

Write-Host "Running Flutter Analyze across all files..." -ForegroundColor Yellow
$analysis = & flutter analyze 2>&1

$errors = @()
$warnings = @()
$infos = @()

foreach ($line in $analysis) {
    if ($line -match "^\s*error\s*-") {
        $errors += $line
    } elseif ($line -match "^\s*warning\s*-") {
        $warnings += $line
    } elseif ($line -match "^\s*info\s*-") {
        $infos += $line
    }
}

$report = @()
$report += "=== FLASH2RIDE COMPLETE CODEBASE ANALYSIS REPORT ==="
$report += "Generated on: $(Get-Date)"
$report += "Project: Flash 2 Ride (Nellore)"
$report += ""
$report += "SUMMARY:"
$report += "  Total Errors   : $($errors.Count)"
$report += "  Total Warnings : $($warnings.Count)"
$report += "  Total Infos    : $($infos.Count)"
$report += "===================================================="
$report += ""

$report += "--- 1. CRITICAL COMPILATION ERRORS ($($errors.Count)) ---"
if ($errors.Count -eq 0) {
    $report += "NONE! (Zero compilation errors)"
} else {
    $report += $errors
}
$report += ""

$report += "--- 2. WARNINGS ($($warnings.Count)) ---"
if ($warnings.Count -eq 0) {
    $report += "NONE! (Zero warnings)"
} else {
    $report += $warnings
}
$report += ""

$report += "--- 3. LINTS & DEPRECATIONS ($($infos.Count)) ---"
$report += $infos
$report += ""
$report += "=== FULL RAW FLUTTER ANALYZE OUTPUT ==="
$report += $analysis

$reportText = $report -join "`n"
[System.IO.File]::WriteAllText("$PWD\all_project_errors.txt", $reportText, [System.Text.Encoding]::UTF8)

Write-Host "`nAnalysis Complete!" -ForegroundColor Green
Write-Host "Errors: $($errors.Count) | Warnings: $($warnings.Count) | Infos: $($infos.Count)" -ForegroundColor Cyan
Write-Host "Report saved to: all_project_errors.txt" -ForegroundColor Yellow
Write-Host "Opening report in Notepad..." -ForegroundColor Green

# ఆటోమేటిక్ గా నోట్‌ప్యాడ్ లో ఓపెన్ చేయడం
Start-Process notepad.exe "$PWD\all_project_errors.txt"