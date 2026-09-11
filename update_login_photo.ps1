Write-Host "Updating Login Screen Photo to 'WhatsApp Image 2026-09-10 at 12.09.24 AM'..." -ForegroundColor Green

$projectDir = "C:\Users\DELL\Desktop\flash_2_ride"
Set-Location $projectDir

$assetsDir = Join-Path $projectDir "assets\images"
$webDir = Join-Path $projectDir "web"
if (!(Test-Path $assetsDir)) { New-Item -ItemType Directory -Path $assetsDir -Force | Out-Null }
if (!(Test-Path $webDir)) { New-Item -ItemType Directory -Path $webDir -Force | Out-Null }

$destAsset = Join-Path $assetsDir "login.png"
$destWeb = Join-Path $webDir "login.png"

# 1. Search for the 12.09.24 AM WhatsApp Image
$searchDirs = @(
    "$env:USERPROFILE\Desktop",
    "$env:USERPROFILE\Downloads",
    $projectDir,
    "$env:USERPROFILE\Pictures"
)

$found = $null
foreach ($dir in $searchDirs) {
    if (Test-Path $dir) {
        $m = Get-ChildItem -Path $dir -File -Recurse -Depth 2 -ErrorAction SilentlyContinue | 
             Where-Object { $_.Name -like "*12.09.24*" -or $_.Name -like "*12_09_24*" -or ($_.Name -like "*WhatsApp*2026-09-10*") } | 
             Sort-Object LastWriteTime -Descending | 
             Select-Object -First 1
        if ($m) {
            $found = $m.FullName
            break
        }
    }
}

if ($found) {
    Write-Host "FOUND 12.09.24 AM IMAGE:" -ForegroundColor Green
    Write-Host $found -ForegroundColor Cyan
    Copy-Item -Path $found -Destination $destAsset -Force
    Copy-Item -Path $found -Destination $destWeb -Force
    Write-Host "Copied to assets/images/login.png and web/login.png successfully!" -ForegroundColor Green
} else {
    Write-Host "File not auto-found. Opening selector to click 'WhatsApp Image 2026-09-10 at 12.09.24 AM'..." -ForegroundColor Yellow
    Add-Type -AssemblyName System.Windows.Forms
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.InitialDirectory = "$env:USERPROFILE\Downloads"
    $dialog.Filter = "Image Files (*.jpeg;*.jpg;*.png)|*.jpeg;*.jpg;*.png"
    $dialog.Title = "Select WhatsApp Image (12.09.24 AM)"
    $form = New-Object System.Windows.Forms.Form
    $form.TopMost = $true
    if ($dialog.ShowDialog($form) -eq [System.Windows.Forms.DialogResult]::OK) {
        Copy-Item -Path $dialog.FileName -Destination $destAsset -Force
        Copy-Item -Path $dialog.FileName -Destination $destWeb -Force
        Write-Host "Selected file linked successfully: $($dialog.FileName)" -ForegroundColor Green
    }
}

flutter pub get
flutter analyze

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " Login Photo (12.09.24 AM) Updated! All buttons remain active. Press 'R'!     " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green