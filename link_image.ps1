Write-Host "Searching for your downloaded WhatsApp image..." -ForegroundColor Green

$assetsFolder = "assets\images"
if (!(Test-Path $assetsFolder)) { New-Item -ItemType Directory -Path $assetsFolder -Force | Out-Null }

# Check Project folder, Desktop, and Downloads for the most recent image
$searchDirs = @(".", "$env:USERPROFILE\Desktop", "$env:USERPROFILE\Downloads")
$foundImage = $null

foreach ($dir in $searchDirs) {
    if (Test-Path $dir) {
        $files = Get-ChildItem -Path $dir -ErrorAction SilentlyContinue | 
                 Where-Object { $_.Extension -match "\.(jpg|jpeg|png|webp)$" -and $_.Name -notmatch "splash_exact|favicon" } | 
                 Sort-Object LastWriteTime -Descending
        if ($files -and $files.Count -gt 0) {
            $foundImage = $files[0]
            break
        }
    }
}

if ($foundImage) {
    Write-Host "SUCCESS! Found your image:" -ForegroundColor Green
    Write-Host "Name: $($foundImage.Name)" -ForegroundColor Cyan
    Write-Host "Path: $($foundImage.FullName)" -ForegroundColor Cyan
    
    $dest = "assets\images\splash_exact.png"
    Copy-Item -Path $foundImage.FullName -Destination $dest -Force
    Write-Host "Image successfully linked to: $dest" -ForegroundColor Green
} else {
    Write-Host "No image found in Project folder, Desktop, or Downloads." -ForegroundColor Yellow
}

Write-Host "Cleaning up splash screen code and verifying..." -ForegroundColor Green
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
  @override
  void initState() {
    super.initState();
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

dart fix --apply | Out-Null
flutter analyze