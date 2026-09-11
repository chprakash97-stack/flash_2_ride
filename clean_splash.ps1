Write-Host "Creating Clean Splash Artwork (Removing 9:41, Battery, WiFi & Static Loading Bar)..." -ForegroundColor Green
Add-Type -AssemblyName System.Drawing

$projectDir = "C:\Users\DELL\Desktop\flash_2_ride"
Set-Location $projectDir

$assetsDir = "assets\images"
$webDir = "web"
if (!(Test-Path $assetsDir)) { New-Item -ItemType Directory -Path $assetsDir -Force | Out-Null }
if (!(Test-Path $webDir)) { New-Item -ItemType Directory -Path $webDir -Force | Out-Null }

# Locate source image
$sourceImg = "assets\images\splash.png"
if (!(Test-Path $sourceImg)) {
    if (Test-Path "web\splash.png") { $sourceImg = "web\splash.png" }
    elseif (Test-Path "C:\Users\DELL\assets\images\splash.png") { $sourceImg = "C:\Users\DELL\assets\images\splash.png" }
}

$cleanDest = "assets\images\splash_clean.png"
$webCleanDest = "web\splash_clean.png"

if (Test-Path $sourceImg) {
    try {
        $bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path $sourceImg).Path)
        
        # Crop measurements to eliminate:
        # Top 7.5% (removes 9:41, wifi, battery, signal)
        # Bottom 19% (removes Loading... text and static yellow bar)
        $cropY = [int]($bmp.Height * 0.075)
        $cropH = [int]($bmp.Height * 0.74)
        $cropX = 0
        $cropW = $bmp.Width
        
        $rect = New-Object System.Drawing.Rectangle $cropX, $cropY, $cropW, $cropH
        $cleanBmp = $bmp.Clone($rect, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
        
        $cleanBmp.Save($cleanDest, [System.Drawing.Imaging.ImageFormat]::Png)
        Copy-Item -Path $cleanDest -Destination $webCleanDest -Force
        
        $cleanBmp.Dispose()
        $bmp.Dispose()
        Write-Host "SUCCESS! Clean artwork generated without 9:41, battery or static loading bar!" -ForegroundColor Green
    } catch {
        Write-Host "Error processing image: $_" -ForegroundColor Red
    }
} else {
    Write-Host "Source image not found in assets/images/splash.png" -ForegroundColor Yellow
}

# Update Splash Screen Code with Clean Image & Live Native Animated Loading Bar
@'
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    // Live animated progress bar
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color skyPurple = Color(0xFF2832A5);
    const Color roadPurple = Color(0xFF20278A);
    const Color brandYellow = Color(0xFFFFC107);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [skyPurple, roadPurple],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),

              // Clean Center Artwork (Without 9:41, wifi, battery, or static loading bar)
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/images/splash_clean.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network('splash_clean.png', fit: BoxFit.contain);
                    },
                  ),
                ),
              ),

              // Real Live Native Loading Section (Smooth Animated Bar)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Loading...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Real Live Animated Yellow Progress Bar
                  SizedBox(
                    width: 240,
                    height: 5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: AnimatedBuilder(
                        animation: _progressController,
                        builder: (context, child) {
                          return LinearProgressIndicator(
                            value: _progressController.value,
                            backgroundColor: Colors.white.withValues(alpha: 0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(brandYellow),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
'@ | Set-Content -Path 'lib/screens/splash_screen.dart' -Encoding UTF8

flutter pub get
flutter analyze

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " Clean Splash Screen Ready! Press 'R' in terminal or refresh Chrome (Ctrl+R)! " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green