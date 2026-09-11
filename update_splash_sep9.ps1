Write-Host "Updating Screen 1 with New WhatsApp Image (6.24.42 PM)..." -ForegroundColor Green

$projectDir = "C:\Users\DELL\Desktop\flash_2_ride"
Set-Location $projectDir

$assetsDir = Join-Path $projectDir "assets\images"
$webDir = Join-Path $projectDir "web"
if (!(Test-Path $assetsDir)) { New-Item -ItemType Directory -Path $assetsDir -Force | Out-Null }
if (!(Test-Path $webDir)) { New-Item -ItemType Directory -Path $webDir -Force | Out-Null }

$destAsset = Join-Path $assetsDir "splash.png"
$destWeb = Join-Path $webDir "splash.png"

# 1. Search for the WhatsApp Image 2026-09-09 at 6.24.42 PM
$searchDirs = @(
    "$env:USERPROFILE\Downloads",
    "$env:USERPROFILE\Desktop",
    $projectDir,
    "$env:USERPROFILE\Pictures"
)

$foundImage = $null
foreach ($dir in $searchDirs) {
    if (Test-Path $dir) {
        $candidate = Get-ChildItem -Path $dir -File -ErrorAction SilentlyContinue | 
                     Where-Object { $_.Name -like "*6.24.42*" -or $_.Name -like "*6_24_42*" -or ($_.Name -like "*WhatsApp*2026-09-09*") } | 
                     Sort-Object LastWriteTime -Descending | 
                     Select-Object -First 1
        if ($candidate) {
            $foundImage = $candidate.FullName
            break
        }
    }
}

if ($foundImage) {
    Write-Host "SUCCESS! Found new image file:" -ForegroundColor Green
    Write-Host $foundImage -ForegroundColor Cyan
    Copy-Item -Path $foundImage -Destination $destAsset -Force
    Copy-Item -Path $foundImage -Destination $destWeb -Force
    Write-Host "Copied to assets/images/splash.png and web/splash.png successfully!" -ForegroundColor Green
} else {
    Write-Host "Opening file selector window so you can select the 6.24.42 PM image..." -ForegroundColor Yellow
    Add-Type -AssemblyName System.Windows.Forms
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.InitialDirectory = "$env:USERPROFILE\Downloads"
    $dialog.Filter = "Image Files (*.jpeg;*.jpg;*.png)|*.jpeg;*.jpg;*.png"
    $dialog.Title = "Select WhatsApp Image (6.24.42 PM)"
    $form = New-Object System.Windows.Forms.Form
    $form.TopMost = $true
    if ($dialog.ShowDialog($form) -eq [System.Windows.Forms.DialogResult]::OK) {
        Copy-Item -Path $dialog.FileName -Destination $destAsset -Force
        Copy-Item -Path $dialog.FileName -Destination $destWeb -Force
        Write-Host "Selected file linked successfully!" -ForegroundColor Green
    }
}

# 2. Update Splash Screen with Responsive Edge-to-Edge Fit
@'
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    // 3.5 seconds splash display, then smoothly navigates to Screen 2 (Login)
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
      backgroundColor: AppTheme.mainBlue,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        child: GestureDetector(
          onTap: _navigateToNext, // Tap anywhere to skip immediately
          child: SizedBox.expand(
            child: Image.asset(
              'assets/images/splash.png',
              fit: BoxFit.cover, // Official full-bleed edge-to-edge display
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  'splash.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
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
Write-Host " Screen 1 Updated with New Photo! Press 'R' or Ctrl+R in Chrome!             " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green