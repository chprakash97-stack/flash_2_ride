Write-Host "Opening File Selector Window..." -ForegroundColor Green
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$assetsDir = "assets\images"
if (!(Test-Path $assetsDir)) { New-Item -ItemType Directory -Path $assetsDir -Force | Out-Null }

# Open Windows File Dialog to let user pick the exact image
$dialog = New-Object System.Windows.Forms.OpenFileDialog
$dialog.InitialDirectory = "C:\Users\DELL\Desktop"
$dialog.Filter = "Image Files (*.png;*.jpg;*.jpeg;*.webp)|*.png;*.jpg;*.jpeg;*.webp|All Files (*.*)|*.*"
$dialog.Title = "మీ Flash2Ride అసలైన ఫోటోను సెలెక్ట్ చేయండి"

$form = New-Object System.Windows.Forms.Form
$form.TopMost = $true

$res = $dialog.ShowDialog($form)

if ($res -eq [System.Windows.Forms.DialogResult]::OK) {
    $selectedPath = $dialog.FileName
    Write-Host "Selected: $selectedPath" -ForegroundColor Cyan
    
    $dest = "assets\images\splash_exact.png"
    
    try {
        $bmp = [System.Drawing.Bitmap]::FromFile($selectedPath)
        $aspect = $bmp.Width / $bmp.Height
        
        # If it is the full 30-screen square sheet, crop Screen 1 directly
        if ($bmp.Width -gt 1000 -and $aspect -gt 0.8 -and $aspect -lt 1.25) {
            Write-Host "Master Sheet detected! Cropping Screen 1 automatically..." -ForegroundColor Yellow
            $cropX = [int]($bmp.Width * 0.012)
            $cropY = [int]($bmp.Height * 0.038)
            $cropW = [int]($bmp.Width * 0.125)
            $cropH = [int]($bmp.Height * 0.235)
            $rect = New-Object System.Drawing.Rectangle $cropX, $cropY, $cropW, $cropH
            $cropped = $bmp.Clone($rect, $bmp.PixelFormat)
            $cropped.Save($dest, [System.Drawing.Imaging.ImageFormat]::Png)
            $cropped.Dispose()
            Write-Host "Screen 1 Cropped & Saved to $dest!" -ForegroundColor Green
        } else {
            $bmp.Dispose()
            Copy-Item -Path $selectedPath -Destination $dest -Force
            Write-Host "Exact image copied to $dest!" -ForegroundColor Green
        }
    } catch {
        Copy-Item -Path $selectedPath -Destination $dest -Force
    }

    Write-Host "==============================================================================" -ForegroundColor Green
    Write-Host " Success! Now press Ctrl+R in Chrome to view your exact image!                " -ForegroundColor Green
    Write-Host "==============================================================================" -ForegroundColor Green
} else {
    Write-Host "No file selected." -ForegroundColor Yellow
}