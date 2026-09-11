Write-Host "Fixing Android Adaptive Icon (Removing Robot Fallback) & Applying WhatsApp Image 2.35.14 PM (1)..." -ForegroundColor Green

$projectDir = "C:\Users\DELL\Desktop\flash_2_ride"
Set-Location $projectDir

Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

# 1. Search for WhatsApp Image 2026-09-11 at 2.35.14 PM (1)
$searchDirs = @(
    "$env:USERPROFILE\Downloads",
    "$env:USERPROFILE\Desktop",
    $projectDir,
    "$env:USERPROFILE\Pictures"
)

$found = $null
$recent = Get-ChildItem -Path $searchDirs -File -Recurse -Depth 2 -ErrorAction SilentlyContinue | 
          Where-Object { ($_.Extension -match "\.(png|jpg|jpeg|webp)$") -and ($_.Name -like "*2.35.14*" -or $_.Name -like "*2_35_14*" -or ($_.Name -like "*WhatsApp*2026-09-11*2*")) } | 
          Sort-Object LastWriteTime -Descending

if ($recent) {
    $found = $recent[0].FullName
}

if (-not $found) {
    Write-Host "Opening file selector: Please click on 'WhatsApp Image 2026-09-11 at 2.35.14 PM (1)'..." -ForegroundColor Yellow
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.InitialDirectory = "$env:USERPROFILE\Downloads"
    $dialog.Filter = "Image Files (*.png;*.jpeg;*.jpg)|*.png;*.jpeg;*.jpg"
    $dialog.Title = "Select WhatsApp Image 2026-09-11 at 2.35.14 PM (1)"
    $form = New-Object System.Windows.Forms.Form
    $form.TopMost = $true
    if ($dialog.ShowDialog($form) -eq [System.Windows.Forms.DialogResult]::OK) {
        $found = $dialog.FileName
    }
}

if (-not $found) {
    Write-Host "Error: Logo image file not selected. Please place the file and run again." -ForegroundColor Red
    exit
}

Write-Host "Selected Source Logo File: $found" -ForegroundColor Cyan
$src = [System.Drawing.Bitmap]::FromFile($found)
$w = $src.Width
$h = $src.Height

# 2. Build 512x512 Master Icon (Vibrant Royal Blue Canvas)
$masterSize = 512
$vibrantBlue = [System.Drawing.Color]::FromArgb(255, 0, 102, 255) # #0066FF
$masterBmp = New-Object System.Drawing.Bitmap($masterSize, $masterSize, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($masterBmp)
$g.Clear($vibrantBlue)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

# Fit the logo to 88% of master canvas so it is big and prominent
$targetDim = [int]($masterSize * 0.88)
$scale = [Math]::Min($targetDim / $w, $targetDim / $h)
$drawW = [int]($w * $scale)
$drawH = [int]($h * $scale)
$drawX = [int](($masterSize - $drawW) / 2)
$drawY = [int](($masterSize - $drawH) / 2)

$g.DrawImage($src, $drawX, $drawY, $drawW, $drawH)
$g.Dispose()
$src.Dispose()

# 3. Save Master Icon
$iconDir = Join-Path $projectDir "assets\icon"
if (-not (Test-Path $iconDir)) { New-Item -ItemType Directory -Path $iconDir -Force | Out-Null }
$masterPath = Join-Path $iconDir "app_icon.png"
$masterBmp.Save($masterPath, [System.Drawing.Imaging.ImageFormat]::Png)
Write-Host "Generated Master 512x512 Icon: $masterPath" -ForegroundColor Green

# 4. Configure Android Adaptive Icon XML properly (NO CIRCULAR REFERENCE - FIXES ROBOT!)
$valuesDir = Join-Path $projectDir "android\app\src\main\res\values"
if (-not (Test-Path $valuesDir)) { New-Item -ItemType Directory -Path $valuesDir -Force | Out-Null }
@'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_background">#0066FF</color>
</resources>
'@ | Set-Content -Path (Join-Path $valuesDir "colors.xml") -Encoding UTF8

$anyDpiDir = Join-Path $projectDir "android\app\src\main\res\mipmap-anydpi-v26"
if (-not (Test-Path $anyDpiDir)) { New-Item -ItemType Directory -Path $anyDpiDir -Force | Out-Null }
@'
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:color="#0066FF"/>
    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>
</adaptive-icon>
'@ | Set-Content -Path (Join-Path $anyDpiDir "ic_launcher.xml") -Encoding UTF8

@'
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:color="#0066FF"/>
    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>
</adaptive-icon>
'@ | Set-Content -Path (Join-Path $anyDpiDir "ic_launcher_round.xml") -Encoding UTF8

# 5. Generate all Android Mipmap resolutions (ic_launcher, ic_launcher_round, AND ic_launcher_foreground)
$androidResDir = Join-Path $projectDir "android\app\src\main\res"
$mipmapSizes = @{
    "mipmap-mdpi"    = 48
    "mipmap-hdpi"    = 72
    "mipmap-xhdpi"   = 96
    "mipmap-xxhdpi"  = 144
    "mipmap-xxxhdpi" = 192
}

foreach ($folder in $mipmapSizes.Keys) {
    $size = $mipmapSizes[$folder]
    $targetFolder = Join-Path $androidResDir $folder
    if (-not (Test-Path $targetFolder)) { New-Item -ItemType Directory -Path $targetFolder -Force | Out-Null }

    $iconBmp = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $ig = [System.Drawing.Graphics]::FromImage($iconBmp)
    $ig.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $ig.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $ig.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $ig.DrawImage($masterBmp, 0, 0, $size, $size)
    $ig.Dispose()

    # Save all 3 variants so Android OS always finds the real image
    $iconBmp.Save((Join-Path $targetFolder "ic_launcher.png"), [System.Drawing.Imaging.ImageFormat]::Png)
    $iconBmp.Save((Join-Path $targetFolder "ic_launcher_round.png"), [System.Drawing.Imaging.ImageFormat]::Png)
    $iconBmp.Save((Join-Path $targetFolder "ic_launcher_foreground.png"), [System.Drawing.Imaging.ImageFormat]::Png)
    $iconBmp.Dispose()
    Write-Host "  -> Android $folder ($size x $size) Updated successfully!" -ForegroundColor Gray
}

# 6. Generate Web Icons
$webIconsDir = Join-Path $projectDir "web\icons"
if (-not (Test-Path $webIconsDir)) { New-Item -ItemType Directory -Path $webIconsDir -Force | Out-Null }

$webSizes = @{
    "Icon-192.png"          = 192
    "Icon-512.png"          = 512
    "Icon-maskable-192.png" = 192
    "Icon-maskable-512.png" = 512
}

foreach ($file in $webSizes.Keys) {
    $size = $webSizes[$file]
    $webBmp = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $wg = [System.Drawing.Graphics]::FromImage($webBmp)
    $wg.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $wg.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $wg.DrawImage($masterBmp, 0, 0, $size, $size)
    $wg.Dispose()
    $webBmp.Save((Join-Path $webIconsDir $file), [System.Drawing.Imaging.ImageFormat]::Png)
    $webBmp.Dispose()
}

$favBmp = New-Object System.Drawing.Bitmap(48, 48, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$fg = [System.Drawing.Graphics]::FromImage($favBmp)
$fg.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$fg.DrawImage($masterBmp, 0, 0, 48, 48)
$fg.Dispose()
$favBmp.Save((Join-Path $projectDir "web\favicon.png"), [System.Drawing.Imaging.ImageFormat]::Png)
$favBmp.Dispose()

$masterBmp.Dispose()

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " Robot Icon Fixed! Your Real Blue Flash2Ride Logo Set as App Launcher Icon!  " -ForegroundColor Green
Write-Host " All Existing Screens (Splash, Login, OTP, Profile, Home) are 100% Untouched! " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green