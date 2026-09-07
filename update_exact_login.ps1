Write-Host "Transforming Login Screen to Exact Provided Image Model..." -ForegroundColor Green

@'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import 'otp_screen.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  void _handleLogin() {
    final phone = _phoneController.text.trim();
    if (phone.length == 10) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      auth.verifyOtp('123456', phone);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
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

  void _handleOtpLogin() {
    final phone = _phoneController.text.trim().isEmpty ? '9876543210' : _phoneController.text.trim();
    Provider.of<AuthProvider>(context, listen: false).sendOtp(phone);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OtpScreen(phoneNumber: phone)),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color brandPurple = Color(0xFF3F2B96);
    const Color brandPurpleLight = Color(0xFF5E43F3);
    const Color brandYellow = Color(0xFFFFC107);
    const Color inputBg = Color(0xFFF3F4F8);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Hero Curved Section with Brand Logo & Artwork
            ClipPath(
              clipper: CurvedHeaderClipper(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 48, bottom: 40),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [brandPurple, brandPurpleLight],
                  ),
                ),
                child: Column(
                  children: [
                    // Arched Yellow Car Outline
                    CustomPaint(
                      size: const Size(120, 22),
                      painter: CarRoofPainter(),
                    ),
                    const SizedBox(height: 4),

                    // Flash2Ride Logo with Yellow Speedlines and Yellow 2
                    Row(
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
                        const SizedBox(width: 6),
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Flash',
                                style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: -0.5),
                              ),
                              TextSpan(
                                text: '2',
                                style: TextStyle(color: brandYellow, fontSize: 38, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic),
                              ),
                              TextSpan(
                                text: 'Ride',
                                style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: -0.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Ride Smart   •   Travel Easy',
                      style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.8),
                    ),
                    const SizedBox(height: 20),

                    // Illustration (City Skyline + Phone with GPS + White Car)
                    SizedBox(
                      height: 120,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          // City Skyline Buildings in background
                          Positioned(
                            bottom: 10,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _buildSkylineBuilding(18, 55),
                                _buildSkylineBuilding(24, 75),
                                _buildSkylineBuilding(16, 45),
                                _buildSkylineBuilding(26, 90),
                                _buildSkylineBuilding(20, 65),
                                _buildSkylineBuilding(22, 80),
                                _buildSkylineBuilding(18, 50),
                              ],
                            ),
                          ),

                          // Left Phone Card with Map & Pin
                          Positioned(
                            left: 45,
                            bottom: 0,
                            child: Container(
                              width: 64,
                              height: 95,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 10, offset: const Offset(0, 4))],
                                border: Border.all(color: Colors.black12),
                              ),
                              child: Stack(
                                children: [
                                  // Map Grid Lines
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: brandPurple,
                                      ),
                                      child: const Icon(Icons.location_on, size: 16, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Right Modern White Sedan Car
                          Positioned(
                            right: 35,
                            bottom: 0,
                            child: Container(
                              width: 170,
                              height: 68,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(22),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
                              ),
                              child: Stack(
                                children: [
                                  // Car Window Glass
                                  Positioned(
                                    top: 6,
                                    left: 40,
                                    right: 25,
                                    height: 22,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF334155),
                                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(10)),
                                      ),
                                    ),
                                  ),
                                  // Yellow Brand Decal Stripe
                                  Positioned(
                                    bottom: 18,
                                    left: 10,
                                    right: 10,
                                    height: 12,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFFBEB),
                                        border: Border(top: BorderSide(color: brandYellow, width: 2), bottom: BorderSide(color: brandYellow, width: 2)),
                                      ),
                                      child: const Center(
                                        child: Text('Flash2Ride', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: brandPurple)),
                                      ),
                                    ),
                                  ),
                                  // Wheels
                                  Positioned(left: 30, bottom: 2, child: _buildWheel()),
                                  Positioned(right: 30, bottom: 2, child: _buildWheel()),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Form Area (White Background)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Login to your Flash2Ride account',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 26),

                  // Pill Mobile Number Field
                  Container(
                    decoration: BoxDecoration(
                      color: inputBg,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                      decoration: InputDecoration(
                        counterText: '',
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: brandPurple.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.phone_rounded, color: brandPurple, size: 18),
                        ),
                        hintText: 'Mobile Number',
                        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14, fontWeight: FontWeight.w500),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Pill Password Field
                  Container(
                    decoration: BoxDecoration(
                      color: inputBg,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                      decoration: InputDecoration(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: brandPurple.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.lock_rounded, color: brandPurple, size: 18),
                        ),
                        hintText: 'Password',
                        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14, fontWeight: FontWeight.w500),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: const Color(0xFF94A3B8),
                            size: 20,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Remember Me & Forgot Password Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _rememberMe,
                              activeColor: brandPurple,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              onChanged: (val) => setState(() => _rememberMe = val ?? false),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('Remember Me', style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: const Text('Forgot Password?', style: TextStyle(color: brandPurple, fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Primary Pill Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandPurple,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: brandPurple.withValues(alpha: 0.4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: _handleLogin,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Login', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Text('➔', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // OR Divider
                  Row(
                    children: const [
                      Expanded(child: Divider(color: Color(0xFFE2E8F0), thickness: 1)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14.0),
                        child: Text('OR', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      Expanded(child: Divider(color: Color(0xFFE2E8F0), thickness: 1)),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // Outlined Pill Login with OTP Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: brandPurple, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: _handleOtpLogin,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.phone_android_rounded, color: brandPurple, size: 20),
                          SizedBox(width: 10),
                          Text('Login with OTP', style: TextStyle(color: brandPurple, fontSize: 15, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Create New Account Footer
                  Center(
                    child: Column(
                      children: [
                        const Text("Don't have an account?", style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: _handleOtpLogin,
                          child: const Text(
                            'Create New Account ➔',
                            style: TextStyle(color: brandPurple, fontSize: 14, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkylineBuilding(double width, double height) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
      ),
    );
  }

  Widget _buildWheel() {
    return Container(
      width: 16,
      height: 16,
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

// Custom Clipper for bottom wave/curve on the hero header
class CurvedHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 35);
    final controlPoint = Offset(size.width / 2, size.height + 15);
    final endPoint = Offset(size.width, size.height - 35);
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Custom Painter for top yellow car silhouette arch
class CarRoofPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFC107)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width / 2, -10, size.width, size.height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
'@ | Set-Content -Path 'lib/screens/auth/login_screen.dart' -Encoding UTF8

Write-Host "Verifying with flutter analyze..." -ForegroundColor Green
dart fix --apply | Out-Null
flutter analyze

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " Exact Login Screen Model Applied Successfully!                               " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green