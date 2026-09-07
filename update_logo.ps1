Write-Host "Updating Official Logo and FlashtoRide Branding..." -ForegroundColor Green

# 1. Update AppTheme with Full Compatibility & Flash Yellow
@'
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryGreen = Color(0xFF00B368);
  static const Color darkGreen = Color(0xFF008A4F);
  static const Color backgroundWhite = Color(0xFFF9FAFB);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color borderGrey = Color(0xFFE5E7EB);
  static const Color textBlack = Color(0xFF111827);
  static const Color textGrey = Color(0xFF6B7280);
  static const Color flashYellow = Color(0xFFFFD700);

  // Aliases for White theme
  static const Color cardBlack = Color(0xFFFFFFFF);
  static const Color backgroundBlack = Color(0xFFF9FAFB);
  static const Color textWhite = Color(0xFF111827);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundWhite,
      primaryColor: primaryGreen,
      colorScheme: const ColorScheme.light(
        primary: primaryGreen,
        secondary: primaryGreen,
        surface: cardWhite,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: cardWhite,
        elevation: 0.5,
        centerTitle: true,
        iconTheme: IconThemeData(color: primaryGreen),
        titleTextStyle: TextStyle(color: textBlack, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 1,
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFFF3F4F6),
        hintStyle: TextStyle(color: textGrey, fontSize: 14),
        prefixIconColor: primaryGreen,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(14)), borderSide: BorderSide(color: borderGrey)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(14)), borderSide: BorderSide(color: borderGrey)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(14)), borderSide: BorderSide(color: primaryGreen, width: 1.5)),
      ),
    );
  }
}
'@ | Set-Content -Path 'lib/theme/app_theme.dart' -Encoding UTF8

# 2. Update Splash Screen with Official Circular Black Badge + Yellow Flash + FlashtoRide Name
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

    Timer(const Duration(seconds: 2), () {
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Official App Logo: Circular Black with Vibrant Yellow Flash
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 25,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.electric_bolt_rounded,
                    size: 68,
                    color: Color(0xFFFFD700), // Yellow Flash Symbol
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'FlashtoRide',
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Instant • Affordable • Safe',
                style: TextStyle(
                  color: Color(0xFF00B368),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
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

# 3. Update Home Screen with Circular Black Badge + Yellow Bolt and FlashtoRide Title
@'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/ride_provider.dart';
import '../booking/destination_search_screen.dart';
import '../booking/schedule_ride_screen.dart';
import '../booking/rental_packages_screen.dart';
import '../booking/parcel_booking_screen.dart';
import '../booking/qr_scan_screen.dart';
import '../features/power_pass_screen.dart';
import '../features/refer_earn_screen.dart';
import '../features/safety_toolkit_screen.dart';
import '../features/support_screen.dart';
import '../features/language_screen.dart';
import '../features/wallet_screen.dart';
import '../features/ride_history_screen.dart';
import '../features/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final ride = Provider.of<RideProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
              child: const Icon(Icons.electric_bolt_rounded, color: Color(0xFFFFD700), size: 18),
            ),
            const SizedBox(width: 8),
            const Text('FlashtoRide', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2, color: AppTheme.textBlack)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_rounded, color: AppTheme.primaryGreen),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const QrScanScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.account_balance_wallet_rounded, color: AppTheme.primaryGreen),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const WalletScreen())),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFFF3F4F6)),
              currentAccountPicture: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
                child: const Center(
                  child: Icon(Icons.electric_bolt_rounded, color: Color(0xFFFFD700), size: 36),
                ),
              ),
              accountName: Text(auth.currentUser?.name ?? 'FlashtoRide User', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textBlack)),
              accountEmail: Text('+91 ${auth.currentUser?.phone ?? "9876543210"}', style: const TextStyle(color: AppTheme.textGrey)),
            ),
            ListTile(
              leading: const Icon(Icons.history_rounded, color: AppTheme.primaryGreen),
              title: const Text('My Rides & Invoices', style: TextStyle(color: AppTheme.textBlack, fontWeight: FontWeight.w600)),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const RideHistoryScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.card_membership_rounded, color: Colors.amber),
              title: const Text('Flash Power Pass (Save 30%)', style: TextStyle(color: AppTheme.textBlack, fontWeight: FontWeight.w600)),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const PowerPassScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.card_giftcard_rounded, color: AppTheme.primaryGreen),
              title: const Text('Refer & Earn ₹50', style: TextStyle(color: AppTheme.textBlack, fontWeight: FontWeight.w600)),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ReferEarnScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.shield_rounded, color: Colors.redAccent),
              title: const Text('Safety Toolkit & SOS', style: TextStyle(color: AppTheme.textBlack, fontWeight: FontWeight.w600)),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const SafetyToolkitScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.headset_mic_rounded, color: AppTheme.primaryGreen),
              title: const Text('24/7 Help & Support', style: TextStyle(color: AppTheme.textBlack, fontWeight: FontWeight.w600)),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const SupportScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.language_rounded, color: AppTheme.primaryGreen),
              title: const Text('Language (భాష)', style: TextStyle(color: AppTheme.textBlack, fontWeight: FontWeight.w600)),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const LanguageScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.person_rounded, color: AppTheme.primaryGreen),
              title: const Text('Profile Settings', style: TextStyle(color: AppTheme.textBlack, fontWeight: FontWeight.w600)),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ProfileScreen())),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: const Color(0xFFF3F4F6),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primaryGreen.withValues(alpha: 0.15),
                      border: Border.all(color: AppTheme.primaryGreen, width: 2),
                    ),
                    child: const Icon(Icons.my_location, color: AppTheme.primaryGreen, size: 32),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 2))],
                      border: Border.all(color: AppTheme.borderGrey),
                    ),
                    child: Text(ride.pickup.address, style: const TextStyle(color: AppTheme.textBlack, fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: ActionChip(
                      backgroundColor: Colors.white,
                      elevation: 1,
                      side: const BorderSide(color: AppTheme.borderGrey),
                      avatar: const Icon(Icons.schedule, color: AppTheme.primaryGreen, size: 18),
                      label: const Text('Schedule', style: TextStyle(color: AppTheme.textBlack, fontSize: 12, fontWeight: FontWeight.bold)),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ScheduleRideScreen())),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ActionChip(
                      backgroundColor: Colors.white,
                      elevation: 1,
                      side: const BorderSide(color: AppTheme.borderGrey),
                      avatar: const Icon(Icons.access_time_rounded, color: AppTheme.primaryGreen, size: 18),
                      label: const Text('Rentals', style: TextStyle(color: AppTheme.textBlack, fontSize: 12, fontWeight: FontWeight.bold)),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const RentalPackagesScreen())),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ActionChip(
                      backgroundColor: Colors.white,
                      elevation: 1,
                      side: const BorderSide(color: AppTheme.borderGrey),
                      avatar: const Icon(Icons.inventory_2_outlined, color: AppTheme.primaryGreen, size: 18),
                      label: const Text('Parcel', style: TextStyle(color: AppTheme.textBlack, fontSize: 12, fontWeight: FontWeight.bold)),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ParcelBookingScreen())),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -4))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const DestinationSearchScreen())),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.borderGrey),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.search_rounded, color: AppTheme.primaryGreen, size: 24),
                          SizedBox(width: 12),
                          Text('Where are you going in Nellore?', style: TextStyle(color: AppTheme.textGrey, fontSize: 15, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Available Rides', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textBlack)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ride.availableVehicles.map((v) {
                      return GestureDetector(
                        onTap: () {
                          ride.selectVehicle(v);
                          Navigator.push(context, MaterialPageRoute(builder: (c) => const DestinationSearchScreen()));
                        },
                        child: Container(
                          width: 78,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
                            border: Border.all(color: AppTheme.borderGrey),
                          ),
                          child: Column(
                            children: [
                              Text(v.icon, style: const TextStyle(fontSize: 28)),
                              const SizedBox(height: 6),
                              Text(v.title.replaceFirst('Flash ', ''), style: const TextStyle(color: AppTheme.textBlack, fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
'@ | Set-Content -Path 'lib/screens/home/home_screen.dart' -Encoding UTF8

# 4. Update Login Screen with FlashtoRide Logo
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

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  void _submitPhone() {
    if (_phoneController.text.trim().length == 10) {
      Provider.of<AuthProvider>(context, listen: false).sendOtp(_phoneController.text.trim());
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OtpScreen(phoneNumber: _phoneController.text.trim())),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 10-digit mobile number')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: const Icon(Icons.electric_bolt_rounded, color: Color(0xFFFFD700), size: 24),
                  ),
                  const SizedBox(width: 10),
                  const Text('FlashtoRide', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, letterSpacing: 1.2, color: AppTheme.textBlack)),
                ],
              ),
              const SizedBox(height: 36),
              const Text('Enter Mobile Number', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.textBlack)),
              const SizedBox(height: 8),
              const Text('Get started with instant, safe city rides in Nellore', style: TextStyle(color: AppTheme.textGrey, fontSize: 14)),
              const SizedBox(height: 30),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2, color: AppTheme.textBlack),
                decoration: const InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    child: Text('+91', style: TextStyle(color: AppTheme.primaryGreen, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  hintText: '9876543210',
                  counterText: '',
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitPhone,
                  child: const Text('Get OTP', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
'@ | Set-Content -Path 'lib/screens/auth/login_screen.dart' -Encoding UTF8

# 5. Update main.dart Title
@'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/ride_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RideProvider()),
      ],
      child: const Flash2RideApp(),
    ),
  );
}

class Flash2RideApp extends StatelessWidget {
  const Flash2RideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlashtoRide',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
'@ | Set-Content -Path 'lib/main.dart' -Encoding UTF8

Write-Host "Applying automatic lint fixes..." -ForegroundColor Green
dart fix --apply | Out-Null

Write-Host "Verifying with flutter analyze..." -ForegroundColor Green
flutter analyze

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " Official FlashtoRide Branding & Logo Successfully Updated!                   " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green