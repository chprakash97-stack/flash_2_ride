Write-Host "Building Professional Native Splash Screen with Isolated Car Artwork..." -ForegroundColor Green
Add-Type -AssemblyName System.Drawing

$assetsDir = "assets\images"
if (!(Test-Path $assetsDir)) { New-Item -ItemType Directory -Path $assetsDir -Force | Out-Null }

$source = "assets\images\splash_exact.png"
$carOnly = "assets\images\car_artwork.png"

# 1. Extract ONLY the center Car & Phone artwork cleanly from the image
if (Test-Path $source) {
    try {
        $bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path $source).Path)
        # Crop the center car + phone artwork area
        $cropY = [int]($bmp.Height * 0.28)
        $cropH = [int]($bmp.Height * 0.44)
        $cropX = [int]($bmp.Width * 0.04)
        $cropW = [int]($bmp.Width * 0.92)

        $rect = New-Object System.Drawing.Rectangle $cropX, $cropY, $cropW, $cropH
        $cropped = $bmp.Clone($rect, $bmp.PixelFormat)
        $cropped.Save($carOnly, [System.Drawing.Imaging.ImageFormat]::Png)
        $cropped.Dispose()
        $bmp.Dispose()
        Write-Host "Extracted center Car & Phone artwork cleanly into $carOnly!" -ForegroundColor Green
    } catch {
        Copy-Item -Path $source -Destination $carOnly -Force
    }
}

# 2. Build 100% Real Native Professional Splash Screen in Flutter
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

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();

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

              // 1. Live Native Yellow Car Roof Outline
              CustomPaint(
                size: const Size(130, 24),
                painter: HeaderCarArcPainter(),
              ),
              const SizedBox(height: 6),

              // 2. Crisp Live Brand Title ≡Flash2Ride
              FadeTransition(
                opacity: _fadeIn,
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

              // 3. Live Native Subtitle: Ride Smart • Travel Easy
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

              // 4. Clean Centered Car Artwork from Designer Image
              Center(
                child: SizedBox(
                  width: 320,
                  height: 150,
                  child: Image.asset(
                    'assets/images/car_artwork.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/images/splash_exact.png', fit: BoxFit.contain);
                    },
                  ),
                ),
              ),

              const Spacer(flex: 3),

              // 5. Live Native Bottom Loading Spinner
              Column(
                children: const [
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
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
    path.quadraticBezierTo(size.width * 0.45, -10, size.width, size.height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
'@ | Set-Content -Path 'lib/screens/splash_screen.dart' -Encoding UTF8

Write-Host "Verifying code health..." -ForegroundColor Green
flutter analyze
Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " Professional Native Splash Screen Ready! Press Ctrl+R in Chrome to view!     " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green