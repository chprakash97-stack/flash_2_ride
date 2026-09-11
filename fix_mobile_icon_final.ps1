Write-Host "Extracting ONLY Round Blue Logo (Removing Black 100%) & Forcing Direct PNG Icon on Android..." -ForegroundColor Green

$projectDir = "C:\Users\DELL\Desktop\flash_2_ride"
Set-Location $projectDir

Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

# 1. Search for WhatsApp Image 2026-09-11 at 3.07.49 PM
$searchDirs = @(
    "$env:USERPROFILE\Downloads",
    "$env:USERPROFILE\Desktop",
    $projectDir,
    "$env:USERPROFILE\Pictures"
)

$found = $null
$recent = Get-ChildItem -Path $searchDirs -File -Recurse -Depth 2 -ErrorAction SilentlyContinue | 
          Where-Object { ($_.Extension -match "\.(png|jpg|jpeg|webp)$") -and ($_.Name -like "*3.07.49*" -or $_.Name -like "*3_07_49*" -or ($_.Name -like "*WhatsApp*2026-09-11*3*")) } | 
          Sort-Object LastWriteTime -Descending

if ($recent) {
    $found = $recent[0].FullName
}

if (-not $found) {
    Write-Host "Opening file picker: Please select 'WhatsApp Image 2026-09-11 at 3.07.49 PM'..." -ForegroundColor Yellow
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.InitialDirectory = "$env:USERPROFILE\Downloads"
    $dialog.Filter = "Image Files (*.png;*.jpeg;*.jpg)|*.png;*.jpeg;*.jpg"
    $dialog.Title = "Select WhatsApp Image 2026-09-11 at 3.07.49 PM"
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

Write-Host "Processing Source Image: $found" -ForegroundColor Cyan
$src = [System.Drawing.Bitmap]::FromFile($found)
$w = $src.Width
$h = $src.Height

# 2. Find bounding box of NON-BLACK pixels to locate the Blue Circle
$minX = $w; $maxX = 0; $minY = $h; $maxY = 0

for ($y = 0; $y -lt $h; $y++) {
    for ($x = 0; $x -lt $w; $x++) {
        $p = $src.GetPixel($x, $y)
        # Check for non-black pixel
        if ($p.R -gt 35 -or $p.G -gt 35 -or $p.B -gt 35) {
            if ($x -lt $minX) { $minX = $x }
            if ($x -gt $maxX) { $maxX = $x }
            if ($y -lt $minY) { $minY = $y }
            if ($y -gt $maxY) { $maxY = $y }
        }
    }
}

$circleW = $maxX - $minX
$circleH = $maxY - $minY
$dim = [Math]::Max($circleW, $circleH)
$centerX = ($minX + $maxX) / 2
$centerY = ($minY + $maxY) / 2

$cropX = [Math]::Max(0, [int]($centerX - ($dim / 2)))
$cropY = [Math]::Max(0, [int]($centerY - ($dim / 2)))
$cropW = [Math]::Min($w - $cropX, $dim)
$cropH = [Math]::Min($h - $cropY, $dim)

$rect = New-Object System.Drawing.Rectangle($cropX, $cropY, $cropW, $cropH)
$croppedSquare = $src.Clone($rect, $src.PixelFormat)

# 3. Create 32-bit Transparent ARGB Round Blue Logo (All Black removed!)
$cleanCircle = New-Object System.Drawing.Bitmap($cropW, $cropH, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$cx = $cropW / 2.0
$cy = $cropH / 2.0
$radius = ($dim / 2.0) - 2

for ($y = 0; $y -lt $cropH; $y++) {
    for ($x = 0; $x -lt $cropW; $x++) {
        $dx = $x - $cx
        $dy = $y - $cy
        $dist = [Math]::Sqrt($dx * $dx + $dy * $dy)
        if ($dist -gt $radius) {
            # Outside circle: 100% Transparent (Black completely gone!)
            $cleanCircle.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
        } else {
            $p = $croppedSquare.GetPixel($x, $y)
            if ($p.R -lt 35 -and $p.G -lt 35 -and $p.B -lt 35) {
                $cleanCircle.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
            } else {
                $cleanCircle.SetPixel($x, $y, $p)
            }
        }
    }
}

Write-Host "Black background completely removed! Clean Round Blue Logo ready!" -ForegroundColor Green

# 4. Master 512x512 Icon
$masterSize = 512
$masterBmp = New-Object System.Drawing.Bitmap($masterSize, $masterSize, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($masterBmp)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

$g.DrawImage($cleanCircle, 0, 0, $masterSize, $masterSize)
$g.Dispose()

$iconDir = Join-Path $projectDir "assets\icon"
if (-not (Test-Path $iconDir)) { New-Item -ItemType Directory -Path $iconDir -Force | Out-Null }
$masterBmp.Save((Join-Path $iconDir "app_icon.png"), [System.Drawing.Imaging.ImageFormat]::Png)

# 5. PERMANENT FIX: Delete the XML fallback folder that forces the robot!
$anyDpiDir = Join-Path $projectDir "android\app\src\main\res\mipmap-anydpi-v26"
if (Test-Path $anyDpiDir) {
    Remove-Item -Recurse -Force $anyDpiDir
    Write-Host "Deleted mipmap-anydpi-v26 (Forces Android OS to directly use real PNG icon, No Robot fallback!)" -ForegroundColor Green
}

# Remove any robot drawables in res/drawable/
$drawableDir = Join-Path $projectDir "android\app\src\main\res\drawable"
if (Test-Path $drawableDir) {
    Get-ChildItem -Path $drawableDir -Filter "ic_launcher*" | Remove-Item -Force -ErrorAction SilentlyContinue
}

# 6. Save Direct PNGs to all Android Mipmap Folders
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

    # Save to both ic_launcher and ic_launcher_round
    $iconBmp.Save((Join-Path $targetFolder "ic_launcher.png"), [System.Drawing.Imaging.ImageFormat]::Png)
    $iconBmp.Save((Join-Path $targetFolder "ic_launcher_round.png"), [System.Drawing.Imaging.ImageFormat]::Png)
    $iconBmp.Dispose()
    Write-Host "  -> Android $folder : Saved Pure Round Blue PNG ($size x $size)!" -ForegroundColor Gray
}

# 7. Generate Web Icons
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

$src.Dispose()
$croppedSquare.Dispose()
$cleanCircle.Dispose()
$masterBmp.Dispose()

# 8. Force Wipe Android Build Cache & Rebuild Preparation
Write-Host "Wiping old Android Build Cache completely..." -ForegroundColor Cyan
Remove-Item -Recurse -Force (Join-Path $projectDir "build") -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force (Join-Path $projectDir "android\app\build") -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force (Join-Path $projectDir ".dart_tool") -ErrorAction SilentlyContinue

flutter pub get | Out-Null

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " All Black Removed! ONLY Round Blue Logo Saved as Direct PNG Icons!           " -ForegroundColor Green
Write-Host " Robot XMLs Deleted! Cache Purged!                                            " -ForegroundColor Green
Write-Host " IMPORTANT: Uninstall the app on mobile, then run 'flutter run' in CMD!       " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green