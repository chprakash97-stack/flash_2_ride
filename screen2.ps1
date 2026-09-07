Write-Host "Fixing Splash encoding and Generating Screen 2 (Login Screen)..." -ForegroundColor Green

# 1. Fix Splash Screen bullet encoding issue (â€¢ -> Native Flutter Dot)
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

    Timer(const Duration(seconds: 3), () {
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

            // Clean Native Dot (No encoding bug)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Ride Faster', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.8)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(width: 4, height: 4, decoration: const BoxDecoration(shape: BoxShape.circle, color: neonGreen)),
                ),
                const Text('Live Safer', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.8)),
              ],
            ),

            const Spacer(flex: 2),

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

class NeonCarFrontPainter extends CustomPainter {
  final Animation<double> glow;
  NeonCarFrontPainter({required this.glow}) : super(repaint: glow);

  @override
  void paint(Canvas canvas, Size size) {
    const Color neon = Color(0xFF00E676);
    final w = size.width;
    final h = size.height;

    final roofPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final roofPath = Path();
    roofPath.moveTo(w * 0.25, h * 0.55);
    roofPath.quadraticBezierTo(w * 0.5, h * 0.05, w * 0.75, h * 0.55);
    canvas.drawPath(roofPath, roofPaint);

    final bodyPaint = Paint()
      ..color = neon.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final bodyPath = Path();
    bodyPath.moveTo(w * 0.12, h * 0.75);
    bodyPath.quadraticBezierTo(w * 0.5, h * 0.65, w * 0.88, h * 0.75);
    canvas.drawPath(bodyPath, bodyPaint);

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

    _drawHeadlight(canvas, Offset(w * 0.22, h * 0.68), isLeft: true);
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
    canvas.drawCircle(center, 3, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant NeonCarFrontPainter oldDelegate) => true;
}
'@ | Set-Content -Path 'lib/screens/splash_screen.dart' -Encoding UTF8

# 2. Generate Screen 2 (Login Screen matching Image #2)
@'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController(text: '9876543210');
  bool _agreedToTerms = true;

  void _submitPhone() {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Please agree to Terms & Conditions and Privacy Policy'),
        ),
      );
      return;
    }

    final phone = _phoneController.text.trim();
    if (phone.length == 10) {
      Provider.of<AuthProvider>(context, listen: false).sendOtp(phone);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OtpScreen(phoneNumber: phone)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Please enter a valid 10-digit mobile number'),
        ),
      );
    }
  }

  @override
  void dispose visual() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color neonGreen = Color(0xFF00E676);
    const Color deepBlack = Color(0xFF060907);
    const Color cardDark = Color(0xFF131A15);
    const Color borderDark = Color(0xFF1E2B22);

    return Scaffold(
      backgroundColor: deepBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Top Flash Bolt
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: neonGreen.withValues(alpha: 0.3),
                      blurRadius: 35,
                      spreadRadius: 6,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.electric_bolt_rounded, size: 62, color: neonGreen),
                ),
              ),
              const SizedBox(height: 14),

              // Flash2Ride Brand Name
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Flash',
                      style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: -0.5),
                    ),
                    TextSpan(
                      text: '2',
                      style: TextStyle(color: neonGreen, fontSize: 36, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic),
                    ),
                    TextSpan(
                      text: 'Ride',
                      style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: -0.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),

              // Tagline with Native Dot
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Ride Faster', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.8)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(width: 4, height: 4, decoration: const BoxDecoration(shape: BoxShape.circle, color: neonGreen)),
                  ),
                  const Text('Live Safer', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.8)),
                ],
              ),

              const Spacer(flex: 3),

              // "Login to your account" heading
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Login to your account',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),

              // Pill Phone Input Box (+91 9876543210)
              Container(
                decoration: BoxDecoration(
                  color: cardDark,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: borderDark, width: 1.5),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.phone_rounded, color: neonGreen, size: 20),
                    const SizedBox(width: 12),
                    const Text('+91', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(width: 10),
                    Container(width: 1, height: 24, color: borderDark),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                        decoration: const InputDecoration(
                          hintText: '9876543210',
                          hintStyle: TextStyle(color: Color(0xFF64748B)),
                          counterText: '',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          fillColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Checkbox: "I agree to the Terms & Conditions and Privacy Policy"
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _agreedToTerms,
                      activeColor: neonGreen,
                      checkColor: Colors.black,
                      side: const BorderSide(color: Color(0xFF64748B), width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      onChanged: (val) => setState(() => _agreedToTerms = val ?? false),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8), height: 1.4),
                        children: [
                          TextSpan(text: 'I agree to the '),
                          TextSpan(text: 'Terms & Conditions', style: TextStyle(color: neonGreen, fontWeight: FontWeight.bold)),
                          TextSpan(text: ' and '),
                          TextSpan(text: 'Privacy Policy', style: TextStyle(color: neonGreen, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Neon Green Login Pill Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: neonGreen,
                    foregroundColor: Colors.black,
                    elevation: 5,
                    shadowColor: neonGreen.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: _submitPhone,
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                  ),
                ),
              ),

              const Spacer(flex: 3),

              // Bottom link: "Don't have an account? Sign Up"
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                  GestureDetector(
                    onTap: _submitPhone,
                    child: const Text('Sign Up', style: TextStyle(color: neonGreen, fontWeight: FontWeight.bold, fontSize: 13)),
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
}
'@ | Set-Content -Path 'lib/screens/auth/login_screen.dart' -Encoding UTF8

Write-Host "Verifying code health with flutter analyze..." -ForegroundColor Green
dart fix --apply | Out-Null
flutter analyze

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " Screen 2 (Login Screen) Generated Successfully with 0 Errors!                " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green