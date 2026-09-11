Write-Host "Configuring 100% Vibrant Royal Blue Launcher Icon matching Image 2 (No Black, Big Eagle)..." -ForegroundColor Green

$projectDir = "C:\Users\DELL\Desktop\flash_2_ride"
Set-Location $projectDir

Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

# 1. Look for user's Image 2 (1002356795)
$searchDirs = @(
    "$env:USERPROFILE\Downloads",
    "$env:USERPROFILE\Desktop",
    $projectDir,
    "$env:USERPROFILE\Pictures"
)

$found = $null
$recent = Get-ChildItem -Path $searchDirs -File -Recurse -Depth 2 -ErrorAction SilentlyContinue | 
          Where-Object { ($_.Extension -match "\.(png|jpg|jpeg|webp)$") -and ($_.Name -like "*1002356795*" -or $_.Name -like "*1002356*" -or ($_.Name -like "*WhatsApp*2026-09-11*")) } | 
          Sort-Object LastWriteTime -Descending

if ($recent) {
    $found = $recent[0].FullName
}

if (-not $found) {
    Write-Host "Opening file picker: Please select Image 2 (1002356795)..." -ForegroundColor Yellow
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.InitialDirectory = "$env:USERPROFILE\Downloads"
    $dialog.Filter = "Image Files (*.png;*.jpeg;*.jpg)|*.png;*.jpeg;*.jpg"
    $dialog.Title = "Select Image 2 (Flash2Ride with Blue Circle & Eagle)"
    $form = New-Object System.Windows.Forms.Form
    $form.TopMost = $true
    if ($dialog.ShowDialog($form) -eq [System.Windows.Forms.DialogResult]::OK) {
        $found = $dialog.FileName
    }
}

$masterSize = 512
$vibrantBlue = [System.Drawing.Color]::FromArgb(255, 0, 102, 255) # Official Vibrant Royal Blue #0066FF
$masterBmp = New-Object System.Drawing.Bitmap($masterSize, $masterSize, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($masterBmp)
$g.Clear($vibrantBlue)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

$croppedLogo = $null

if ($found) {
    Write-Host "Found Reference Image: $found" -ForegroundColor Cyan
    try {
        $src = [System.Drawing.Bitmap]::FromFile($found)
        $w = $src.Width
        $h = $src.Height

        # Detect the blue circle and Flash2Ride text bounding box in Image 2
        $minX = $w; $maxX = 0; $minY = $h; $maxY = 0
        for ($y = [int]($h * 0.05); $y -lt [int]($h * 0.75); $y++) {
            for ($x = [int]($w * 0.20); $x -lt [int]($w * 0.80); $x++) {
                $p = $src.GetPixel($x, $y)
                # Blue circle: High Blue, Low Red, Moderate Green
                $isBlueCircle = ($p.B -gt 180 -and $p.R -lt 70 -and $p.G -lt 150)
                # Yellow text / eagle: High Red, High Green, Low Blue
                $isYellow = ($p.R -gt 200 -and $p.G -gt 175 -and $p.B -lt 85)
                # White text / swoosh: High R, G, B
                $isWhite = ($p.R -gt 215 -and $p.G -gt 215 -and $p.B -gt 215)

                if ($isBlueCircle -or $isYellow -or $isWhite) {
                    if ($x -lt $minX) { $minX = $x }
                    if ($x -gt $maxX) { $maxX = $x }
                    if ($y -lt $minY) { $minY = $y }
                    if ($y -gt $maxY) { $maxY = $y }
                }
            }
        }

        if ($maxX -gt $minX -and $maxY -gt $minY) {
            $pad = 6
            $cropX = [Math]::Max(0, $minX - $pad)
            $cropY = [Math]::Max(0, $minY - $pad)
            $cropW = [Math]::Min($w - $cropX, ($maxX - $minX) + ($pad * 2))
            $cropH = [Math]::Min($h - $cropY, ($maxY - $minY) + ($pad * 2))
            $rect = New-Object System.Drawing.Rectangle($cropX, $cropY, $cropW, $cropH)
            $croppedLogo = $src.Clone($rect, $src.PixelFormat)
            Write-Host "Successfully extracted Blue Circle & Logo from Image 2!" -ForegroundColor Green
        }
        $src.Dispose()
    } catch {
        Write-Host "Note: Processing fallback vector graphics..." -ForegroundColor Yellow
    }
}

if ($croppedLogo) {
    # Scale to fill 86% of icon canvas (Prominent, big, beautifully centered)
    $targetDim = [int]($masterSize * 0.86)
    $scale = [Math]::Min($targetDim / $croppedLogo.Width, $targetDim / $croppedLogo.Height)
    $drawW = [int]($croppedLogo.Width * $scale)
    $drawH = [int]($croppedLogo.Height * $scale)
    $drawX = [int](($masterSize - $drawW) / 2)
    $drawY = [int](($masterSize - $drawH) / 2)

    $g.DrawImage($croppedLogo, $drawX, $drawY, $drawW, $drawH)
    $croppedLogo.Dispose()
} else {
    # High-Definition Vector Rendering matching Image 2 directly
    $yellowBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 210, 28))
    $whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $darkBlueBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 0, 56, 153))

    # 1. Three Yellow Speed Streaks
    $g.FillRectangle($yellowBrush, 90, 160, 110, 20)
    $g.FillRectangle($yellowBrush, 80, 195, 95, 20)
    $g.FillRectangle($yellowBrush, 90, 230, 80, 20)

    # 2. Eagle Body & Beak Path
    $bodyPath = New-Object System.Drawing.Drawing2D.GraphicsPath
    $bodyPath.AddBezier(150, 240, 200, 90, 310, 70, 390, 120)
    $bodyPath.AddBezier(390, 120, 425, 145, 435, 170, 410, 185)
    $bodyPath.AddLine(410, 185, 375, 170)
    $bodyPath.AddBezier(375, 170, 340, 230, 300, 280, 240, 275)
    $bodyPath.CloseFigure()
    $g.FillPath($yellowBrush, $bodyPath)
    $bodyPath.Dispose()

    # 3. White Dynamic Wing / Swoosh
    $whitePath = New-Object System.Drawing.Drawing2D.GraphicsPath
    $whitePath.AddBezier(225, 275, 290, 240, 360, 215, 395, 175)
    $whitePath.AddBezier(395, 175, 340, 185, 285, 220, 225, 275)
    $whitePath.CloseFigure()
    $g.FillPath($whiteBrush, $whitePath)
    $whitePath.Dispose()

    # 4. Eagle Eye
    $g.FillEllipse($darkBlueBrush, 340, 135, 18, 18)
    $g.FillEllipse($whiteBrush, 344, 139, 6, 6)

    # 5. Text: Flash2Ride with tight spacing below
    $fontFamily = New-Object System.Drawing.FontFamily("Arial")
    $font = New-Object System.Drawing.Font($fontFamily, 44, [System.Drawing.FontStyle]::Bold)
    $g.DrawString("Flash", $font, $whiteBrush, 75, 350)
    $g.DrawString("2", $font, $yellowBrush, 240, 350)
    $g.DrawString("Ride", $font, $whiteBrush, 285, 350)

    $yellowBrush.Dispose(); $whiteBrush.Dispose(); $darkBlueBrush.Dispose(); $font.Dispose(); $fontFamily.Dispose()
}

$g.Dispose()

# 2. Save Master Icon in Assets
$iconDir = Join-Path $projectDir "assets\icon"
if (-not (Test-Path $iconDir)) { New-Item -ItemType Directory -Path $iconDir -Force | Out-Null }
$masterPath = Join-Path $iconDir "app_icon.png"
$masterBmp.Save($masterPath, [System.Drawing.Imaging.ImageFormat]::Png)
Write-Host "Generated Master Vibrant Blue 512x512 Icon: $masterPath" -ForegroundColor Green

# 3. Update Android Colors & Adaptive Icon XML (FORCING #0066FF ROYAL BLUE, NO BLACK!)
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
    <foreground android:drawable="@mipmap/ic_launcher"/>
</adaptive-icon>
'@ | Set-Content -Path (Join-Path $anyDpiDir "ic_launcher.xml") -Encoding UTF8

@'
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:color="#0066FF"/>
    <foreground android:drawable="@mipmap/ic_launcher_round"/>
</adaptive-icon>
'@ | Set-Content -Path (Join-Path $anyDpiDir "ic_launcher_round.xml") -Encoding UTF8

# 4. Generate all Android Mipmap Resolutions (Square & Round)
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

    # Save ic_launcher.png and ic_launcher_round.png
    $iconBmp.Save((Join-Path $targetFolder "ic_launcher.png"), [System.Drawing.Imaging.ImageFormat]::Png)
    $iconBmp.Save((Join-Path $targetFolder "ic_launcher_round.png"), [System.Drawing.Imaging.ImageFormat]::Png)
    $iconBmp.Dispose()
    Write-Host "  -> Android $folder ($size x $size) Updated to Royal Blue Icon!" -ForegroundColor Gray
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
Write-Host " 100% Vibrant Royal Blue Launcher Icon Generated (No Black, Big Eagle, Tight)! " -ForegroundColor Green
Write-Host " Screens 1 to 5 are 100% Untouched!                                           " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green