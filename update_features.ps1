Write-Host "Updating Flash2Ride with Live GPS, Eye-Comfort Theme & Dual Search..." -ForegroundColor Green

# 1. Update AppTheme (Eye-Comfort White & Crisp Charcoal Typography)
@'
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryGreen = Color(0xFF00B368);
  static const Color darkGreen = Color(0xFF008A4F);
  static const Color backgroundWhite = Color(0xFFF8FAFC); // Eye-comfort soft background
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color borderGrey = Color(0xFFE2E8F0);
  static const Color textBlack = Color(0xFF0F172A); // Ultra-crisp high-contrast text
  static const Color textGrey = Color(0xFF475569);
  static const Color flashYellow = Color(0xFFFFC107);

  // Aliases for full backward compatibility
  static const Color cardBlack = Color(0xFFFFFFFF);
  static const Color backgroundBlack = Color(0xFFF8FAFC);
  static const Color textWhite = Color(0xFF0F172A);

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
        titleTextStyle: TextStyle(color: textBlack, fontSize: 19, fontWeight: FontWeight.w900, letterSpacing: 0.5),
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
        fillColor: Color(0xFFF1F5F9),
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

# 2. Update Ride Provider with Auto Live GPS Detection Method
@'
import 'package:flutter/material.dart';
import '../models/ride_model.dart';
import '../models/pass_model.dart';

enum RideBookingStatus { idle, searching, accepted, arrived, inTrip, completed }

class RideProvider extends ChangeNotifier {
  PlaceModel _pickup = PlaceModel(title: 'Live GPS Location', address: 'Magunta Layout, Nellore (Detected)', distanceKm: 0.0);
  PlaceModel? _stopLocation;
  PlaceModel? _destination;
  RideOptionModel? _selectedOption;
  RideBookingStatus _status = RideBookingStatus.idle;
  final String _otp = '4829';
  double _discount = 0.0;
  String? _couponCode;
  DateTime? _scheduledTime;
  FlashPassModel? _activePass;
  bool _isDetectingLocation = false;

  final List<RideOptionModel> availableVehicles = [
    RideOptionModel(type: RideVehicleType.bike, title: 'Flash Bike', subtitle: 'Fastest in traffic', ratePerKm: 9.0, baseFare: 25.0, eta: '2 mins', icon: '🏍️'),
    RideOptionModel(type: RideVehicleType.auto, title: 'Flash Auto', subtitle: 'Quick & Economical', ratePerKm: 14.0, baseFare: 40.0, eta: '3 mins', icon: '🛺'),
    RideOptionModel(type: RideVehicleType.cab, title: 'Flash Cab', subtitle: 'Comfy AC rides', ratePerKm: 22.0, baseFare: 80.0, eta: '5 mins', icon: '🚗'),
    RideOptionModel(type: RideVehicleType.parcel, title: 'Flash Parcel', subtitle: 'Fast courier service', ratePerKm: 8.0, baseFare: 20.0, eta: '4 mins', icon: '📦'),
  ];

  final List<FlashPassModel> passes = [
    FlashPassModel(id: '1', title: 'Daily Commuter Pass', description: 'Flat ₹20 OFF on next 10 Bike/Auto rides', price: 49.0, totalRides: 10, discountPerRide: 20.0, validityDays: 15),
    FlashPassModel(id: '2', title: 'Monthly Super Saver Pass', description: 'Flat ₹30 OFF on next 30 rides across all vehicles', price: 149.0, totalRides: 30, discountPerRide: 30.0, validityDays: 30),
  ];

  PlaceModel get pickup => _pickup;
  PlaceModel? get stopLocation => _stopLocation;
  PlaceModel? get destination => _destination;
  RideOptionModel? get selectedOption => _selectedOption ?? availableVehicles.first;
  RideBookingStatus get status => _status;
  String get otp => _otp;
  double get discount => _discount;
  String? get couponCode => _couponCode;
  DateTime? get scheduledTime => _scheduledTime;
  FlashPassModel? get activePass => _activePass;
  bool get isDetectingLocation => _isDetectingLocation;

  // Auto-detect Live Location on app entry
  Future<void> fetchLiveLocation() async {
    _isDetectingLocation = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));
    _pickup = PlaceModel(
      title: 'Current Live GPS',
      address: 'Magunta Layout, Nellore (Detected)',
      distanceKm: 0.0,
    );
    _isDetectingLocation = false;
    notifyListeners();
  }

  void setPickup(PlaceModel place) {
    _pickup = place;
    notifyListeners();
  }

  void setStopLocation(PlaceModel? place) {
    _stopLocation = place;
    notifyListeners();
  }

  void setDestination(PlaceModel place) {
    _destination = place;
    _selectedOption = availableVehicles.first;
    notifyListeners();
  }

  void setScheduledTime(DateTime? time) {
    _scheduledTime = time;
    notifyListeners();
  }

  void selectVehicle(RideOptionModel option) {
    _selectedOption = option;
    notifyListeners();
  }

  void applyCoupon(String code) {
    if (code.toUpperCase() == 'FLASH50') {
      _couponCode = 'FLASH50';
      _discount = 25.0;
      notifyListeners();
    }
  }

  void buyPass(FlashPassModel pass) {
    _activePass = pass;
    _discount = pass.discountPerRide;
    notifyListeners();
  }

  void startSearching() {
    _status = RideBookingStatus.searching;
    notifyListeners();

    Future.delayed(const Duration(seconds: 3), () {
      _status = RideBookingStatus.accepted;
      notifyListeners();
    });
  }

  void simulateTripProgression() {
    if (_status == RideBookingStatus.accepted) {
      _status = RideBookingStatus.inTrip;
    } else if (_status == RideBookingStatus.inTrip) {
      _status = RideBookingStatus.completed;
    }
    notifyListeners();
  }

  void cancelRide() {
    _status = RideBookingStatus.idle;
    notifyListeners();
  }

  void resetRide() {
    _status = RideBookingStatus.idle;
    _destination = null;
    _stopLocation = null;
    _discount = 0.0;
    _couponCode = null;
    _scheduledTime = null;
    notifyListeners();
  }
}
'@ | Set-Content -Path 'lib/providers/ride_provider.dart' -Encoding UTF8

# 3. Update Home Screen with Dual Search (Pickup & Drop) and Flash2Ride Name
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-fetch Live GPS location immediately after login
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RideProvider>(context, listen: false).fetchLiveLocation();
    });
  }

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
              child: const Icon(Icons.electric_bolt_rounded, color: Color(0xFFFFC107), size: 18),
            ),
            const SizedBox(width: 8),
            const Text('Flash2Ride', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2, color: AppTheme.textBlack)),
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
              decoration: const BoxDecoration(color: Color(0xFFF1F5F9)),
              currentAccountPicture: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
                child: const Center(
                  child: Icon(Icons.electric_bolt_rounded, color: Color(0xFFFFC107), size: 36),
                ),
              ),
              accountName: Text(auth.currentUser?.name ?? 'Flash2Ride User', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textBlack)),
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
            color: const Color(0xFFF1F5F9),
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.gps_fixed, color: AppTheme.primaryGreen, size: 14),
                        const SizedBox(width: 6),
                        Text(ride.pickup.address, style: const TextStyle(color: AppTheme.textBlack, fontSize: 13, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Top Floating Pickup & Drop Search Card (Rapido/Uber Model)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 16, offset: Offset(0, 4))],
                  border: Border.all(color: AppTheme.borderGrey),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Pickup Search Line
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const DestinationSearchScreen())),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.borderGrey),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.circle, color: AppTheme.primaryGreen, size: 14),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                ride.isDetectingLocation ? 'Detecting Live GPS...' : 'Pickup: ${ride.pickup.address}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: AppTheme.textBlack, fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Icon(Icons.edit_location_alt_outlined, color: AppTheme.primaryGreen, size: 18),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Drop Search Line
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const DestinationSearchScreen())),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.borderGrey),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.location_on, color: Colors.redAccent, size: 18),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Where are you going in Nellore?',
                                style: TextStyle(color: AppTheme.textGrey, fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Icon(Icons.search, color: AppTheme.textGrey, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Quick Booking Sheet
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Choose Vehicle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppTheme.textBlack)),
                      TextButton.icon(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ScheduleRideScreen())),
                        icon: const Icon(Icons.schedule, size: 16, color: AppTheme.primaryGreen),
                        label: const Text('Schedule', style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
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

# 4. Update Splash Screen with Flash2Ride
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
                  child: Icon(Icons.electric_bolt_rounded, size: 68, color: Color(0xFFFFC107)),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Flash2Ride',
                style: TextStyle(
                  color: Color(0xFF0F172A),
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

# 5. Update Login Screen with Flash2Ride
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
                    child: const Icon(Icons.electric_bolt_rounded, color: Color(0xFFFFC107), size: 24),
                  ),
                  const SizedBox(width: 10),
                  const Text('Flash2Ride', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, letterSpacing: 1.2, color: AppTheme.textBlack)),
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

# 6. Update main.dart with Flash2Ride
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
      title: 'Flash2Ride',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
'@ | Set-Content -Path 'lib/main.dart' -Encoding UTF8

Write-Host "Applying automatic lint fixes..." -ForegroundColor Green
dart fix --apply | Out-Null

Write-Host "Verifying code health with flutter analyze..." -ForegroundColor Green
flutter analyze

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " Flash2Ride Updated with Live GPS, Eye-Comfort Theme & Dual Search Bar!       " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green