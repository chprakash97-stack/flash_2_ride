Write-Host "Cleaning Project & Starting Fresh from Screen 1 (Splash)..." -ForegroundColor Green

$projectDir = "C:\Users\DELL\Desktop\flash_2_ride"
Set-Location $projectDir

# 1. Official Brand Theme (#0645D8, #062B9C, #FFD21C, #FFFFFF)
@'
import 'package:flutter/material.dart';

class AppTheme {
  static const Color mainBlue = Color(0xFF0645D8);
  static const Color darkBlue = Color(0xFF062B9C);
  static const Color brightBlue = Color(0xFF0878F9);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color brandYellow = Color(0xFFFFD21C);

  static const Color backgroundLight = Color(0xFFF8F9FE);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color borderGrey = Color(0xFFE2E8F0);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textGrey = Color(0xFF64748B);

  static const Color brandPurple = mainBlue;
  static const Color brandPurpleLight = brightBlue;
  static const Color primaryGreen = mainBlue;
  static const Color cardBlack = cardWhite;
  static const Color backgroundBlack = backgroundLight;
  static const Color textWhite = textDark;
  static const Color textBlack = textDark;

  static ThemeData get lightTheme => masterTheme;

  static ThemeData get masterTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundLight,
      primaryColor: mainBlue,
      colorScheme: const ColorScheme.light(
        primary: mainBlue,
        secondary: brandYellow,
        surface: cardWhite,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: cardWhite,
        elevation: 0.5,
        centerTitle: true,
        iconTheme: IconThemeData(color: mainBlue),
        titleTextStyle: TextStyle(color: textDark, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
    );
  }
}
'@ | Set-Content -Path (Join-Path $projectDir 'lib\theme\app_theme.dart') -Encoding UTF8

# 2. Fresh & Clean Screen 1 (Splash Screen) - Mobile Responsive & No Cut-offs
@'
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.mainBlue,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        child: SizedBox.expand(
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(36), // Smoothly rounds off any black corner artifact
              child: Image.asset(
                'assets/images/splash.png',
                fit: BoxFit.fitWidth,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Image.network(
                    'splash.png',
                    fit: BoxFit.fitWidth,
                    width: double.infinity,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
'@ | Set-Content -Path (Join-Path $projectDir 'lib\screens\splash_screen.dart') -Encoding UTF8

# 3. Clean Root main.dart pointing to SplashScreen
@'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/ride_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Flash2RideApp());
}

class Flash2RideApp extends StatelessWidget {
  const Flash2RideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RideProvider()),
      ],
      child: MaterialApp(
        title: 'Flash2Ride',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
'@ | Set-Content -Path (Join-Path $projectDir 'lib\main.dart') -Encoding UTF8

Write-Host "Running flutter pub get & analyze..." -ForegroundColor Green
flutter pub get
flutter analyze

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " Fresh Clean Start Ready! Run 'flutter run -d chrome' to view Screen 1!       " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green