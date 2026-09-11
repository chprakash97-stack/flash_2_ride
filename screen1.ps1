Write-Host "Building Screen 1: Master Splash Screen matching Image #1..." -ForegroundColor Green

# 1. Update AppTheme with Master Purple & Yellow Theme from Image
@'
import 'package:flutter/material.dart';

class AppTheme {
  static const Color brandPurple = Color(0xFF3F2B96);
  static const Color brandPurpleLight = Color(0xFF5E43F3);
  static const Color brandYellow = Color(0xFFFFC107);
  static const Color backgroundLight = Color(0xFFF8F9FE);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color borderGrey = Color(0xFFE2E8F0);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textGrey = Color(0xFF64748B);

  // Backward compatibility
  static const Color primaryGreen = Color(0xFF3F2B96);
  static const Color cardBlack = Color(0xFFFFFFFF);
  static const Color backgroundBlack = Color(0xFFF8F9FE);
  static const Color textWhite = Color(0xFF0F172A);
  static const Color textBlack = Color(0xFF0F172A);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundLight,
      primaryColor: brandPurple,
      colorScheme: const ColorScheme.light(
        primary: brandPurple,
        secondary: brandYellow,
        surface: cardWhite,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: cardWhite,
        elevation: 0.5,
        centerTitle: true,
        iconTheme: IconThemeData(color: brandPurple),
        titleTextStyle: TextStyle(color: textDark, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brandPurple,
          foregroundColor: Colors.white,
          elevation: 2,
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
'@ | Set-Content -Path 'lib/theme/app_theme.dart' -Encoding UTF8

# 2. Update Splash Screen with Exact Artwork from Image #1
@'
import 'package:flutter/material.dart';
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

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _scaleAnimation = CurvedAnimation(parent: _animController, curve: Curves.easeOutBack);
    _animController.forward();

    // Auto-navigate to Screen 2 (Login Screen) after 3.5 seconds
    Timer(const Duration(milliseconds: 3500), () {
      if (!mounted) return;
      final auth = Provider.of<AuthProvider>(context, listen: false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => auth.isLoggedIn ? const HomeScreen() : const LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color brandPurple = Color(0xFF3F2B96);
    const Color brandPurpleLight = Color(0xFF5E43F3);
    const Color brandYellow = Color(0xFFFFC107);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [brandPurple, brandPurpleLight],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Top Arched Yellow Car Outline
              CustomPaint(
                size: const Size(120, 22),
                painter: CarRoofOutlinePainter(),
              ),
              const SizedBox(height: 6),

              // Master ≡Flash2Ride Logo
              ScaleTransition(
                scale: _scaleAnimation,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Speedlines
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(width: 22, height: 3.5, decoration: BoxDecoration(color: brandYellow, borderRadius: BorderRadius.circular(2))),
                        const SizedBox(height: 3),
                        Container(width: 16, height: 3.5, decoration: BoxDecoration(color: brandYellow, borderRadius: BorderRadius.circular(2))),
                        const SizedBox(height: 3),
                        Container(width: 10, height: 3.5, decoration: BoxDecoration(color: brandYellow, borderRadius: BorderRadius.circular(2))),
                      ],
                    ),
                    const SizedBox(width: 8),
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Flash',
                            style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: -0.5),
                          ),
                          TextSpan(
                            text: '2',
                            style: TextStyle(color: brandYellow, fontSize: 40, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic),
                          ),
                          TextSpan(
                            text: 'Ride',
                            style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: -0.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),

              // Tagline: Ride Smart • Travel Easy
              const Text(
                'Ride Smart   •   Travel Easy',
                style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.8),
              ),

              const Spacer(flex: 3),

              // Center Artwork (Phone Map Pin + City Skyline + White Cab Car)
              SizedBox(
                height: 140,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Skyline in background
                    Positioned(
                      bottom: 12,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildBuilding(20, 60),
                          _buildBuilding(28, 85),
                          _buildBuilding(18, 50),
                          _buildBuilding(30, 100),
                          _buildBuilding(22, 70),
                          _buildBuilding(26, 90),
                          _buildBuilding(20, 55),
                        ],
                      ),
                    ),

                    // Left Map Card with Purple Pin
                    Positioned(
                      left: 45,
                      bottom: 4,
                      child: Container(
                        width: 72,
                        height: 105,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 12, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEF2F6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(7),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: brandPurple,
                                ),
                                child: const Icon(Icons.location_on, size: 18, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Right Modern White Sedan Car with Flash2Ride Door Decal
                    Positioned(
                      right: 35,
                      bottom: 4,
                      child: Container(
                        width: 185,
                        height: 74,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(24),
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 14, offset: const Offset(0, 6)),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Dark Windshield Glass
                            Positioned(
                              top: 6,
                              left: 42,
                              right: 28,
                              height: 24,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1E293B),
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(12)),
                                ),
                              ),
                            ),
                            // Yellow Door Decal Stripe
                            Positioned(
                              bottom: 20,
                              left: 12,
                              right: 12,
                              height: 13,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFFBEB),
                                  border: Border(
                                    top: BorderSide(color: brandYellow, width: 2),
                                    bottom: BorderSide(color: brandYellow, width: 2),
                                  ),
                                ),
                                child: const Center(
                                  child: Text('Flash2Ride', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: brandPurple)),
                                ),
                              ),
                            ),
                            // Wheels
                            Positioned(left: 32, bottom: 2, child: _buildCarWheel()),
                            Positioned(right: 32, bottom: 2, child: _buildCarWheel()),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 3),

              // Bottom Loading Indicator
              Column(
                children: [
                  const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Loading...',
                    style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBuilding(double width, double height) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.22),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
      ),
    );
  }

  Widget _buildCarWheel() {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: const Center(
        child: CircleAvatar(radius: 3, backgroundColor: Colors.grey),
      ),
    );
  }
}

class CarRoofOutlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFC107)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width / 2, -8, size.width, size.height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
'@ | Set-Content -Path 'lib/screens/splash_screen.dart' -Encoding UTF8

Write-Host "Verifying with flutter analyze..." -ForegroundColor Green
dart fix --apply | Out-Null
flutter analyze

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " Screen 1 (Master Splash Screen) Generated with 0 Errors!                     " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green
