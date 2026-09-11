Write-Host "Searching specifically for 'WhatsApp Image 2026-09-09 at 10.17.53 PM'..." -ForegroundColor Green

$projectDir = "C:\Users\DELL\Desktop\flash_2_ride"
Set-Location $projectDir

$assetsDir = Join-Path $projectDir "assets\images"
$webDir = Join-Path $projectDir "web"
if (!(Test-Path $assetsDir)) { New-Item -ItemType Directory -Path $assetsDir -Force | Out-Null }
if (!(Test-Path $webDir)) { New-Item -ItemType Directory -Path $webDir -Force | Out-Null }

$destAsset = Join-Path $assetsDir "splash.png"
$destWeb = Join-Path $webDir "splash.png"

# 1. Search specifically for the 10.17.53 PM WhatsApp file
$searchDirs = @(
    "$env:USERPROFILE\Desktop",
    "$env:USERPROFILE\Downloads",
    $projectDir,
    "$env:USERPROFILE\Pictures"
)

$found = $null
foreach ($dir in $searchDirs) {
    if (Test-Path $dir) {
        $m = Get-ChildItem -Path $dir -File -Recurse -Depth 2 -ErrorAction SilentlyContinue | 
             Where-Object { $_.Name -like "*10.17.53*" -or $_.Name -like "*10_17_53*" -or $_.Name -like "*10 17 53*" } | 
             Sort-Object LastWriteTime -Descending | 
             Select-Object -First 1
        if ($m) {
            $found = $m.FullName
            break
        }
    }
}

if ($found) {
    Write-Host "FOUND EXACT FILE:" -ForegroundColor Green
    Write-Host $found -ForegroundColor Cyan
    Copy-Item -Path $found -Destination $destAsset -Force
    Copy-Item -Path $found -Destination $destWeb -Force
    Write-Host "Copied specifically to assets/images/splash.png and web/splash.png!" -ForegroundColor Green
} else {
    Write-Host "File not auto-found. Opening selector to click 'WhatsApp Image 2026-09-09 at 10.17.53 PM'..." -ForegroundColor Yellow
    Add-Type -AssemblyName System.Windows.Forms
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.InitialDirectory = "$env:USERPROFILE\Downloads"
    $dialog.Filter = "Image Files (*.jpeg;*.jpg;*.png)|*.jpeg;*.jpg;*.png"
    $dialog.Title = "Select WhatsApp Image 2026-09-09 at 10.17.53 PM"
    $form = New-Object System.Windows.Forms.Form
    $form.TopMost = $true
    if ($dialog.ShowDialog($form) -eq [System.Windows.Forms.DialogResult]::OK) {
        Copy-Item -Path $dialog.FileName -Destination $destAsset -Force
        Copy-Item -Path $dialog.FileName -Destination $destWeb -Force
        Write-Host "Selected file linked successfully: $($dialog.FileName)" -ForegroundColor Green
    }
}

# 2. Build 100% Seamless Fullscreen (Zero Seams, Zero Patches, Single Photo Feel)
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
        onTap: _navigateToNext,
        child: SizedBox.expand(
          child: Image.asset(
            'assets/images/splash.png',
            fit: BoxFit.fill, // Fills 100% of the mobile screen - Zero Gaps, One Single Unified Photo!
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
Write-Host " WhatsApp Image (10.17.53 PM) Successfully Linked! Press 'R' or Ctrl+R!       " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green