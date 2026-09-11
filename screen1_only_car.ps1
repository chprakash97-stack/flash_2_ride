Write-Host "Extracting ONLY the Car and Building Pure Flutter Splash Screen..." -ForegroundColor Green
Add-Type -AssemblyName System.Drawing

$assetsDir = "assets\images"
if (!(Test-Path $assetsDir)) { New-Item -ItemType Directory -Path $assetsDir -Force | Out-Null }

# 1. Find the user's image and crop ONLY the car
$imgFiles = Get-ChildItem -Path ".", $assetsDir, "$env:USERPROFILE\Desktop", "$env:USERPROFILE\Downloads" -Include "*.png","*.jpg","*.jpeg","*.webp" -File -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -notmatch "car_only|favicon|icon" } |
            Sort-Object LastWriteTime -Descending

$carDest = "assets\images\car_only.png"

if ($imgFiles -and $imgFiles.Count -gt 0) {
    $srcPath = $imgFiles[0].FullName
    Write-Host "Extracting car from: $srcPath" -ForegroundColor Cyan
    try {
        $bmp = [System.Drawing.Bitmap]::FromFile($srcPath)
        $aspect = $bmp.Width / $bmp.Height
        
        # If it is the 30-screen master sheet:
        if ($bmp.Width -gt 1000 -and $aspect -gt 0.8 -and $aspect -lt 1.3) {
            # Crop the high-res 3D car from the bottom right banner:
            $cropX = [int]($bmp.Width * 0.63)
            $cropY = [int]($bmp.Height * 0.90)
            $cropW = [int]($bmp.Width * 0.34)
            $cropH = [int]($bmp.Height * 0.088)
            $rect = New-Object System.Drawing.Rectangle $cropX, $cropY, $cropW, $cropH
            $cropped = $bmp.Clone($rect, $bmp.PixelFormat)
            $cropped.Save($carDest, [System.Drawing.Imaging.ImageFormat]::Png)
            $cropped.Dispose()
            Write-Host "Extracted Car ONLY into $carDest!" -ForegroundColor Green
        }
        # If it is a mobile screenshot:
        elseif ($bmp.Height -gt $bmp.Width) {
            # Crop only the car area (middle right):
            $cropX = [int]($bmp.Width * 0.35)
            $cropY = [int]($bmp.Height * 0.23)
            $cropW = [int]($bmp.Width * 0.60)
            $cropH = [int]($bmp.Height * 0.14)
            $rect = New-Object System.Drawing.Rectangle $cropX, $cropY, $cropW, $cropH
            $cropped = $bmp.Clone($rect, $bmp.PixelFormat)
            $cropped.Save($carDest, [System.Drawing.Imaging.ImageFormat]::Png)
            $cropped.Dispose()
            Write-Host "Extracted Car ONLY into $carDest!" -ForegroundColor Green
        }
        else {
            Copy-Item -Path $srcPath -Destination $carDest -Force
        }
        $bmp.Dispose()
    } catch {
        Copy-Item -Path $imgFiles[0].FullName -Destination $carDest -Force
    }
}

# 2. Pure Flutter Native Screen 1 (No Auto-jump to Login Screen!)
@'
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // NO auto-navigation! Stays on Splash Screen so user can inspect it.

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

              // 1. Live Native Yellow Car Roof Outline (Coded)
              CustomPaint(
                size: const Size(130, 26),
                painter: HeaderCarArcPainter(),
              ),
              const SizedBox(height: 6),

              // 2. Exact Brand Logo ≡Flash2Ride (Coded)
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

              // 3. Subtitle: Ride Smart • Travel Easy (Coded)
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

              // 4. Center Artwork: Coded Smartphone with Map & Pin + Coded Skyline + Real Car ONLY!
              Center(
                child: SizedBox(
                  width: 330,
                  height: 160,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      // A. Coded City Skyline Towers in Background
                      Positioned(
                        bottom: 12,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildSkylineTower(18, 55),
                            _buildSkylineTower(24, 75),
                            _buildSkylineTower(16, 45),
                            _buildSkylineTower(28, 95),
                            _buildSkylineTower(22, 65),
                            _buildSkylineTower(26, 85),
                            _buildSkylineTower(20, 50),
                          ],
                        ),
                      ),

                      // B. Coded 3D Smartphone on Left with Map & Purple Pin
                      Positioned(
                        left: 18,
                        bottom: 6,
                        child: Container(
                          width: 68,
                          height: 108,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.35), blurRadius: 10, offset: const Offset(0, 4)),
                            ],
                            border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              Positioned(top: 15, left: 5, right: 5, child: Container(height: 4, color: Colors.white)),
                              Positioned(top: 40, left: 10, right: 10, child: Container(height: 4, color: Colors.white)),
                              Positioned(top: 65, left: 5, right: 5, child: Container(height: 4, color: Colors.white)),
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF3F2B96),
                                  ),
                                  child: const Icon(Icons.location_on, size: 16, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // C. THE REAL CAR IMAGE ONLY (Positioned cleanly on the right)
                      Positioned(
                        right: 8,
                        bottom: 4,
                        child: SizedBox(
                          width: 235,
                          height: 115,
                          child: Image.asset(
                            'assets/images/car_only.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset('assets/images/car_artwork.png', fit: BoxFit.contain);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 3),

              // 5. Coded Bottom Loading Spinner
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

  Widget _buildSkylineTower(double width, double height) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
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
'@ | Set-Content -Path 'lib/screens/splash_screen.dart' -Encoding UTF8

dart fix --apply | Out-Null
flutter analyze

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " Screen 1 (Splash Screen) Only Ready! Auto-jump Disabled. Press Ctrl+R to view" -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green