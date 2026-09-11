Write-Host "Applying Desktop ChatGPT Photo as 100% Full-Bleed Unified Screen (Zero Seams)..." -ForegroundColor Green

$projectDir = "C:\Users\DELL\Desktop\flash_2_ride"
Set-Location $projectDir

$assetsDir = Join-Path $projectDir "assets\images"
$webDir = Join-Path $projectDir "web"
if (!(Test-Path $assetsDir)) { New-Item -ItemType Directory -Path $assetsDir -Force | Out-Null }
if (!(Test-Path $webDir)) { New-Item -ItemType Directory -Path $webDir -Force | Out-Null }

$destAsset = Join-Path $assetsDir "splash.png"
$destWeb = Join-Path $webDir "splash.png"

# 1. Grab the exact ChatGPT Image directly from Desktop
$desktopImg = Get-ChildItem -Path "$env:USERPROFILE\Desktop" -Filter "*ChatGPT*Image*Sep*8*2026*" -File -ErrorAction SilentlyContinue | Select-Object -First 1

if (!$desktopImg) {
    $desktopImg = Get-ChildItem -Path "$env:USERPROFILE\Desktop", "$env:USERPROFILE\Downloads" -Filter "*ChatGPT*" -File -ErrorAction SilentlyContinue | Select-Object -First 1
}

if ($desktopImg) {
    Write-Host "Found Desktop Photo: $($desktopImg.FullName)" -ForegroundColor Green
    Copy-Item -Path $desktopImg.FullName -Destination $destAsset -Force
    Copy-Item -Path $desktopImg.FullName -Destination $destWeb -Force
    Write-Host "Linked to assets/images/splash.png and web/splash.png successfully!" -ForegroundColor Green
} else {
    Write-Host "Photo not found automatically. Opening selector to click your Desktop photo..." -ForegroundColor Yellow
    Add-Type -AssemblyName System.Windows.Forms
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.InitialDirectory = "$env:USERPROFILE\Desktop"
    $dialog.Filter = "Image Files (*.png;*.jpg;*.jpeg;*.webp)|*.png;*.jpg;*.jpeg;*.webp"
    $dialog.Title = "Select Desktop Photo"
    $form = New-Object System.Windows.Forms.Form
    $form.TopMost = $true
    if ($dialog.ShowDialog($form) -eq [System.Windows.Forms.DialogResult]::OK) {
        Copy-Item -Path $dialog.FileName -Destination $destAsset -Force
        Copy-Item -Path $dialog.FileName -Destination $destWeb -Force
        Write-Host "Selected file linked successfully!" -ForegroundColor Green
    }
}

# 2. Build 100% Seamless Full-Screen Splash Screen (NO borders, NO padding, ONE SINGLE PHOTO)
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
    // Fullscreen edge-to-edge immersion
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
      ),
    );

    // 3.5 seconds display then smoothly navigates to Screen 2 (Login)
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
    return Scaffold(
      body: GestureDetector(
        onTap: _navigateToNext, // Tap to skip
        child: SizedBox.expand(
          child: Image.asset(
            'assets/images/splash.png',
            fit: BoxFit.fill, // Fills 100% of the mobile screen - ZERO gaps, ZERO color mismatch!
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Image.network(
                'splash.png',
                fit: BoxFit.fill,
                width: double.infinity,
                height: double.infinity,
              );
            },
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
Write-Host " 100% Unified Single-Photo Display Ready! Press 'R' or Ctrl+R in Chrome!      " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green