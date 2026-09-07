Write-Host "Building Screen 1: Official Neon Splash Screen from Image..." -ForegroundColor Green

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
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(CurvedAnimation(parent: _animController, curve: Curves.easeInOut));

    // Wait 3 seconds to showcase the splash animation, then route
    Timer(const Duration(seconds: 4), () {
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
    const Color neonGreen = Color(0xFF00E676);
    const Color deepBlack = Color(0xFF060907);

    return Scaffold(
      backgroundColor: deepBlack,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),

            // Top Flash Bolt with Neon Glow
            AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: neonGreen.withValues(alpha: 0.35 * _glowAnimation.value),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.electric_bolt_rounded, size: 75, color: neonGreen),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Flash2Ride Brand Name
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Flash',
                    style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: -0.5),
                  ),
                  TextSpan(
                    text: '2',
                    style: TextStyle(color: neonGreen, fontSize: 40, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic),
                  ),
                  TextSpan(
                    text: 'Ride',
                    style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: -0.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),

            // Tagline: Ride Faster • Live Safer
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Ride Faster', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.8)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('•', style: TextStyle(color: neonGreen, fontSize: 14, fontWeight: FontWeight.bold)),
                ),
                Text('Live Safer', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.8)),
              ],
            ),

            const Spacer(flex: 2),

            // Center Futuristic Neon Car Illustration with Glowing Headlights
            Center(
              child: SizedBox(
                width: 280,
                height: 110,
                child: CustomPaint(
                  painter: NeonCarFrontPainter(glow: _glowAnimation),
                ),
              ),
            ),

            const Spacer(flex: 3),

            // Bottom Loading Indicator
            Column(
              children: [
                SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(neonGreen.withValues(alpha: 0.8)),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Loading...',
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// Custom Painter to draw the sleek neon sports car front with glowing green headlights
class NeonCarFrontPainter extends CustomPainter {
  final Animation<double> glow;
  NeonCarFrontPainter({required this.glow}) : super(repaint: glow);

  @override
  void paint(Canvas canvas, Size size) {
    const Color neon = Color(0xFF00E676);
    final w = size.width;
    final h = size.height;

    // Roof & Windshield Curve
    final roofPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final roofPath = Path();
    roofPath.moveTo(w * 0.25, h * 0.55);
    roofPath.quadraticBezierTo(w * 0.5, h * 0.05, w * 0.75, h * 0.55);
    canvas.drawPath(roofPath, roofPaint);

    // Hood Line & Body Outlines
    final bodyPaint = Paint()
      ..color = neon.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final bodyPath = Path();
    bodyPath.moveTo(w * 0.12, h * 0.75);
    bodyPath.quadraticBezierTo(w * 0.5, h * 0.65, w * 0.88, h * 0.75);
    canvas.drawPath(bodyPath, bodyPaint);

    // Front Bumper Splitter & Underglow
    final underglowPaint = Paint()
      ..color = neon.withValues(alpha: 0.4 * glow.value)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    canvas.drawLine(Offset(w * 0.15, h * 0.92), Offset(w * 0.85, h * 0.92), underglowPaint);

    final splitterPaint = Paint()
      ..color = neon
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawLine(Offset(w * 0.18, h * 0.92), Offset(w * 0.82, h * 0.92), splitterPaint);

    // Left Angled LED Headlight (Aggressive Sports Car Eyes)
    _drawHeadlight(canvas, Offset(w * 0.22, h * 0.68), isLeft: true);
    // Right Angled LED Headlight
    _drawHeadlight(canvas, Offset(w * 0.78, h * 0.68), isLeft: false);
  }

  void _drawHeadlight(Canvas canvas, Offset center, {required bool isLeft}) {
    const Color neon = Color(0xFF00FF66);
    final glowPaint = Paint()
      ..color = neon.withValues(alpha: 0.8 * glow.value)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    final lightPath = Path();
    final dir = isLeft ? 1.0 : -1.0;
    lightPath.moveTo(center.dx - (dir * 25), center.dy - 6);
    lightPath.lineTo(center.dx + (dir * 15), center.dy - 2);
    lightPath.lineTo(center.dx + (dir * 5), center.dy + 8);
    lightPath.close();

    canvas.drawPath(lightPath, glowPaint);

    final corePaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, 3, corePaint);
  }

  @override
  bool shouldRepaint(covariant NeonCarFrontPainter oldDelegate) => true;
}
'@ | Set-Content -Path 'lib/screens/splash_screen.dart' -Encoding UTF8

Write-Host "Verifying code health with flutter analyze..." -ForegroundColor Green
dart fix --apply | Out-Null
flutter analyze

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " Screen 1 (Splash Screen) Generated Successfully!                             " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green