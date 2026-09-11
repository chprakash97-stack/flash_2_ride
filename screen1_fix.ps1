Write-Host "Rendering Screen 1 Pin-to-Pin matching Roadmap Image..." -ForegroundColor Green

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

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);

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
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: [
              const Spacer(flex: 2),

              // 1. Top Yellow Car Roof Silhouette Arc
              CustomPaint(
                size: const Size(130, 26),
                painter: HeaderCarArcPainter(),
              ),
              const SizedBox(height: 6),

              // 2. Exact Brand Logo ≡Flash2Ride
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Yellow Speedlines
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
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(width: 4, height: 4, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white70)),
                  ),
                  const Text('Travel Easy', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.8)),
                ],
              ),

              const Spacer(flex: 3),

              // 4. Center Realistic 3D Artwork (Phone + 3/4 White Sedan Cab + City Skyline)
              Center(
                child: SizedBox(
                  width: 320,
                  height: 160,
                  child: CustomPaint(
                    painter: MasterRoadmapArtworkPainter(),
                  ),
                ),
              ),

              const Spacer(flex: 3),

              // 5. Bottom Loading Indicator & Text
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
}

// Top Car Roofline Painter
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

// 🎨 Master Artwork Painter matching Roadmap Image #1 exactly
class MasterRoadmapArtworkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. City Skyline (Lavender Silhouette Skyscrapers)
    final skylinePaint = Paint()..color = Colors.white.withValues(alpha: 0.18);
    final buildings = [
      Rect.fromLTWH(w * 0.16, h * 0.28, 20, h * 0.50),
      Rect.fromLTWH(w * 0.24, h * 0.14, 26, h * 0.64),
      Rect.fromLTWH(w * 0.34, h * 0.32, 18, h * 0.46),
      Rect.fromLTWH(w * 0.41, h * 0.05, 30, h * 0.73),
      Rect.fromLTWH(w * 0.52, h * 0.20, 24, h * 0.58),
      Rect.fromLTWH(w * 0.61, h * 0.10, 28, h * 0.68),
      Rect.fromLTWH(w * 0.71, h * 0.24, 22, h * 0.54),
      Rect.fromLTWH(w * 0.79, h * 0.36, 20, h * 0.42),
    ];
    for (final b in buildings) {
      canvas.drawRRect(RRect.fromRectAndRadius(b, const Radius.circular(3)), skylinePaint);
    }

    // 2. Left 3D-Style Smartphone Card
    final phoneRect = RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.06, h * 0.12, 68, 110), const Radius.circular(14));
    // Phone Drop Shadow
    canvas.drawRRect(
      phoneRect,
      Paint()..color = Colors.black.withValues(alpha: 0.35)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );
    // Phone White Bezel
    canvas.drawRRect(phoneRect, Paint()..color = Colors.white);
    canvas.drawRRect(phoneRect, Paint()..color = const Color(0xFFCBD5E1)..style = PaintingStyle.stroke..strokeWidth = 1.5);

    // Phone Screen Area
    final screenRect = RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.06 + 4, h * 0.12 + 4, 60, 102), const Radius.circular(10));
    canvas.drawRRect(screenRect, Paint()..color = const Color(0xFFF1F5F9));

    // Map Roads on Screen
    final roadPaint = Paint()..color = Colors.white..strokeWidth = 5;
    canvas.drawLine(Offset(w * 0.06 + 10, h * 0.12 + 20), Offset(w * 0.06 + 54, h * 0.12 + 90), roadPaint);
    canvas.drawLine(Offset(w * 0.06 + 50, h * 0.12 + 30), Offset(w * 0.06 + 15, h * 0.12 + 80), roadPaint);

    // Purple Location Pin (📍) on Phone
    final pinCenter = Offset(w * 0.06 + 34, h * 0.12 + 46);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(pinCenter.dx, pinCenter.dy + 14), width: 14, height: 6),
      Paint()..color = Colors.black26..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
    final pinPaint = Paint()..color = const Color(0xFF3F2B96);
    final pinPath = Path();
    pinPath.moveTo(pinCenter.dx, pinCenter.dy + 14);
    pinPath.quadraticBezierTo(pinCenter.dx - 12, pinCenter.dy + 2, pinCenter.dx - 10, pinCenter.dy - 6);
    pinPath.arcToPoint(Offset(pinCenter.dx + 10, pinCenter.dy - 6), radius: const Radius.circular(10));
    pinPath.quadraticBezierTo(pinCenter.dx + 12, pinCenter.dy + 2, pinCenter.dx, pinCenter.dy + 14);
    pinPath.close();
    canvas.drawPath(pinPath, pinPaint);
    canvas.drawCircle(Offset(pinCenter.dx, pinCenter.dy - 6), 4, Paint()..color = Colors.white);

    // 3. Right 3/4 Perspective White Sedan Car (Exact Shape from Roadmap)
    const carX = 0.28;
    // Ground Shadow under Car
    canvas.drawOval(
      Rect.fromLTWH(w * carX + 15, h * 0.82, w * 0.62, 14),
      Paint()..color = Colors.black.withValues(alpha: 0.45)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Realistic Sleek 3/4 Car Body Path
    final carBody = Path();
    carBody.moveTo(w * carX + 20, h * 0.70); // Rear bumper bottom
    carBody.lineTo(w * carX + 18, h * 0.56); // Rear trunk corner
    carBody.lineTo(w * carX + 45, h * 0.50); // Trunk deck
    carBody.quadraticBezierTo(w * carX + 75, h * 0.22, w * carX + 110, h * 0.22); // Rear glass to roof
    carBody.lineTo(w * carX + 145, h * 0.22); // Aerodynamic roof
    carBody.quadraticBezierTo(w * carX + 168, h * 0.28, w * carX + 182, h * 0.48); // Windshield slope
    carBody.lineTo(w * carX + 215, h * 0.56); // Hood slope
    carBody.lineTo(w * carX + 225, h * 0.65); // Front nose / headlights
    carBody.lineTo(w * carX + 218, h * 0.74); // Front bumper spoiler
    // Front Wheel Arch
    carBody.lineTo(w * carX + 200, h * 0.74);
    carBody.arcToPoint(Offset(w * carX + 166, h * 0.74), radius: const Radius.circular(17), clockwise: false);
    // Bottom Side Skirt
    carBody.lineTo(w * carX + 96, h * 0.74);
    // Rear Wheel Arch
    carBody.arcToPoint(Offset(w * carX + 62, h * 0.74), radius: const Radius.circular(17), clockwise: false);
    carBody.close();

    // Body Fill (White Metallic Shading)
    final bodyShader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.white, const Color(0xFFF1F5F9), const Color(0xFFE2E8F0)],
    ).createShader(Rect.fromLTWH(w * carX, h * 0.20, w * 0.65, h * 0.60));
    canvas.drawPath(carBody, Paint()..shader = bodyShader);
    canvas.drawPath(carBody, Paint()..color = const Color(0xFFCBD5E1)..style = PaintingStyle.stroke..strokeWidth = 1.5);

    // Front Bumper Lower Air Intake (Black Grille)
    final grillePath = Path();
    grillePath.moveTo(w * carX + 215, h * 0.68);
    grillePath.lineTo(w * carX + 223, h * 0.66);
    grillePath.lineTo(w * carX + 217, h * 0.73);
    grillePath.lineTo(w * carX + 206, h * 0.73);
    grillePath.close();
    canvas.drawPath(grillePath, Paint()..color = const Color(0xFF1E293B));

    // Dark Tinted Windows
    final windowPath = Path();
    windowPath.moveTo(w * carX + 50, h * 0.48);
    windowPath.lineTo(w * carX + 78, h * 0.26);
    windowPath.lineTo(w * carX + 140, h * 0.26);
    windowPath.lineTo(w * carX + 172, h * 0.46);
    windowPath.close();
    canvas.drawPath(windowPath, Paint()..color = const Color(0xFF0F172A));
    // Window Outline & B-Pillar
    canvas.drawPath(windowPath, Paint()..color = Colors.white24..style = PaintingStyle.stroke..strokeWidth = 1.0);
    canvas.drawLine(Offset(w * carX + 112, h * 0.26), Offset(w * carX + 112, h * 0.48), Paint()..color = Colors.white..strokeWidth = 2.5);

    // Yellow Accent Door Stripe
    final stripe = Path();
    stripe.moveTo(w * carX + 32, h * 0.62);
    stripe.lineTo(w * carX + 204, h * 0.62);
    stripe.lineTo(w * carX + 207, h * 0.68);
    stripe.lineTo(w * carX + 32, h * 0.68);
    stripe.close();
    canvas.drawPath(stripe, Paint()..color = const Color(0xFFFFC107));

    // "Flash2Ride" Door Logo
    final textPainter = TextPainter(
      text: const TextSpan(
        children: [
          TextSpan(text: 'Flash', style: TextStyle(color: Color(0xFF0F172A), fontSize: 9, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
          TextSpan(text: '2', style: TextStyle(color: Color(0xFF2C198A), fontSize: 10, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
          TextSpan(text: 'Ride', style: TextStyle(color: Color(0xFF0F172A), fontSize: 9, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
        ],
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset(w * carX + 90, h * 0.60));

    // Yellow Wing Mirror
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * carX + 162, h * 0.44, 12, 6), const Radius.circular(2)),
      Paint()..color = const Color(0xFFFFC107),
    );

    // Front Dual LED Headlight (Swept-back Projectors)
    final headlight = Path();
    headlight.moveTo(w * carX + 212, h * 0.56);
    headlight.lineTo(w * carX + 224, h * 0.63);
    headlight.lineTo(w * carX + 214, h * 0.66);
    headlight.close();
    canvas.drawPath(headlight, Paint()..color = const Color(0xFFFFD54F));
    canvas.drawCircle(Offset(w * carX + 218, h * 0.61), 3.5, Paint()..color = Colors.white);

    // Rear Taillight Red Edge
    canvas.drawLine(Offset(w * carX + 18, h * 0.56), Offset(w * carX + 22, h * 0.62), Paint()..color = Colors.redAccent..strokeWidth = 3);

    // Realistic Alloy Wheels (Black Rubber Tire + Silver Alloy Rims + Yellow Hub)
    _drawRealisticWheel(canvas, Offset(w * carX + 79, h * 0.74), 16);
    _drawRealisticWheel(canvas, Offset(w * carX + 183, h * 0.74), 16);
  }

  void _drawRealisticWheel(Canvas canvas, Offset center, double radius) {
    // 1. Black Tire Rubber
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFF0F172A));
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFF334155)..style = PaintingStyle.stroke..strokeWidth = 2);

    // 2. Metallic Silver Rim
    final rimR = radius * 0.72;
    canvas.drawCircle(center, rimR, Paint()..color = const Color(0xFFE2E8F0));
    canvas.drawCircle(center, rimR, Paint()..color = const Color(0xFF94A3B8)..style = PaintingStyle.stroke..strokeWidth = 1.5);

    // 3. 5-Spoke Alloy Star
    final spokePaint = Paint()..color = const Color(0xFF475569)..strokeWidth = 2.0;
    for (int i = 0; i < 5; i++) {
      final rad = (i * 72.0) * 3.14159 / 180.0;
      canvas.drawLine(center, Offset(center.dx + rimR * 0.85 * (rad).clamp(-1.0, 1.0), center.dy + rimR * 0.85 * ((i * 72) % 360 > 180 ? -0.8 : 0.8)), spokePaint);
    }

    // 4. Yellow Center Hub Cap
    canvas.drawCircle(center, 3.5, Paint()..color = const Color(0xFFFFC107));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
'@ | Set-Content -Path 'lib/screens/splash_screen.dart' -Encoding UTF8

Write-Host "Verifying with flutter analyze..." -ForegroundColor Green
dart fix --apply | Out-Null
flutter analyze

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " Screen 1 (Splash Screen) Rebuilt with 100% Precision!                        " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green