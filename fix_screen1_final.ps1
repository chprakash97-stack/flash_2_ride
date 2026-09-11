Write-Host "Executing Correct Step-by-Step Splash Screen Assembly..." -ForegroundColor Green
Add-Type -AssemblyName System.Drawing

$assetsDir = "assets\images"
if (!(Test-Path $assetsDir)) { New-Item -ItemType Directory -Path $assetsDir -Force | Out-Null }

# 1. Find the master image
$imgFiles = Get-ChildItem -Path ".", $assetsDir, "$env:USERPROFILE\Desktop", "$env:USERPROFILE\Downloads" -Include "*.png","*.jpg","*.jpeg","*.webp" -File -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -notmatch "splash_master_final|favicon|icon" } |
            Sort-Object LastWriteTime -Descending

$targetImg = "assets\images\splash_master_final.png"

if ($imgFiles -and $imgFiles.Count -gt 0) {
    $src = $imgFiles[0].FullName
    Write-Host "Found Design Source: $src" -ForegroundColor Cyan
    try {
        $bmp = [System.Drawing.Bitmap]::FromFile($src)
        $aspect = $bmp.Width / $bmp.Height
        
        # If it is the 30-screen master grid sheet:
        if ($bmp.Width -gt 1000 -and $aspect -gt 0.8 -and $aspect -lt 1.3) {
            # Crop the entire Screen 1 (Splash Screen) phone from Section 1 (top-left)
            $cropX = [int]($bmp.Width * 0.012)
            $cropY = [int]($bmp.Height * 0.036)
            $cropW = [int]($bmp.Width * 0.126)
            $cropH = [int]($bmp.Height * 0.236)
            
            $rect = New-Object System.Drawing.Rectangle $cropX, $cropY, $cropW, $cropH
            $cropped = $bmp.Clone($rect, $bmp.PixelFormat)
            $cropped.Save($targetImg, [System.Drawing.Imaging.ImageFormat]::Png)
            $cropped.Dispose()
            Write-Host "Successfully cropped Screen 1 cleanly into $targetImg!" -ForegroundColor Green
        } else {
            Copy-Item -Path $src -Destination $targetImg -Force
            Write-Host "Copied image directly into $targetImg!" -ForegroundColor Green
        }
        $bmp.Dispose()
    } catch {
        Copy-Item -Path $imgFiles[0].FullName -Destination $targetImg -Force
    }
}

# 2. Update Splash Screen code cleanly
@'
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C198A),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                'assets/images/splash_master_final.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
'@ | Set-Content -Path 'lib/screens/splash_screen.dart' -Encoding UTF8

Write-Host "Running flutter pub get..." -ForegroundColor Green
flutter pub get

Write-Host "Verifying code health..." -ForegroundColor Green
flutter analyze

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " Done! Now run 'flutter run -d chrome' to load the new image asset!           " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green