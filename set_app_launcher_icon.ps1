Write-Host "Configuring Official Flash2Ride App Launcher Icon for Android & Web..." -ForegroundColor Green

$projectDir = "C:\Users\DELL\Desktop\flash_2_ride"
Set-Location $projectDir

Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

# 1. Search for WhatsApp Image 2026-09-11 at 12.40.16 PM
$searchDirs = @(
    "$env:USERPROFILE\Downloads",
    "$env:USERPROFILE\Desktop",
    $projectDir,
    "$env:USERPROFILE\Pictures"
)

$found = $null
$recent = Get-ChildItem -Path $searchDirs -File -Recurse -Depth 2 -ErrorAction SilentlyContinue | 
          Where-Object { ($_.Extension -match "\.(png|jpg|jpeg|webp)$") -and ($_.Name -like "*12.40.16*" -or $_.Name -like "*12_40_16*" -or ($_.Name -like "*WhatsApp*2026-09-11*12*")) } | 
          Sort-Object LastWriteTime -Descending

if ($recent) {
    $found = $recent[0].FullName
}

if (-not $found) {
    Write-Host "Opening file picker: Please select 'WhatsApp Image 2026-09-11 at 12.40.16 PM'..." -ForegroundColor Yellow
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.InitialDirectory = "$env:USERPROFILE\Downloads"
    $dialog.Filter = "Image Files (*.png;*.jpeg;*.jpg)|*.png;*.jpeg;*.jpg"
    $dialog.Title = "Select Flash2Ride Logo Image (12.40.16 PM)"
    $form = New-Object System.Windows.Forms.Form
    $form.TopMost = $true
    if ($dialog.ShowDialog($form) -eq [System.Windows.Forms.DialogResult]::OK) {
        $found = $dialog.FileName
    }
}

if (-not $found) {
    Write-Host "Error: Logo image file not selected. Please place the image and run again." -ForegroundColor Red
    exit
}

Write-Host "Source Logo Image: $found" -ForegroundColor Cyan
$src = [System.Drawing.Bitmap]::FromFile($found)
$w = $src.Width
$h = $src.Height

# Sample background color (from top-left edge)
$bgP = $src.GetPixel(4, 4)
$bgColor = [System.Drawing.Color]::FromArgb(255, $bgP.R, $bgP.G, $bgP.B)

# Find bounding box of logo
$minX = $w; $maxX = 0; $minY = $h; $maxY = 0
for ($y = 0; $y -lt $h; $y++) {
    for ($x = 0; $x -lt $w; $x++) {
        $p = $src.GetPixel($x, $y)
        $diff = [Math]::Abs($p.R - $bgP.R) + [Math]::Abs($p.G - $bgP.G) + [Math]::Abs($p.B - $bgP.B)
        if ($diff -gt 35) {
            if ($x -lt $minX) { $minX = $x }
            if ($x -gt $maxX) { $maxX = $x }
            if ($y -lt $minY) { $minY = $y }
            if ($y -gt $maxY) { $maxY = $y }
        }
    }
}

# If detection bounds are valid, crop logo cleanly
if ($maxX -gt $minX -and $maxY -gt $minY) {
    $pad = 6
    $cropX = [Math]::Max(0, $minX - $pad)
    $cropY = [Math]::Max(0, $minY - $pad)
    $cropW = [Math]::Min($w - $cropX, ($maxX - $minX) + ($pad * 2))
    $cropH = [Math]::Min($h - $cropY, ($maxY - $minY) + ($pad * 2))
    $rect = New-Object System.Drawing.Rectangle($cropX, $cropY, $cropW, $cropH)
    $logoOnly = $src.Clone($rect, $src.PixelFormat)
} else {
    $logoOnly = $src
}

# 2. Build 512x512 Master Square Icon with Safe Adaptive Margin
$masterSize = 512
$masterBmp = New-Object System.Drawing.Bitmap($masterSize, $masterSize, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($masterBmp)
$g.Clear($bgColor)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

# Target logo dimension within safe zone (74% of icon size so it fits perfectly inside circular masks)
$maxTargetW = [int]($masterSize * 0.74)
$maxTargetH = [int]($masterSize * 0.74)

$scale = [Math]::Min($maxTargetW / $logoOnly.Width, $maxTargetH / $logoOnly.Height)
$drawW = [int]($logoOnly.Width * $scale)
$drawH = [int]($logoOnly.Height * $scale)
$drawX = [int](($masterSize - $drawW) / 2)
$drawY = [int](($masterSize - $drawH) / 2)

$g.DrawImage($logoOnly, $drawX, $drawY, $drawW, $drawH)
$g.Dispose()

# 3. Save Master Icon in Assets
$iconDir = Join-Path $projectDir "assets\icon"
if (-not (Test-Path $iconDir)) { New-Item -ItemType Directory -Path $iconDir -Force | Out-Null }
$masterPath = Join-Path $iconDir "app_icon.png"
$masterBmp.Save($masterPath, [System.Drawing.Imaging.ImageFormat]::Png)
Write-Host "Generated Master 512x512 Icon at: $masterPath" -ForegroundColor Green

# 4. Generate all Android Mipmap resolutions
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

    # Save standard icon and round icon
    $targetIcon = Join-Path $targetFolder "ic_launcher.png"
    $targetRound = Join-Path $targetFolder "ic_launcher_round.png"
    $iconBmp.Save($targetIcon, [System.Drawing.Imaging.ImageFormat]::Png)
    $iconBmp.Save($targetRound, [System.Drawing.Imaging.ImageFormat]::Png)
    $iconBmp.Dispose()
    Write-Host "  -> Android $folder : $size x $size (ic_launcher.png & ic_launcher_round.png)" -ForegroundColor Gray
}

# 5. Generate Web Icons & Favicon
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
    $wg.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $wg.DrawImage($masterBmp, 0, 0, $size, $size)
    $wg.Dispose()

    $webOut = Join-Path $webIconsDir $file
    $webBmp.Save($webOut, [System.Drawing.Imaging.ImageFormat]::Png)
    $webBmp.Dispose()
}

# Favicon for browser tab
$faviconPath = Join-Path $projectDir "web\favicon.png"
$favBmp = New-Object System.Drawing.Bitmap(48, 48, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$fg = [System.Drawing.Graphics]::FromImage($favBmp)
$fg.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$fg.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$fg.DrawImage($masterBmp, 0, 0, 48, 48)
$fg.Dispose()
$favBmp.Save($faviconPath, [System.Drawing.Imaging.ImageFormat]::Png)
$favBmp.Dispose()
Write-Host "Generated Web Icons & Favicon successfully!" -ForegroundColor Green

# Clean up memory
$src.Dispose()
$masterBmp.Dispose()

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " Flash2Ride Official Launcher Icon Configured for Android & Web!              " -ForegroundColor Green
Write-Host " Existing UI & Screens are 100% Untouched!                                    " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green