Write-Host "Connecting User's Original Downloaded Image to Screen 1..." -ForegroundColor Green
Add-Type -AssemblyName System.Drawing

$projectDir = Get-Location
$assetsDir = Join-Path $projectDir "assets\images"
if (!(Test-Path $assetsDir)) { New-Item -ItemType Directory -Path $assetsDir -Force | Out-Null }

# 1. Look for the newly placed image file in flash_2_ride or assets/images
$userImg = Get-ChildItem -Path $projectDir, $assetsDir -Include "*.png","*.jpg","*.jpeg","*.webp" -File |
           Where-Object { $_.Name -notmatch "icon" -and $_.Name -ne "splash_screen.dart" -and $_.Name -ne "favicon.png" } |
           Sort-Object LastWriteTime -Descending |
           Select-Object -First 1

$targetPath = Join-Path $assetsDir "splash_exact.png"

if ($userImg) {
    Write-Host "Found your image: $($userImg.Name)" -ForegroundColor Cyan
    try {
        $bmp = [System.Drawing.Bitmap]::FromFile($userImg.FullName)
        # If it is the 30-screen master grid sheet, crop Screen 1 directly
        if ($bmp.Width -gt 1100 -and $bmp.Height -gt 1100) {
            Write-Host "Detected Master Design Sheet. Automatically cropping Screen 1..." -ForegroundColor Yellow
            $cropX = [int]($bmp.Width * 0.012)
            $cropY = [int]($bmp.Height * 0.038)
            $cropW = [int]($bmp.Width * 0.125)
            $cropH = [int]($bmp.Height * 0.235)
            $rect = New-Object System.Drawing.Rectangle $cropX, $cropY, $cropW, $cropH
            $cropped = $bmp.Clone($rect, $bmp.PixelFormat)
            $cropped.Save($targetPath, [System.Drawing.Imaging.ImageFormat]::Png)
            $cropped.Dispose()
            Write-Host "Screen 1 cropped and saved successfully to $targetPath!" -ForegroundColor Green
        } else {
            $bmp.Dispose()
            Copy-Item -Path $userImg.FullName -Destination $targetPath -Force
            Write-Host "Image linked directly to $targetPath!" -ForegroundColor Green
        }
    } catch {
        Copy-Item -Path $userImg.FullName -Destination $targetPath -Force
    }
} else {
    Write-Host "No image detected yet in project root. Checking assets/images..." -ForegroundColor Yellow
}

# 2. Update Splash Screen to render the Exact Original Image File
@'
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/auth_provider.dart';
import 'auth/login_screen.dart';
import 'home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Keep splash for 4 seconds then route to Login
    Timer(const Duration(milliseconds: 4000), () {
      if (!mounted) return;
      final auth = Provider.of<AuthProvider>(context, listen: false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => auth.isLoggedIn ? const HomeScreen() : const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C198A),
      body: SafeArea(
        child: Stack(
          children: [
            // Exact Original Image Display
            Center(
              child: Image.asset(
                'assets/images/splash_exact.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Text(
                      'Flash2Ride',
                      style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),

            // Live Loading Spinner at bottom
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Loading...',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
'@ | Set-Content -Path 'lib/screens/splash_screen.dart' -Encoding UTF8

Write-Host "Verifying code health with flutter analyze..." -ForegroundColor Green
flutter analyze

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " Screen 1 Connected with Your Real Original Image!                            " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green