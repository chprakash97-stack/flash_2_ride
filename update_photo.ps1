Write-Host "Updating Splash Screen with WhatsApp Image (10.17.53 PM)..." -ForegroundColor Green

$projectDir = "C:\Users\DELL\Desktop\flash_2_ride"
Set-Location $projectDir

$assetsDir = Join-Path $projectDir "assets\images"
$webDir = Join-Path $projectDir "web"
if (!(Test-Path $assetsDir)) { New-Item -ItemType Directory -Path $assetsDir -Force | Out-Null }
if (!(Test-Path $webDir)) { New-Item -ItemType Directory -Path $webDir -Force | Out-Null }

$destAsset = Join-Path $assetsDir "splash.png"
$destWeb = Join-Path $webDir "splash.png"

# 1. Search for the 10.17.53 PM WhatsApp image
$searchDirs = @(
    "$env:USERPROFILE\Downloads",
    "$env:USERPROFILE\Desktop",
    $projectDir,
    "$env:USERPROFILE\Pictures"
)

$found = $null
foreach ($dir in $searchDirs) {
    if (Test-Path $dir) {
        $m = Get-ChildItem -Path $dir -File -ErrorAction SilentlyContinue | 
             Where-Object { $_.Name -like "*10.17.53*" -or $_.Name -like "*10_17_53*" -or ($_.Name -like "*WhatsApp*2026-09-09*") } | 
             Sort-Object LastWriteTime -Descending | 
             Select-Object -First 1
        if ($m) {
            $found = $m.FullName
            break
        }
    }
}

if ($found) {
    Write-Host "SUCCESS! Found new image file:" -ForegroundColor Green
    Write-Host $found -ForegroundColor Cyan
    Copy-Item -Path $found -Destination $destAsset -Force
    Copy-Item -Path $found -Destination $destWeb -Force
    Write-Host "Copied to assets/images/splash.png and web/splash.png successfully!" -ForegroundColor Green
} else {
    Write-Host "Opening file selector window so you can click the 10.17.53 PM image..." -ForegroundColor Yellow
    Add-Type -AssemblyName System.Windows.Forms
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.InitialDirectory = "$env:USERPROFILE\Downloads"
    $dialog.Filter = "Image Files (*.jpeg;*.jpg;*.png)|*.jpeg;*.jpg;*.png"
    $dialog.Title = "Select WhatsApp Image (10.17.53 PM)"
    $form = New-Object System.Windows.Forms.Form
    $form.TopMost = $true
    if ($dialog.ShowDialog($form) -eq [System.Windows.Forms.DialogResult]::OK) {
        Copy-Item -Path $dialog.FileName -Destination $destAsset -Force
        Copy-Item -Path $dialog.FileName -Destination $destWeb -Force
        Write-Host "Selected file copied successfully!" -ForegroundColor Green
    }
}

flutter pub get
flutter analyze

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " New Photo (10.17.53 PM) Updated! Press 'R' in terminal or Ctrl+R in Chrome!  " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green