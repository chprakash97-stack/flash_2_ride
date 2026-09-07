Write-Host "Updating Flash 2 Ride to Official Uber/Rapido White Theme..." -ForegroundColor Green

# 1. Update AppTheme (Official White & Flash Green Theme)
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
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFFF3F4F6),
        hintStyle: const TextStyle(color: textGrey, fontSize: 14),
        prefixIconColor: primaryGreen,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: borderGrey)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: borderGrey)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: primaryGreen, width: 1.5)),
      ),
    );
  }
}
'@ | Set-Content -Path 'lib/theme/app_theme.dart' -Encoding UTF8

# 2. Update Splash Screen
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
              Container(
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: AppTheme.primaryGreen, width: 3),
                  boxShadow: [
                    BoxShadow(color: AppTheme.primaryGreen.withValues(alpha: 0.25), blurRadius: 40, spreadRadius: 8),
                  ],
                ),
                child: const Icon(Icons.electric_bolt_rounded, size: 75, color: AppTheme.primaryGreen),
              ),
              const SizedBox(height: 24),
              const Text(
                'FLASH 2 RIDE',
                style: TextStyle(color: AppTheme.textBlack, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 3),
              ),
              const SizedBox(height: 8),
              const Text(
                'Instant • Affordable • Safe',
                style: TextStyle(color: AppTheme.primaryGreen, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
'@ | Set-Content -Path 'lib/screens/splash_screen.dart' -Encoding UTF8

# 3. Update Login Screen
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
                children: const [
                  Icon(Icons.electric_bolt_rounded, color: AppTheme.primaryGreen, size: 36),
                  SizedBox(width: 8),
                  Text('FLASH 2 RIDE', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, letterSpacing: 1, color: AppTheme.textBlack)),
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

# 4. Update OTP Screen
@'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../home/home_screen.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();

  void _verify() {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = auth.verifyOtp(_otpController.text.trim(), widget.phoneNumber);
    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid OTP! Enter 123456')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Verification')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter 6-Digit OTP', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textBlack)),
            const SizedBox(height: 8),
            Text('Sent to +91 ${widget.phoneNumber} (Test Code: 123456)', style: const TextStyle(color: AppTheme.primaryGreen, fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 30),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 10, color: AppTheme.textBlack),
              decoration: const InputDecoration(hintText: '------', counterText: ''),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _verify,
                child: const Text('Verify & Proceed', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
'@ | Set-Content -Path 'lib/screens/auth/otp_screen.dart' -Encoding UTF8

# 5. Update Home Screen (Crisp White Uber/Rapido Aesthetic)
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
          children: const [
            Icon(Icons.electric_bolt_rounded, color: AppTheme.primaryGreen),
            SizedBox(width: 6),
            Text('FLASH 2 RIDE', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, color: AppTheme.textBlack)),
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
              currentAccountPicture: CircleAvatar(
                backgroundColor: AppTheme.primaryGreen,
                child: Text(auth.currentUser?.name.substring(0, 1) ?? 'P', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              accountName: Text(auth.currentUser?.name ?? 'Flash User', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textBlack)),
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
          // Crisp Light Map Canvas
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

# 6. Update Destination Search Screen
@'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../models/ride_model.dart';
import '../../providers/ride_provider.dart';
import 'ride_selection_screen.dart';

class DestinationSearchScreen extends StatefulWidget {
  const DestinationSearchScreen({super.key});

  @override
  State<DestinationSearchScreen> createState() => _DestinationSearchScreenState();
}

class _DestinationSearchScreenState extends State<DestinationSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _stopController = TextEditingController();
  bool _hasViaStop = false;

  final List<PlaceModel> popularPlaces = [
    PlaceModel(title: 'Nellore RTC Main Bus Stand', address: 'Grand Trunk Road, Nellore', distanceKm: 4.2),
    PlaceModel(title: 'Nellore Railway Station', address: 'Railway Feeder Rd, Nellore', distanceKm: 5.8),
    PlaceModel(title: 'VRC Centre Circle', address: 'VRC Circle, Trunk Road, Nellore', distanceKm: 3.1),
    PlaceModel(title: 'Magunta Layout Park', address: 'Magunta Layout, Nellore', distanceKm: 1.5),
    PlaceModel(title: 'Current Office Substation', address: 'Dargamitta, Nellore', distanceKm: 2.8),
    PlaceModel(title: 'MGB Felicity Mall', address: 'Grand Trunk Road, Nellore', distanceKm: 4.9),
  ];

  @override
  Widget build(BuildContext context) {
    final ride = Provider.of<RideProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Set Destination'),
        actions: [
          IconButton(
            tooltip: 'Add Stop',
            icon: Icon(_hasViaStop ? Icons.remove_circle_outline : Icons.add_location_alt_outlined, color: AppTheme.primaryGreen),
            onPressed: () => setState(() => _hasViaStop = !_hasViaStop),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  readOnly: true,
                  style: const TextStyle(color: AppTheme.textBlack, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.my_location, color: AppTheme.primaryGreen),
                    hintText: ride.pickup.address,
                    filled: true,
                    fillColor: const Color(0xFFF3F4F6),
                  ),
                ),
                if (_hasViaStop) ...[
                  const SizedBox(height: 10),
                  TextField(
                    controller: _stopController,
                    style: const TextStyle(color: AppTheme.textBlack),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.add_circle_outline, color: Colors.amber),
                      hintText: 'Add Stop (Via location in Nellore)...',
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: const TextStyle(color: AppTheme.textBlack),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.location_on, color: Colors.redAccent),
                    hintText: 'Enter drop destination...',
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.borderGrey),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(alignment: Alignment.centerLeft, child: Text('Suggested Places in Nellore', style: TextStyle(color: AppTheme.textGrey, fontWeight: FontWeight.bold))),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: popularPlaces.length,
              itemBuilder: (context, index) {
                final place = popularPlaces[index];
                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.place_rounded, color: AppTheme.primaryGreen),
                  ),
                  title: Text(place.title, style: const TextStyle(color: AppTheme.textBlack, fontWeight: FontWeight.bold)),
                  subtitle: Text('${place.address} • ${place.distanceKm} km', style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)),
                  onTap: () {
                    ride.setDestination(place);
                    if (_hasViaStop && _stopController.text.isNotEmpty) {
                      ride.setStopLocation(PlaceModel(title: _stopController.text, address: 'Via Stop', distanceKm: 2.0));
                    }
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (c) => const RideSelectionScreen()),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
'@ | Set-Content -Path 'lib/screens/booking/destination_search_screen.dart' -Encoding UTF8

# 7. Update Ride Selection Screen (Uber/Rapido Card Aesthetic)
@'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/ride_provider.dart';
import '../tracking/searching_captain_screen.dart';

class RideSelectionScreen extends StatelessWidget {
  const RideSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = Provider.of<RideProvider>(context);
    final distance = ride.destination?.distanceKm ?? 4.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(title: const Text('Confirm Ride')),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
              border: Border.all(color: AppTheme.borderGrey),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.circle, color: AppTheme.primaryGreen, size: 14),
                    const SizedBox(width: 12),
                    Expanded(child: Text(ride.pickup.address, style: const TextStyle(color: AppTheme.textBlack, fontSize: 13, fontWeight: FontWeight.w600))),
                  ],
                ),
                if (ride.stopLocation != null) ...[
                  const Divider(color: AppTheme.borderGrey, height: 16),
                  Row(
                    children: [
                      const Icon(Icons.stop_circle, color: Colors.amber, size: 14),
                      const SizedBox(width: 12),
                      Expanded(child: Text('Stop: ${ride.stopLocation!.title}', style: const TextStyle(color: AppTheme.textGrey, fontSize: 13))),
                    ],
                  ),
                ],
                const Divider(color: AppTheme.borderGrey, height: 16),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.redAccent, size: 16),
                    const SizedBox(width: 12),
                    Expanded(child: Text(ride.destination?.title ?? 'Destination', style: const TextStyle(color: AppTheme.textBlack, fontWeight: FontWeight.bold, fontSize: 14))),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: ride.availableVehicles.length,
              itemBuilder: (context, index) {
                final v = ride.availableVehicles[index];
                final fare = (v.calculateFare(distance) - ride.discount).clamp(20.0, 9999.0);
                final isSelected = v.type == ride.selectedOption?.type;

                return GestureDetector(
                  onTap: () => ride.selectVehicle(v),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryGreen.withValues(alpha: 0.08) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1))],
                      border: Border.all(color: isSelected ? AppTheme.primaryGreen : AppTheme.borderGrey, width: isSelected ? 2 : 1),
                    ),
                    child: Row(
                      children: [
                        Text(v.icon, style: const TextStyle(fontSize: 34)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(v.title, style: const TextStyle(color: AppTheme.textBlack, fontWeight: FontWeight.bold, fontSize: 16)),
                                  const SizedBox(width: 8),
                                  if (v.type.name == 'bike')
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(color: AppTheme.primaryGreen.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                                      child: const Text('FASTEST', style: TextStyle(color: AppTheme.primaryGreen, fontSize: 10, fontWeight: FontWeight.bold)),
                                    ),
                                ],
                              ),
                              Text('${v.subtitle} • ETA ${v.eta}', style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)),
                            ],
                          ),
                        ),
                        Text('₹${fare.toStringAsFixed(0)}', style: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.w900, fontSize: 20)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 16, offset: Offset(0, -3))],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.payment, color: AppTheme.primaryGreen, size: 20),
                        SizedBox(width: 8),
                        Text('Payment: Flash Wallet / Cash', style: TextStyle(color: AppTheme.textBlack, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => ride.applyCoupon('FLASH50'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: AppTheme.primaryGreen.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                        child: Text(ride.couponCode != null ? 'FLASH50 Applied' : 'Apply Coupon', style: const TextStyle(color: AppTheme.primaryGreen, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ride.startSearching();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (c) => const SearchingCaptainScreen()),
                      );
                    },
                    child: Text('Book ${ride.selectedOption?.title ?? "Ride"}', style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
'@ | Set-Content -Path 'lib/screens/booking/ride_selection_screen.dart' -Encoding UTF8

# 8. Update Live Tracking Screen (Clean White Card & Green OTP)
@'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/ride_provider.dart';
import '../home/home_screen.dart';

class LiveTrackingScreen extends StatelessWidget {
  const LiveTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = Provider.of<RideProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Flash Captain En Route'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_location_rounded, color: AppTheme.primaryGreen),
            tooltip: 'Share Trip',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Live Trip Link Copied! Share on WhatsApp.')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.shield_rounded, color: Colors.redAccent),
            onPressed: () {
              showDialog(
                context: context,
                builder: (c) => AlertDialog(
                  backgroundColor: Colors.white,
                  title: const Text('🚨 Emergency SOS Triggered', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                  content: const Text('Alert with Live GPS coordinates dispatched to Police Control & Emergency Contacts.', style: TextStyle(color: AppTheme.textBlack)),
                  actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('Dismiss', style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)))],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xFFEEF2F6),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.navigation_rounded, color: AppTheme.primaryGreen, size: 60),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
                        border: Border.all(color: AppTheme.primaryGreen),
                      ),
                      child: Text(
                        ride.status == RideBookingStatus.inTrip ? 'On the way to Destination' : 'Captain arriving in 2 mins',
                        style: const TextStyle(color: AppTheme.textBlack, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 18, offset: Offset(0, -4))],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.primaryGreen),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Start Ride PIN / OTP', style: TextStyle(color: AppTheme.textBlack, fontWeight: FontWeight.bold)),
                      Text(ride.otp, style: const TextStyle(color: AppTheme.primaryGreen, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 4)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: AppTheme.primaryGreen,
                      child: Icon(Icons.person, color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('K. Ramesh (Captain)', style: TextStyle(color: AppTheme.textBlack, fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('⭐ 4.9 • Hero Splendor • AP 26 AX 4589', style: TextStyle(color: AppTheme.textGrey, fontSize: 12)),
                        ],
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.call, color: AppTheme.primaryGreen), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.chat_bubble_outline, color: AppTheme.primaryGreen), onPressed: () {}),
                  ],
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (ride.status == RideBookingStatus.accepted) {
                        ride.simulateTripProgression();
                      } else {
                        ride.resetRide();
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text('🎉 Trip Completed!', style: TextStyle(color: AppTheme.textBlack, fontWeight: FontWeight.bold)),
                            content: const Text('Total Fare: ₹65 Paid via Flash Wallet.\nThank you for riding with Flash 2 Ride!', style: TextStyle(color: AppTheme.textGrey)),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) => const HomeScreen()), (r) => false);
                                },
                                child: const Text('Done', style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: Text(ride.status == RideBookingStatus.accepted ? 'Start Ride (Verify OTP)' : 'Complete Trip & Pay', style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
'@ | Set-Content -Path 'lib/screens/tracking/live_tracking_screen.dart' -Encoding UTF8

# 9. Update main.dart (Set Light Theme as Default)
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
      title: 'Flash 2 Ride',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
'@ | Set-Content -Path 'lib/main.dart' -Encoding UTF8

Write-Host "Re-analyzing with flutter analyze..." -ForegroundColor Green
flutter analyze
Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " Flash 2 Ride Successfully Updated to Official White Theme!                   " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green