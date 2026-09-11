Write-Host "Building 100% Pin-to-Pin Login Screen Matching Phone #2 Exactly..." -ForegroundColor Green

$projectDir = "C:\Users\DELL\Desktop\flash_2_ride"
Set-Location $projectDir

# 1. Update Splash Screen so it auto-transitions smoothly to Login Screen after 3.5 seconds
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
    _timer = Timer(const Duration(milliseconds: 3500), () {
      _goToNext();
    });
  }

  void _goToNext() {
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
    return Scaffold(
      backgroundColor: const Color(0xFF2C198A),
      body: GestureDetector(
        onTap: _goToNext,
        child: SizedBox.expand(
          child: Image.asset(
            'assets/images/splash.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Image.network('splash.png', fit: BoxFit.cover);
            },
          ),
        ),
      ),
    );
  }
}
'@ | Set-Content -Path (Join-Path $projectDir 'lib\screens\splash_screen.dart') -Encoding UTF8

# 2. Build 100% Exact Matching Login Screen (Full Purple Background - Matching Phone 2!)
@'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  void _handleLogin() {
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
      // Navigate to Screen 3: Verify OTP
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
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Exact Royal Purple Gradient matching Screen 1 (Splash Screen)
    const Color brandPurple = Color(0xFF2C198A);
    const Color brandPurpleLight = Color(0xFF4C30D4);
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // 1. Top Yellow Car Roof Outline Arc
                CustomPaint(
                  size: const Size(130, 26),
                  painter: HeaderCarArcPainter(),
                ),
                const SizedBox(height: 6),

                // 2. Exact Brand Logo ≡Flash2Ride
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(width: 24, height: 4, decoration: BoxDecoration(color: brandYellow, borderRadius: BorderRadius.circular(2))),
                        const SizedBox(height: 3),
                        Container(width: 17, height: 4, decoration: BoxDecoration(color: brandYellow, borderRadius: BorderRadius.circular(2))),
                        const SizedBox(height: 3),
                        Container(width: 11, height: 4, decoration: BoxDecoration(color: brandYellow, borderRadius: BorderRadius.circular(2))),
                      ],
                    ),
                    const SizedBox(width: 8),
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Flash',
                            style: TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: -0.5),
                          ),
                          TextSpan(
                            text: '2',
                            style: TextStyle(color: brandYellow, fontSize: 42, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic),
                          ),
                          TextSpan(
                            text: 'Ride',
                            style: TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: -0.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // 3. Subtitle: Ride Smart • Travel Easy
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Ride Smart', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.8)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(width: 4, height: 4, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white70)),
                    ),
                    const Text('Travel Easy', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.8)),
                  ],
                ),

                const Spacer(flex: 3),

                // 4. "Login to your account" heading in White
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Login to your account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 5. White Pill Mobile Number Field (+91 9876543210)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.phone_rounded, color: brandPurple, size: 20),
                      const SizedBox(width: 10),
                      const Text(
                        '+91',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                      const SizedBox(width: 10),
                      Container(width: 1, height: 22, color: const Color(0xFFCBD5E1)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Color(0xFF0F172A)),
                          decoration: const InputDecoration(
                            hintText: '9876543210',
                            counterText: '',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            fillColor: Colors.transparent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 6. Checkbox: Terms & Conditions and Privacy Policy (White Text)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _agreedToTerms,
                        activeColor: brandYellow,
                        checkColor: Colors.black,
                        side: const BorderSide(color: Colors.white70, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        onChanged: (val) => setState(() => _agreedToTerms = val ?? false),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 12, color: Colors.white70, height: 1.4),
                          children: [
                            TextSpan(text: 'I agree to the '),
                            TextSpan(text: 'Terms & Conditions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                            TextSpan(text: ' and '),
                            TextSpan(text: 'Privacy Policy', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 7. Pill Login Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3823B5),
                      foregroundColor: Colors.white,
                      elevation: 5,
                      shadowColor: Colors.black45,
                      side: const BorderSide(color: Colors.white38, width: 1.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: _handleLogin,
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                  ),
                ),

                const Spacer(flex: 3),

                // 8. Footer: Don't have an account? Sign Up (White Text)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? ", style: TextStyle(color: Colors.white70, fontSize: 13)),
                    GestureDetector(
                      onTap: _handleLogin,
                      child: const Text('Sign Up', style: TextStyle(color: brandYellow, fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HeaderCarArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFC107)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width * 0.45, -12, size.width, size.height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
'@ | Set-Content -Path (Join-Path $projectDir 'lib\screens\auth\login_screen.dart') -Encoding UTF8

flutter pub get
flutter analyze

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " Screen 2 (Login Screen) 100% Ready! Press 'R' or Ctrl+R in Chrome!           " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green