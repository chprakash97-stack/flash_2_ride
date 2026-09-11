Write-Host "Setting 100% Full-Bleed Edge-to-Edge Splash Screen..." -ForegroundColor Green

$projectDir = "C:\Users\DELL\Desktop\flash_2_ride"
Set-Location $projectDir

$assetsDir = Join-Path $projectDir "assets\images"
$webDir = Join-Path $projectDir "web"
if (!(Test-Path $assetsDir)) { New-Item -ItemType Directory -Path $assetsDir -Force | Out-Null }
if (!(Test-Path $webDir)) { New-Item -ItemType Directory -Path $webDir -Force | Out-Null }

$destAsset = Join-Path $assetsDir "splash.png"
$destWeb = Join-Path $webDir "splash.png"

# 1. Grab the ChatGPT image directly from Desktop
$desktopImg = Get-ChildItem -Path "$env:USERPROFILE\Desktop" -Filter "*ChatGPT*Image*Sep*8*2026*" -File -ErrorAction SilentlyContinue | Select-Object -First 1

if (!$desktopImg) {
    $desktopImg = Get-ChildItem -Path "$env:USERPROFILE\Desktop", "$env:USERPROFILE\Downloads" -Filter "*ChatGPT*" -File -ErrorAction SilentlyContinue | Select-Object -First 1
}

if ($desktopImg) {
    Write-Host "Found ChatGPT image on Desktop: $($desktopImg.FullName)" -ForegroundColor Green
    Copy-Item -Path $desktopImg.FullName -Destination $destAsset -Force
    Copy-Item -Path $desktopImg.FullName -Destination $destWeb -Force
    Write-Host "Copied image to assets/images/splash.png successfully!" -ForegroundColor Green
}

# 2. Update Splash Screen to cover 100% of the mobile display without any borders or margins
@'
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C198A),
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/splash.png',
          fit: BoxFit.cover,
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
    );
  }
}
'@ | Set-Content -Path (Join-Path $projectDir 'lib\screens\splash_screen.dart') -Encoding UTF8

flutter pub get
flutter analyze

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " 100% Full-Screen Display Ready! Press 'R' in terminal or Ctrl+R in Chrome!   " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green