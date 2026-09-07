Write-Host "Rendering High-Fidelity Real Sleek Sports Car with Wheels & Headlights..." -ForegroundColor Green

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

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController(text: '9876543210');
  bool _agreedToTerms = true;
  late AnimationController _animController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(CurvedAnimation(parent: _animController, curve: Curves.easeInOut));
  }

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
  void dispose() {
    _animController.dispose();
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Top Flash Bolt
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: neonGreen.withValues(alpha: 0.3),
                        blurRadius: 28,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.electric_bolt_rounded, size: 54, color: neonGreen),
                  ),
                ),
                const SizedBox(height: 8),

                // Flash2Ride Brand Name
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Flash',
                        style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: -0.5),
                      ),
                      TextSpan(
                        text: '2',
                        style: TextStyle(color: neonGreen, fontSize: 32, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic),
                      ),
                      TextSpan(
                        text: 'Ride',
                        style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: -0.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),

                // Tagline with Native Dot
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Ride Faster', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.8)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(width: 4, height: 4, decoration: const BoxDecoration(shape: BoxShape.circle, color: neonGreen)),
                    ),
                    const Text('Live Safer', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.8)),
                  ],
                ),

                const SizedBox(height: 14),

                // 🚗 Real Detailed Side-View Sports Car with Wheels & Headlight Beam
                Center(
                  child: SizedBox(
                    width: 290,
                    height: 105,
                    child: CustomPaint(
                      painter: RealSleekCarSidePainter(glow: _glowAnimation),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // "Login to your account" heading
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Login to your account',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),

                // Phone Input Pill Box
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

                const SizedBox(height: 14),

                // Checkbox: Terms & Conditions and Privacy Policy
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

                const SizedBox(height: 20),

                // Neon Green Login Button
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

                const SizedBox(height: 24),

                // Bottom Link: "Don't have an account? Sign Up"
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

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 🚗 Real Sleek Car Side Profile Painter (With Wheels, Windows, Body & Headlights)
class RealSleekCarSidePainter extends CustomPainter {
  final Animation<double> glow;
  RealSleekCarSidePainter({required this.glow}) : super(repaint: glow);

  @override
  void paint(Canvas canvas, Size size) {
    const Color neon = Color(0xFF00E676);
    final w = size.width;
    final h = size.height;

    // 1. Road Underglow Shadow
    final underglow = Paint()
      ..color = neon.withValues(alpha: 0.35 * glow.value)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14);
    canvas.drawOval(Rect.fromLTWH(w * 0.1, h * 0.86, w * 0.8, 10), underglow);

    // 2. Car Body Silhouette
    final bodyPath = Path();
    bodyPath.moveTo(w * 0.06, h * 0.70); // Rear bumper bottom
    bodyPath.lineTo(w * 0.04, h * 0.62); // Rear tail
    bodyPath.lineTo(w * 0.08, h * 0.52); // Rear spoiler/deck
    bodyPath.lineTo(w * 0.20, h * 0.50); // Trunk
    bodyPath.quadraticBezierTo(w * 0.34, h * 0.24, w * 0.48, h * 0.22); // Rear glass & Roof
    bodyPath.lineTo(w * 0.60, h * 0.22); // Flat roof
    bodyPath.quadraticBezierTo(w * 0.74, h * 0.26, w * 0.80, h * 0.48); // Windshield slope
    bodyPath.lineTo(w * 0.94, h * 0.58); // Hood slope
    bodyPath.lineTo(w * 0.98, h * 0.65); // Nose / Front grille
    bodyPath.lineTo(w * 0.94, h * 0.74); // Front splitter bottom
    
    // Front wheel arch
    bodyPath.lineTo(w * 0.84, h * 0.74);
    bodyPath.arcToPoint(Offset(w * 0.68, h * 0.74), radius: Radius.circular(w * 0.09), clockwise: false);
    
    // Bottom side skirt
    bodyPath.lineTo(w * 0.36, h * 0.74);
    
    // Rear wheel arch
    bodyPath.arcToPoint(Offset(w * 0.20, h * 0.74), radius: Radius.circular(w * 0.09), clockwise: false);
    bodyPath.close();

    // Fill Car Body with Dark Metallic Tone
    final bodyFill = Paint()..color = const Color(0xFF101712);
    canvas.drawPath(bodyPath, bodyFill);

    // Neon Green Outline on Body
    final bodyStroke = Paint()
      ..color = neon
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;
    canvas.drawPath(bodyPath, bodyStroke);

    // 3. Tinted Window Glass & Pillars
    final windowPath = Path();
    windowPath.moveTo(w * 0.24, h * 0.48);
    windowPath.lineTo(w * 0.36, h * 0.28);
    windowPath.lineTo(w * 0.58, h * 0.28);
    windowPath.lineTo(w * 0.76, h * 0.48);
    windowPath.close();

    final windowFill = Paint()..color = const Color(0xFF1E2D23);
    canvas.drawPath(windowPath, windowFill);

    final windowStroke = Paint()
      ..color = neon.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(windowPath, windowStroke);

    // Center B-Pillar divider
    canvas.drawLine(Offset(w * 0.48, h * 0.28), Offset(w * 0.48, h * 0.48), windowStroke);

    // 4. Side Mirror
    final mirrorPaint = Paint()..color = neon;
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.72, h * 0.46, 12, 6), const Radius.circular(3)), mirrorPaint);

    // 5. LED Headlight Beaming Forward
    final headlightPaint = Paint()
      ..color = const Color(0xFF00FF66)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(Offset(w * 0.95, h * 0.62), 5, headlightPaint);
    canvas.drawCircle(Offset(w * 0.95, h * 0.62), 2.5, Paint()..color = Colors.white);

    // Headlight Light Beam Cone
    final beamPath = Path();
    beamPath.moveTo(w * 0.96, h * 0.62);
    beamPath.lineTo(w * 1.08, h * 0.52);
    beamPath.lineTo(w * 1.08, h * 0.74);
    beamPath.close();
    final beamPaint = Paint()
      ..color = neon.withValues(alpha: 0.25 * glow.value)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawPath(beamPath, beamPaint);

    // Red LED Taillight Strip
    final taillightPaint = Paint()
      ..color = Colors.redAccent
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(w * 0.05, h * 0.58), Offset(w * 0.08, h * 0.58), taillightPaint);

    // 6. Real Wheels with Rims & Tires
    _drawRealWheel(canvas, Offset(w * 0.28, h * 0.74), size.height * 0.22, neon);
    _drawRealWheel(canvas, Offset(w * 0.76, h * 0.74), size.height * 0.22, neon);
  }

  void _drawRealWheel(Canvas canvas, Offset center, double radius, Color neon) {
    // Black Rubber Tire
    final tirePaint = Paint()..color = const Color(0xFF050806);
    canvas.drawCircle(center, radius, tirePaint);

    final tireBorder = Paint()
      ..color = const Color(0xFF2A3A2F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawCircle(center, radius, tireBorder);

    // Metallic Inner Rim
    final rimRadius = radius * 0.68;
    final rimFill = Paint()..color = const Color(0xFF152219);
    canvas.drawCircle(center, rimRadius, rimFill);

    // Neon Alloy Rim Ring
    final rimRing = Paint()
      ..color = neon
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, rimRadius, rimRing);

    // 5-Star Alloy Wheel Spokes
    final spokePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..strokeWidth = 1.8;
    for (int i = 0; i < 5; i++) {
      final angle = (i * 72.0) * 3.14159 / 180.0;
      final spokeEnd = Offset(center.dx + rimRadius * 0.9 * (angle).clamp(-1.0, 1.0), center.dy + rimRadius * 0.9 * ((i * 72) % 360 > 180 ? -0.8 : 0.8));
      canvas.drawLine(center, spokeEnd, spokePaint);
    }

    // Center Hub Cap
    canvas.drawCircle(center, 3.5, Paint()..color = neon);
  }

  @override
  bool shouldRepaint(covariant RealSleekCarSidePainter oldDelegate) => true;
}
'@ | Set-Content -Path 'lib/screens/auth/login_screen.dart' -Encoding UTF8

Write-Host "Verifying code health with flutter analyze..." -ForegroundColor Green
dart fix --apply | Out-Null
flutter analyze

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " Real Sleek Sports Car Added Successfully to Login Screen!                    " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green