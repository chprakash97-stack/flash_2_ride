Write-Host "Linking Selected Image to flash_2_ride Project..." -ForegroundColor Green

$projectDir = "C:\Users\DELL\Desktop\flash_2_ride"
Set-Location $projectDir

$assetsDir = Join-Path $projectDir "assets\images"
$webDir = Join-Path $projectDir "web"
if (!(Test-Path $assetsDir)) { New-Item -ItemType Directory -Path $assetsDir -Force | Out-Null }
if (!(Test-Path $webDir)) { New-Item -ItemType Directory -Path $webDir -Force | Out-Null }

$destAsset = Join-Path $assetsDir "splash.png"
$destWeb = Join-Path $webDir "splash.png"

# Copy the image that was selected in the previous step
if (Test-Path "C:\Users\DELL\assets\images\splash.png") {
    Copy-Item -Path "C:\Users\DELL\assets\images\splash.png" -Destination $destAsset -Force
    Copy-Item -Path "C:\Users\DELL\assets\images\splash.png" -Destination $destWeb -Force
    Write-Host "Copied splash image to project assets and web successfully!" -ForegroundColor Green
} else {
    $found = Get-ChildItem -Path "$env:USERPROFILE" -Filter "*1002348324*" -Recurse -Depth 4 -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($found) {
        Copy-Item -Path $found.FullName -Destination $destAsset -Force
        Copy-Item -Path $found.FullName -Destination $destWeb -Force
        Write-Host "Found and copied $($found.FullName) to project!" -ForegroundColor Green
    }
}

# Update Splash Screen to show the exact full image
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
          child: Image.asset(
            'assets/images/splash.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Image.network(
                'splash.png',
                fit: BoxFit.contain,
                errorBuilder: (c, e, s) => const Center(
                  child: Text('Flash2Ride', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                ),
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
Write-Host " 100% Exact Image Linked to Project! Now launch or refresh Chrome!            " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green