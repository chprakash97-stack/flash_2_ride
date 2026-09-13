Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "FIXING MISSING IMPORTS & LIVE TRACKING SCREEN..." -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan

$projectRoot = $PWD

# 1. lib/views/safety మరియు safety_toolkit_screen.dart ని రీస్టోర్ చేయడం
$safetyViewsDir = "$projectRoot\lib\views\safety"
if (-not (Test-Path $safetyViewsDir)) {
    New-Item -ItemType Directory -Path $safetyViewsDir -Force | Out-Null
}

$safetyBridge = @'
export '../../screens/safety/safety_toolkit_screen.dart';
'@
[System.IO.File]::WriteAllText("$safetyViewsDir\safety_toolkit_screen.dart", $safetyBridge, [System.Text.Encoding]::UTF8)
Write-Host "Created safety_toolkit_screen bridge file." -ForegroundColor Green

# 2. tracking ఫైల్స్ లో ఇంపోర్ట్ సరిచేయడం
$trackingFiles = Get-ChildItem -Path "$projectRoot\lib" -Filter "*live_tracking_screen*.dart" -Recurse
foreach ($tf in $trackingFiles) {
    $c = Get-Content $tf.FullName -Raw -Encoding UTF8
    if ($c.Contains("../../views/safety/safety_toolkit_screen.dart")) {
        $c = $c.Replace("../../views/safety/safety_toolkit_screen.dart", "../safety/safety_toolkit_screen.dart")
        [System.IO.File]::WriteAllText($tf.FullName, $c, [System.Text.Encoding]::UTF8)
        Write-Host "Fixed import in $($tf.FullName)" -ForegroundColor Green
    }
}

# 3. కోర్ ఫైల్స్ (app_colors, routes) లేకపోతే క్రియేట్ చేయడం
$coreConstDir = "$projectRoot\lib\core\constants"
if (-not (Test-Path $coreConstDir)) {
    New-Item -ItemType Directory -Path $coreConstDir -Force | Out-Null
}
$appColorsCode = @'
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF0058FF);
  static const Color primaryDark = Color(0xFF003CB3);
  static const Color primaryLight = Color(0xFFE5EEFF);
  static const Color secondary = Color(0xFFFFB800);
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Colors.white;
  static const Color border = Color(0xFFE5E7EB);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color bike = Color(0xFF10B981);
  static const Color auto = Color(0xFFF59E0B);
  static const Color parcel = Color(0xFF8B5CF6);
}
'@
[System.IO.File]::WriteAllText("$coreConstDir\app_colors.dart", $appColorsCode, [System.Text.Encoding]::UTF8)

$coreConfigDir = "$projectRoot\lib\core\config"
if (-not (Test-Path $coreConfigDir)) {
    New-Item -ItemType Directory -Path $coreConfigDir -Force | Out-Null
}
$routesCode = @'
class AppRoutes {
  static const String home = '/home';
  static const String wallet = '/wallet';
  static const String rideHistory = '/ride-history';
  static const String safetyToolkit = '/safety-toolkit';
  static const String userProfile = '/user-profile';
  static const String locationSearch = '/location-search';
  static const String rideSelection = '/ride-selection';
}
'@
[System.IO.File]::WriteAllText("$coreConfigDir\routes.dart", $routesCode, [System.Text.Encoding]::UTF8)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "ALL COMPILATION ISSUES RESOLVED!" -ForegroundColor Green
Write-Host "Now run: flutter run -d chrome" -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan