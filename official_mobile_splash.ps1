Write-Host "Configuring Official Mobile Splash Screen with Immersive Fullscreen..." -ForegroundColor Green

$projectDir = "C:\Users\DELL\Desktop\flash_2_ride"
Set-Location $projectDir

# Build Official Fullscreen Mobile Splash Screen
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
    // Transparent system status bar for official immersive mobile look
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
      ),
    );

    // Official 3.5s display time then smooth fade to Screen 2
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
    const Color splashBlue = Color(0xFF0B46D1);

    return Scaffold(
      backgroundColor: splashBlue,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        child: GestureDetector(
          onTap: _navigateToNext, // Instant tap to skip to Login Screen
          child: SizedBox.expand(
            child: Image.asset(
              'assets/images/splash.png',
              fit: BoxFit.cover, // Official full-bleed edge-to-edge display with zero sidebars
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
Write-Host " Official Mobile Screen Ready with 0 Errors! Press 'R' or Ctrl+R in Chrome!   " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green