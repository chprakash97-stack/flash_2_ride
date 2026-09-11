Write-Host "Configuring Perfect Mobile Fit for Splash Screen (No Cut-offs)..." -ForegroundColor Green

$projectDir = "C:\Users\DELL\Desktop\flash_2_ride"
Set-Location $projectDir

# Update Splash Screen to fit any mobile display with perfect margins
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
    // Exact matching colors from the image's sky and road
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
            onTap: _navigateToNext, // Tap anywhere to skip immediately
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Image.asset(
                  'assets/images/splash.png',
                  fit: BoxFit.contain, // Fits entire image without cropping any text or car edges!
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
Write-Host " Splash Screen Perfectly Fitted to Mobile! Press 'R' or Ctrl+R in Chrome!     " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green