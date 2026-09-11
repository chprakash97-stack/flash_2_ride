Write-Host "Searching and Updating WhatsApp Image (11.54.30 PM)..." -ForegroundColor Green

$projectDir = "C:\Users\DELL\Desktop\flash_2_ride"
Set-Location $projectDir

$assetsDir = Join-Path $projectDir "assets\images"
$webDir = Join-Path $projectDir "web"
if (!(Test-Path $assetsDir)) { New-Item -ItemType Directory -Path $assetsDir -Force | Out-Null }
if (!(Test-Path $webDir)) { New-Item -ItemType Directory -Path $webDir -Force | Out-Null }

$destAsset = Join-Path $assetsDir "splash.png"
$destWeb = Join-Path $webDir "splash.png"

# 1. Search for the 11.54.30 PM WhatsApp image file
$searchDirs = @(
    "$env:USERPROFILE\Downloads",
    "$env:USERPROFILE\Desktop",
    $projectDir,
    "$env:USERPROFILE\Pictures"
)

$found = $null
foreach ($dir in $searchDirs) {
    if (Test-Path $dir) {
        $m = Get-ChildItem -Path $dir -File -ErrorAction SilentlyContinue | 
             Where-Object { $_.Name -like "*11.54.30*" -or $_.Name -like "*11_54_30*" -or ($_.Name -like "*WhatsApp*" -and $_.LastWriteTime -gt (Get-Date).AddHours(-3)) } |
             Sort-Object LastWriteTime -Descending |
             Select-Object -First 1
        if ($m) {
            $found = $m.FullName
            break
        }
    }
}

if ($found) {
    Write-Host "SUCCESS! Found new WhatsApp image:" -ForegroundColor Green
    Write-Host $found -ForegroundColor Cyan
    Copy-Item -Path $found -Destination $destAsset -Force
    Copy-Item -Path $found -Destination $destWeb -Force
    Write-Host "Copied to assets/images/splash.png and web/splash.png!" -ForegroundColor Green
} else {
    Write-Host "Auto-search couldn't find the exact file. Opening file picker..." -ForegroundColor Yellow
    Add-Type -AssemblyName System.Windows.Forms
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.InitialDirectory = "$env:USERPROFILE\Downloads"
    $dialog.Filter = "Image Files (*.jpeg;*.jpg;*.png)|*.jpeg;*.jpg;*.png"
    $dialog.Title = "Select WhatsApp Image (11.54.30 PM)"
    $form = New-Object System.Windows.Forms.Form
    $form.TopMost = $true
    if ($dialog.ShowDialog($form) -eq [System.Windows.Forms.DialogResult]::OK) {
        Copy-Item -Path $dialog.FileName -Destination $destAsset -Force
        Copy-Item -Path $dialog.FileName -Destination $destWeb -Force
        Write-Host "Selected file copied successfully!" -ForegroundColor Green
    }
}

# 2. Update Splash Screen with perfect Mobile Aspect Ratio (Zero Cut-offs)
@'
import 'package:flutter/material.dart';
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
      MaterialPageRoute(builder: (context) => auth.isLoggedIn ? const HomeScreen() : const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color topSkyBlue = Color(0xFF1B38B8);
    const Color bottomRoadBlue = Color(0xFF142488);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [topSkyBlue, bottomRoadBlue],
          ),
        ),
        child: SafeArea(
          child: GestureDetector(
            onTap: _navigateToNext, // Tap anywhere to skip
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Image.asset(
                  'assets/images/splash.png',
                  fit: BoxFit.contain, // Fits entire image cleanly without any cropping!
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      'splash.png',
                      fit: BoxFit.contain,
                    );
                  },
                ),
              ),
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
Write-Host " New Image Updated Successfully! Press 'R' or Ctrl+R in Chrome!               " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green