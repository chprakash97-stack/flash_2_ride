Write-Host "Rebuilding Screen 1 (Splash Screen) Pin-to-Pin matching Roadmap Image..." -ForegroundColor Green

# 1. Update AppTheme to support both lightTheme and masterTheme
@'
import 'package:flutter/material.dart';

class AppTheme {
  static const Color brandPurple = Color(0xFF3B28CC);
  static const Color brandPurpleLight = Color(0xFF5E43F3);
  static const Color brandYellow = Color(0xFFFFC107);
  static const Color backgroundLight = Color(0xFFF8F9FE);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color borderGrey = Color(0xFFE2E8F0);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textGrey = Color(0xFF64748B);

  // Backward compatibility aliases
  static const Color primaryGreen = Color(0xFF3B28CC);
  static const Color cardBlack = Color(0xFFFFFFFF);
  static const Color backgroundBlack = Color(0xFFF8F9FE);
  static const Color textWhite = Color(0xFF0F172A);
  static const Color textBlack = Color(0xFF0F172A);

  static ThemeData get lightTheme => masterTheme;

  static ThemeData get masterTheme {
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

# 2. Rebuild Splash Screen Pin-to-Pin Matching Screen #1 in Roadmap
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
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    _scaleAnimation = CurvedAnimation(parent: _animController, curve: Curves.easeOutBack);
    _animController.forward();

    // Showcase splash animation then transition to Screen 2
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
    const Color brandPurple = Color(0xFF3320B5);
    const Color brandPurpleLight = Color(0xFF563BE2);
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

              // 1. Top Arched Yellow Car Silhouette Outline
              CustomPaint(
                size: const Size(130, 24),
                painter: YellowCarRoofPainter(),
              ),
              const SizedBox(height: 6),

              // 2. Exact ≡Flash2Ride Brand Logo
              ScaleTransition(
                scale: _scaleAnimation,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Speedlines
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
              ),
              const SizedBox(height: 6),

              // 3. Subtitle: Ride Smart • Travel Easy (Clean Native Dot - Zero Encoding Glitch)
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

              // 4. Pin-to-Pin Center Artwork (Skyline + Tilted Phone Map Pin + Realistic White Sedan Cab)
              Center(
                child: SizedBox(
                  width: 320,
                  height: 155,
                  child: CustomPaint(
                    painter: MasterArtworkPinToPinPainter(),
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

// 🎨 Top Yellow Car Roof Curve Painter
class YellowCarRoofPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFC107)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width * 0.45, -10, size.width, size.height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 🎨 Master Artwork Painter: Realistic 3D White Sedan Cab + Phone Map Pin + City Skyline
class MasterArtworkPinToPinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // A. City Skyline in Background (Lavender/Transparent Pillars)
    final buildingPaint = Paint()..color = Colors.white.withValues(alpha: 0.18);
    final buildings = [
      Rect.fromLTWH(w * 0.18, h * 0.30, 22, h * 0.50),
      Rect.fromLTWH(w * 0.26, h * 0.18, 28, h * 0.62),
      Rect.fromLTWH(w * 0.36, h * 0.35, 18, h * 0.45),
      Rect.fromLTWH(w * 0.43, h * 0.08, 30, h * 0.72),
      Rect.fromLTWH(w * 0.54, h * 0.22, 24, h * 0.58),
      Rect.fromLTWH(w * 0.63, h * 0.12, 28, h * 0.68),
      Rect.fromLTWH(w * 0.73, h * 0.26, 22, h * 0.54),
      Rect.fromLTWH(w * 0.81, h * 0.38, 20, h * 0.42),
    ];
    for (final b in buildings) {
      canvas.drawRRect(RRect.fromRectAndRadius(b, const Radius.circular(3)), buildingPaint);
    }

    // B. Left Upright Smartphone with Map & Purple Pin
    final phoneRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.08, h * 0.15, 68, 105),
      const Radius.circular(14),
    );
    // Phone Shadow
    canvas.drawRRect(
      phoneRect,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );
    // Phone Body (White Bezel)
    canvas.drawRRect(phoneRect, Paint()..color = Colors.white);
    canvas.drawRRect(phoneRect, Paint()..color = const Color(0xFFCBD5E1)..style = PaintingStyle.stroke..strokeWidth = 1.5);

    // Screen Area inside Phone
    final screenRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.08 + 4, h * 0.15 + 4, 60, 97),
      const Radius.circular(10),
    );
    canvas.drawRRect(screenRect, Paint()..color = const Color(0xFFF1F5F9));

    // Map Grid Roads inside Phone
    final roadPaint = Paint()..color = Colors.white..strokeWidth = 6;
    canvas.drawLine(Offset(w * 0.08 + 10, h * 0.15 + 20), Offset(w * 0.08 + 54, h * 0.15 + 85), roadPaint);
    canvas.drawLine(Offset(w * 0.08 + 50, h * 0.15 + 30), Offset(w * 0.08 + 15, h * 0.15 + 75), roadPaint);

    // Purple Location Pin on Phone
    final pinCenter = Offset(w * 0.08 + 34, h * 0.15 + 44);
    // Pin Shadow
    canvas.drawOval(
      Rect.fromCenter(center: Offset(pinCenter.dx, pinCenter.dy + 14), width: 14, height: 6),
      Paint()..color = Colors.black26..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
    // Pin Head (Purple)
    final pinPaint = Paint()..color = const Color(0xFF4C32D8);
    final pinPath = Path();
    pinPath.moveTo(pinCenter.dx, pinCenter.dy + 14); // Pin bottom tip
    pinPath.quadraticBezierTo(pinCenter.dx - 12, pinCenter.dy + 2, pinCenter.dx - 10, pinCenter.dy - 6);
    pinPath.arcToPoint(Offset(pinCenter.dx + 10, pinCenter.dy - 6), radius: const Radius.circular(10));
    pinPath.quadraticBezierTo(pinCenter.dx + 12, pinCenter.dy + 2, pinCenter.dx, pinCenter.dy + 14);
    pinPath.close();
    canvas.drawPath(pinPath, pinPaint);
    // White inner hole of pin
    canvas.drawCircle(Offset(pinCenter.dx, pinCenter.dy - 6), 4, Paint()..color = Colors.white);

    // C. Right Realistic 3/4 Perspective White Sedan Cab
    const carLeft = 0.28;
    // Ground Shadow under Car
    canvas.drawOval(
      Rect.fromLTWH(w * carLeft + 10, h * 0.82, w * 0.60, 14),
      Paint()..color = Colors.black.withValues(alpha: 0.45)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    // Car Body Path (3/4 Sleek Sedan Perspective)
    final carPath = Path();
    carPath.moveTo(w * carLeft + 15, h * 0.72); // Rear bumper
    carPath.lineTo(w * carLeft + 12, h * 0.58); // Rear deck corner
    carPath.lineTo(w * carLeft + 35, h * 0.52); // Trunk lid
    carPath.quadraticBezierTo(w * carLeft + 65, h * 0.26, w * carLeft + 95, h * 0.25); // Rear glass & roof
    carPath.lineTo(w * carLeft + 130, h * 0.25); // Flat roof
    carPath.quadraticBezierTo(w * carLeft + 150, h * 0.30, w * carLeft + 165, h * 0.50); // Windshield slope
    carPath.lineTo(w * carLeft + 195, h * 0.58); // Hood forward
    carPath.lineTo(w * carLeft + 204, h * 0.68); // Front nose / grille
    carPath.lineTo(w * carLeft + 196, h * 0.76); // Front bumper bottom
    // Front wheel arch
    carPath.lineTo(w * carLeft + 180, h * 0.76);
    carPath.arcToPoint(Offset(w * carLeft + 148, h * 0.76), radius: const Radius.circular(16), clockwise: false);
    // Side skirt
    carPath.lineTo(w * carLeft + 85, h * 0.76);
    // Rear wheel arch
    carPath.arcToPoint(Offset(w * carLeft + 53, h * 0.76), radius: const Radius.circular(16), clockwise: false);
    carPath.close();

    // Paint White Gloss Body with subtle gradient shading
    final bodyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.white, const Color(0xFFF1F5F9), const Color(0xFFE2E8F0)],
      ).createShader(Rect.fromLTWH(w * carLeft, h * 0.25, w * 0.65, h * 0.60));
    canvas.drawPath(carPath, bodyPaint);
    canvas.drawPath(carPath, Paint()..color = const Color(0xFFCBD5E1)..style = PaintingStyle.stroke..strokeWidth = 1.5);

    // Car Windows (Tinted Glass)
    final glassPath = Path();
    glassPath.moveTo(w * carLeft + 42, h * 0.50);
    glassPath.lineTo(w * carLeft + 68, h * 0.30);
    glassPath.lineTo(w * carLeft + 126, h * 0.30);
    glassPath.lineTo(w * carLeft + 155, h * 0.48);
    glassPath.close();
    canvas.drawPath(glassPath, Paint()..color = const Color(0xFF1E293B));
    canvas.drawPath(glassPath, Paint()..color = Colors.white24..style = PaintingStyle.stroke..strokeWidth = 1.0);

    // B-Pillar divider
    canvas.drawLine(Offset(w * carLeft + 100, h * 0.30), Offset(w * carLeft + 100, h * 0.50), Paint()..color = Colors.white..strokeWidth = 2.5);

    // Yellow Brand Stripe along Lower Body
    final stripePath = Path();
    stripePath.moveTo(w * carLeft + 25, h * 0.64);
    stripePath.lineTo(w * carLeft + 185, h * 0.64);
    stripePath.lineTo(w * carLeft + 188, h * 0.70);
    stripePath.lineTo(w * carLeft + 25, h * 0.70);
    stripePath.close();
    canvas.drawPath(stripePath, Paint()..color = const Color(0xFFFFC107));

    // "Flash2Ride" Decal on Car Door
    final textPainter = TextPainter(
      text: const TextSpan(
        children: [
          TextSpan(text: 'Flash', style: TextStyle(color: Color(0xFF1E293B), fontSize: 8.5, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
          TextSpan(text: '2', style: TextStyle(color: Color(0xFF3320B5), fontSize: 9.5, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
          TextSpan(text: 'Ride', style: TextStyle(color: Color(0xFF1E293B), fontSize: 8.5, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
        ],
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset(w * carLeft + 80, h * 0.62));

    // Yellow Side Mirror
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * carLeft + 146, h * 0.46, 11, 6), const Radius.circular(2)),
      Paint()..color = const Color(0xFFFFC107),
    );

    // Front Headlight (Swept-back LED projector with glowing beam)
    final headlightPath = Path();
    headlightPath.moveTo(w * carLeft + 192, h * 0.58);
    headlightPath.lineTo(w * carLeft + 203, h * 0.65);
    headlightPath.lineTo(w * carLeft + 194, h * 0.68);
    headlightPath.close();
    canvas.drawPath(headlightPath, Paint()..color = const Color(0xFFFFE082));
    canvas.drawPath(
      headlightPath,
      Paint()
        ..color = Colors.white
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // Rear Taillight Red Edge
    canvas.drawLine(
      Offset(w * carLeft + 13, h * 0.58),
      Offset(w * carLeft + 16, h * 0.63),
      Paint()..color = Colors.redAccent..strokeWidth = 3,
    );

    // D. Realistic Detailed Alloy Wheels (Rubber Tire + 5-Spoke Alloy Rim)
    _drawRealisticWheel(canvas, Offset(w * carLeft + 69, h * 0.76), 16);
    _drawRealisticWheel(canvas, Offset(w * carLeft + 164, h * 0.76), 16);
  }

  void _drawRealisticWheel(Canvas canvas, Offset center, double radius) {
    // 1. Black Tire Rubber
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFF0F172A));
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFF334155)..style = PaintingStyle.stroke..strokeWidth = 2);

    // 2. Metallic Silver Inner Rim
    final rimRadius = radius * 0.72;
    canvas.drawCircle(center, rimRadius, Paint()..color = const Color(0xFFE2E8F0));
    canvas.drawCircle(center, rimRadius, Paint()..color = const Color(0xFF94A3B8)..style = PaintingStyle.stroke..strokeWidth = 1.5);

    // 3. 5-Spoke Silver Star Rims
    final spokePaint = Paint()..color = const Color(0xFF475569)..strokeWidth = 2.0;
    for (int i = 0; i < 5; i++) {
      final rad = (i * 72.0) * 3.14159 / 180.0;
      canvas.drawLine(center, Offset(center.dx + rimRadius * 0.85 * (rad).clamp(-1.0, 1.0), center.dy + rimRadius * 0.85 * ((i * 72) % 360 > 180 ? -0.8 : 0.8)), spokePaint);
    }

    // 4. Center Hub Cap with Yellow Accent
    canvas.drawCircle(center, 3.5, Paint()..color = const Color(0xFFFFC107));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
'@ | Set-Content -Path 'lib/screens/splash_screen.dart' -Encoding UTF8

Write-Host "Running flutter analyze..." -ForegroundColor Green
dart fix --apply | Out-Null
flutter analyze

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " Screen 1 Rebuilt Pin-to-Pin Matching Roadmap Image Successfully!             " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green