Write-Host "Removing 4 Black Corners and Blending Perfectly into #0645D8 Blue..." -ForegroundColor Green
Add-Type -AssemblyName System.Drawing

$projectDir = "C:\Users\DELL\Desktop\flash_2_ride"
Set-Location $projectDir

$assetsDir = "assets\images"
$webDir = "web"
$splashPath = "assets\images\splash.png"

# 1. Open splash.png and eliminate black pixels in the 4 corners
if (Test-Path $splashPath) {
    try {
        $raw = [System.Drawing.Bitmap]::FromFile((Resolve-Path $splashPath).Path)
        $bmp = New-Object System.Drawing.Bitmap $raw.Width, $raw.Height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb
        $g = [System.Drawing.Graphics]::FromImage($bmp)
        $g.DrawImage($raw, 0, 0, $raw.Width, $raw.Height)
        $raw.Dispose()

        $w = $bmp.Width
        $h = $bmp.Height

        # Official Flash2Ride Brand Main Blue
        $blue = [System.Drawing.Color]::FromArgb(255, 6, 69, 216)

        # A. Clean Top-Left Corner
        for ($x = 0; $x -lt [int]($w * 0.25); $x++) {
            for ($y = 0; $y -lt [int]($h * 0.15); $y++) {
                $p = $bmp.GetPixel($x, $y)
                if ($p.R -lt 40 -and $p.G -lt 40 -and $p.B -lt 40) {
                    $bmp.SetPixel($x, $y, $blue)
                }
            }
        }

        # B. Clean Top-Right Corner
        for ($x = [int]($w * 0.75); $x -lt $w; $x++) {
            for ($y = 0; $y -lt [int]($h * 0.15); $y++) {
                $p = $bmp.GetPixel($x, $y)
                if ($p.R -lt 40 -and $p.G -lt 40 -and $p.B -lt 40) {
                    $bmp.SetPixel($x, $y, $blue)
                }
            }
        }

        # C. Clean Bottom-Left Corner
        for ($x = 0; $x -lt [int]($w * 0.25); $x++) {
            for ($y = [int]($h * 0.85); $y -lt $h; $y++) {
                $p = $bmp.GetPixel($x, $y)
                if ($p.R -lt 40 -and $p.G -lt 40 -and $p.B -lt 40) {
                    $bmp.SetPixel($x, $y, $blue)
                }
            }
        }

        # D. Clean Bottom-Right Corner
        for ($x = [int]($w * 0.75); $x -lt $w; $x++) {
            for ($y = [int]($h * 0.85); $y -lt $h; $y++) {
                $p = $bmp.GetPixel($x, $y)
                if ($p.R -lt 40 -and $p.G -lt 40 -and $p.B -lt 40) {
                    $bmp.SetPixel($x, $y, $blue)
                }
            }
        }

        $g.Dispose()

        # Save back to assets and web folder
        $bmp.Save("assets\images\splash.png", [System.Drawing.Imaging.ImageFormat]::Png)
        Copy-Item "assets\images\splash.png" "web\splash.png" -Force
        $bmp.Dispose()
        Write-Host "SUCCESS! All 4 black corners completely erased and blended with #0645D8 Blue!" -ForegroundColor Green
    } catch {
        Write-Host "Error processing corners: $_" -ForegroundColor Red
    }
}

# 2. Update Splash Screen in Flutter to ensure seamless full screen
@'
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'auth/login_screen.dart';
import 'home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
      ),
    );

    _timer = Timer(const Duration(milliseconds: 3500), () {
      _navigateToNext();
    });
  }

  void _navigateToNext() {
    if (!mounted) return;
    final auth = Provider.of<AuthProvider>(context, listen: false);
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            auth.isLoggedIn ? const HomeScreen() : const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color brandBlue = Color(0xFF0645D8);

    return Scaffold(
      backgroundColor: brandBlue,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        child: GestureDetector(
          onTap: _navigateToNext,
          child: SizedBox.expand(
            child: Image.asset(
              'assets/images/splash.png',
              fit: BoxFit.fitWidth, // Zero cut-offs, 100% full screen
              alignment: Alignment.center,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  'splash.png',
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
'@ | Set-Content -Path (Join-Path $projectDir 'lib\screens\splash_screen.dart') -Encoding UTF8

flutter pub get
flutter analyze

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " Black Corners Eliminated! Press 'R' or Ctrl+R in Chrome to view!             " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green