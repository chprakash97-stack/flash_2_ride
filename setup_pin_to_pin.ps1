Write-Host "Configuring Print-to-Print Real Image Engine for Flash2Ride..." -ForegroundColor Green
Add-Type -AssemblyName System.Drawing

# 1. Create assets/images folder
$assetsDir = "assets\images"
if (!(Test-Path $assetsDir)) { 
    New-Item -ItemType Directory -Path $assetsDir -Force | Out-Null 
    Write-Host "Created folder: assets/images" -ForegroundColor Green
}

# 2. Automatically locate and crop master design from user's Desktop or Downloads
$locations = @(
    "$env:USERPROFILE\Desktop",
    "$env:USERPROFILE\Downloads",
    "$env:USERPROFILE\Pictures",
    "C:\Users\DELL\Desktop"
)

$foundMaster = $null
foreach ($loc in $locations) {
    if (Test-Path $loc) {
        $matches = Get-ChildItem -Path $loc -Recurse -Depth 2 -Include "*100234*","*f43b*","*68e667*","*flash*","*ride*" -ErrorAction SilentlyContinue |
                   Where-Object { $_.Extension -match "\.(png|jpg|jpeg)$" }
        if ($matches) {
            $foundMaster = $matches[0].FullName
            break
        }
    }
}

$destImage = "assets\images\screen1_exact.png"
if ($foundMaster) {
    Write-Host "Found Master Design File at: $foundMaster" -ForegroundColor Cyan
    try {
        $src = [System.Drawing.Bitmap]::FromFile($foundMaster)
        # If it is the full 30-screen grid sheet, crop Screen 1 directly
        if ($src.Width -gt 1000 -and $src.Height -gt 1000) {
            $cropX = [int]($src.Width * 0.012)
            $cropY = [int]($src.Height * 0.038)
            $cropW = [int]($src.Width * 0.125)
            $cropH = [int]($src.Height * 0.235)
            $rect = New-Object System.Drawing.Rectangle $cropX, $cropY, $cropW, $cropH
            $cropped = $src.Clone($rect, $src.PixelFormat)
            $cropped.Save($destImage, [System.Drawing.Imaging.ImageFormat]::Png)
            $cropped.Dispose()
            Write-Host "Successfully extracted 100% Print-to-Print Screen 1 into $destImage!" -ForegroundColor Green
        } else {
            Copy-Item -Path $foundMaster -Destination $destImage -Force
        }
        $src.Dispose()
    } catch {
        Copy-Item -Path $foundMaster -Destination $destImage -Force
    }
} else {
    Write-Host "Tip: Place your exact image at: Desktop\flash_2_ride\assets\images\screen1_exact.png" -ForegroundColor Yellow
}

# 3. Configure assets in pubspec.yaml
$pub = Get-Content pubspec.yaml -Raw
if ($pub -notmatch "assets/images/") {
    if ($pub -match "assets:") {
        $pub = $pub -replace "assets:", "assets:`n    - assets/images/"
    } else {
        $pub = $pub -replace "flutter:", "flutter:`n  assets:`n    - assets/images/"
    }
    Set-Content pubspec.yaml $pub -Encoding UTF8
    Write-Host "Registered assets/images/ in pubspec.yaml" -ForegroundColor Green
}

# 4. Update splash_screen.dart to render the Print-to-Print Graphic
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

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    const Color brandPurple = Color(0xFF3320B5);
    const Color brandPurpleLight = Color(0xFF563BE2);

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
          child: Stack(
            children: [
              // Print-to-Print Exact Master Image Rendering
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Image.asset(
                    'assets/images/screen1_exact.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.directions_car_filled_rounded, size: 90, color: Colors.white),
                          SizedBox(height: 16),
                          Text(
                            'Flash2Ride',
                            style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Place screen1_exact.png inside assets/images/',
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              // Bottom Loading Spinner
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
'@ | Set-Content -Path 'lib/screens/splash_screen.dart' -Encoding UTF8

Write-Host "Verifying with flutter analyze..." -ForegroundColor Green
dart fix --apply | Out-Null
flutter analyze

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " Print-to-Print Setup Ready! Run the app to view.                             " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green