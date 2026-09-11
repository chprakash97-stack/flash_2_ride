Write-Host "Locating ChatGPT Clean Image and Linking to Screen 1..." -ForegroundColor Green

$projectDir = "C:\Users\DELL\Desktop\flash_2_ride"
Set-Location $projectDir

$assetsDir = Join-Path $projectDir "assets\images"
$webDir = Join-Path $projectDir "web"
if (!(Test-Path $assetsDir)) { New-Item -ItemType Directory -Path $assetsDir -Force | Out-Null }
if (!(Test-Path $webDir)) { New-Item -ItemType Directory -Path $webDir -Force | Out-Null }

$destAsset = Join-Path $assetsDir "splash.png"
$destWeb = Join-Path $webDir "splash.png"

# 1. Search for the ChatGPT Image across Downloads, Desktop, Project, Pictures
$searchDirs = @(
    "$env:USERPROFILE\Downloads",
    "$env:USERPROFILE\Desktop",
    $projectDir,
    "$env:USERPROFILE\Pictures"
)

$foundImage = $null
foreach ($dir in $searchDirs) {
    if (Test-Path $dir) {
        $candidate = Get-ChildItem -Path $dir -Filter "*ChatGPT*" -File -ErrorAction SilentlyContinue | 
                     Sort-Object LastWriteTime -Descending | 
                     Select-Object -First 1
        if ($candidate) {
            $foundImage = $candidate.FullName
            break
        }
    }
}

if ($foundImage) {
    Write-Host "SUCCESS! Found your ChatGPT Image at:" -ForegroundColor Green
    Write-Host $foundImage -ForegroundColor Cyan
    Copy-Item -Path $foundImage -Destination $destAsset -Force
    Copy-Item -Path $foundImage -Destination $destWeb -Force
    Write-Host "Successfully linked image to assets and web!" -ForegroundColor Green
} else {
    Write-Host "Could not auto-find file. Opening selector to click your ChatGPT image..." -ForegroundColor Yellow
    Add-Type -AssemblyName System.Windows.Forms
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.InitialDirectory = "$env:USERPROFILE\Downloads"
    $dialog.Filter = "Image Files (*.png;*.webp;*.jpg;*.jpeg)|*.png;*.webp;*.jpg;*.jpeg"
    $dialog.Title = "Select ChatGPT Image"
    $form = New-Object System.Windows.Forms.Form
    $form.TopMost = $true
    if ($dialog.ShowDialog($form) -eq [System.Windows.Forms.DialogResult]::OK) {
        Copy-Item -Path $dialog.FileName -Destination $destAsset -Force
        Copy-Item -Path $dialog.FileName -Destination $destWeb -Force
        Write-Host "Image linked successfully from selection!" -ForegroundColor Green
    }
}

# 2. Update Splash Screen Code to display this clean image perfectly
@'
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
  }

  @override
  void dispose() {
    _progressController.dispose();
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
              const SizedBox(height: 10),

              // Clean ChatGPT Image Display
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/images/splash.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                        'splash.png',
                        fit: BoxFit.contain,
                        errorBuilder: (c, e, s) => const Center(
                          child: Text(
                            'Flash2Ride',
                            style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Native Live Animated Loading Bar at bottom
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Loading...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 240,
                    height: 5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: AnimatedBuilder(
                        animation: _progressController,
                        builder: (context, child) {
                          return LinearProgressIndicator(
                            value: _progressController.value,
                            backgroundColor: Colors.white.withValues(alpha: 0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(brandYellow),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}
'@ | Set-Content -Path (Join-Path $projectDir 'lib\screens\splash_screen.dart') -Encoding UTF8

flutter pub get
flutter analyze

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " Clean ChatGPT Image Linked! Press 'R' in terminal or Ctrl+R in Chrome!        " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green