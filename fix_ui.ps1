Write-Host "Upgrading Flash2Ride to Real Vector Icons, Interactive Pickup/Drop & Live Map..." -ForegroundColor Green

# 1. Update Models (Use Flutter IconData instead of fragile emojis)
@'
import 'package:flutter/material.dart';

enum RideVehicleType { bike, auto, cab, parcel }

class RideOptionModel {
  final RideVehicleType type;
  final String title;
  final String subtitle;
  final double ratePerKm;
  final double baseFare;
  final String eta;
  final IconData icon;
  final Color iconColor;

  RideOptionModel({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.ratePerKm,
    required this.baseFare,
    required this.eta,
    required this.icon,
    required this.iconColor,
  });

  double calculateFare(double distanceKm) {
    return baseFare + (ratePerKm * distanceKm);
  }
}

class PlaceModel {
  final String title;
  final String address;
  final double distanceKm;

  PlaceModel({required this.title, required this.address, required this.distanceKm});
}

class RentalPackageModel {
  final String id;
  final String duration;
  final String distance;
  final double bikeFare;
  final double autoFare;
  final double cabFare;

  RentalPackageModel({
    required this.id,
    required this.duration,
    required this.distance,
    required this.bikeFare,
    required this.autoFare,
    required this.cabFare,
  });
}
'@ | Set-Content -Path 'lib/models/ride_model.dart' -Encoding UTF8

# 2. Update Ride Provider with Native Icons & Manual Location Setters
@'
import 'package:flutter/material.dart';
import '../models/ride_model.dart';
import '../models/pass_model.dart';

enum RideBookingStatus { idle, searching, accepted, arrived, inTrip, completed }

class RideProvider extends ChangeNotifier {
  PlaceModel _pickup = PlaceModel(title: 'Magunta Layout', address: 'Magunta Layout, Nellore (Current GPS)', distanceKm: 0.0);
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
    RideOptionModel(type: RideVehicleType.bike, title: 'Flash Bike', subtitle: 'Fastest in traffic', ratePerKm: 9.0, baseFare: 25.0, eta: '2 mins', icon: Icons.two_wheeler_rounded, iconColor: Color(0xFF00B368)),
    RideOptionModel(type: RideVehicleType.auto, title: 'Flash Auto', subtitle: 'Comfortable & quick', ratePerKm: 14.0, baseFare: 40.0, eta: '3 mins', icon: Icons.electric_rickshaw_rounded, iconColor: Color(0xFFF59E0B)),
    RideOptionModel(type: RideVehicleType.cab, title: 'Flash Cab', subtitle: 'Affordable AC rides', ratePerKm: 22.0, baseFare: 80.0, eta: '5 mins', icon: Icons.directions_car_rounded, iconColor: Color(0xFF2563EB)),
    RideOptionModel(type: RideVehicleType.parcel, title: 'Flash Parcel', subtitle: 'Courier in 45 mins', ratePerKm: 8.0, baseFare: 20.0, eta: '4 mins', icon: Icons.inventory_2_rounded, iconColor: Color(0xFFEA580C)),
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

  Future<void> fetchLiveLocation() async {
    _isDetectingLocation = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));
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

  void setPickupManual(String text) {
    _pickup = PlaceModel(title: text, address: text, distanceKm: 0.0);
    notifyListeners();
  }

  void setDestination(PlaceModel place) {
    _destination = place;
    _selectedOption = availableVehicles.first;
    notifyListeners();
  }

  void setDestinationManual(String text) {
    _destination = PlaceModel(title: text, address: text, distanceKm: 4.5);
    _selectedOption = availableVehicles.first;
    notifyListeners();
  }

  void setStopLocation(PlaceModel? place) {
    _stopLocation = place;
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

# 3. Update Home Screen: Real Interactive Dual Search, Simulated Street Map, & Live Ride Cards
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
import '../tracking/searching_captain_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final ride = Provider.of<RideProvider>(context, listen: false);
    _pickupController.text = ride.pickup.address;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ride.fetchLiveLocation().then((_) {
        if (mounted) {
          _pickupController.text = ride.pickup.address;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final ride = Provider.of<RideProvider>(context);
    final distance = ride.destination?.distanceKm ?? 4.0;

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
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
                child: const Center(child: Icon(Icons.electric_bolt_rounded, color: Color(0xFFFFC107), size: 36)),
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
          // Simulated Interactive Street Map
          Positioned.fill(
            child: Container(
              color: const Color(0xFFE2E8F0),
              child: Stack(
                children: [
                  // Simulated Road Lines
                  Positioned(left: 0, right: 0, top: 220, child: Container(height: 18, color: Colors.white)),
                  Positioned(left: 0, right: 0, top: 380, child: Container(height: 24, color: Colors.white)),
                  Positioned(top: 0, bottom: 0, left: 140, child: Container(width: 20, color: Colors.white)),
                  Positioned(top: 0, bottom: 0, right: 90, child: Container(width: 18, color: Colors.white)),

                  // Nearby Flash Captains moving on streets
                  Positioned(
                    top: 240,
                    left: 125,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
                          child: const Icon(Icons.two_wheeler_rounded, size: 16, color: Color(0xFFFFC107)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                          child: const Text('2 min', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black)),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 360,
                    right: 80,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
                          child: const Icon(Icons.electric_rickshaw_rounded, size: 16, color: Color(0xFFF59E0B)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                          child: const Text('3 min', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black)),
                        ),
                      ],
                    ),
                  ),

                  // Center User GPS Location Pin
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.primaryGreen.withValues(alpha: 0.2),
                            border: Border.all(color: AppTheme.primaryGreen, width: 2),
                          ),
                          child: const Icon(Icons.my_location, color: AppTheme.primaryGreen, size: 28),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 2))],
                            border: Border.all(color: AppTheme.borderGrey),
                          ),
                          child: Text(
                            ride.isDetectingLocation ? 'Locating GPS...' : ride.pickup.title,
                            style: const TextStyle(color: AppTheme.textBlack, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Floating GPS Recenter Button
                  Positioned(
                    right: 16,
                    bottom: 260,
                    child: FloatingActionButton.small(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.primaryGreen,
                      onPressed: () {
                        ride.fetchLiveLocation();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Live GPS Location Updated!')));
                      },
                      child: const Icon(Icons.gps_fixed),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Top Interactive Dual Search Card (Direct Typing & GPS Picker)
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
                    // Editable Pickup Location
                    Row(
                      children: [
                        const Icon(Icons.circle, color: AppTheme.primaryGreen, size: 14),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _pickupController,
                            style: const TextStyle(color: AppTheme.textBlack, fontSize: 13, fontWeight: FontWeight.bold),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              hintText: 'Enter Pickup Location...',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              fillColor: Colors.transparent,
                            ),
                            onSubmitted: (val) {
                              if (val.trim().isNotEmpty) ride.setPickupManual(val.trim());
                            },
                          ),
                        ),
                        IconButton(
                          tooltip: 'Detect Live GPS',
                          icon: const Icon(Icons.my_location, color: AppTheme.primaryGreen, size: 20),
                          onPressed: () {
                            ride.fetchLiveLocation().then((_) {
                              _pickupController.text = ride.pickup.address;
                            });
                          },
                        ),
                      ],
                    ),
                    const Divider(height: 12, color: AppTheme.borderGrey),
                    // Editable Drop Location
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.redAccent, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _dropController,
                            style: const TextStyle(color: AppTheme.textBlack, fontSize: 13, fontWeight: FontWeight.bold),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              hintText: 'Where to? (e.g. RTC Bus Stand, Nellore)',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              fillColor: Colors.transparent,
                            ),
                            onTap: () async {
                              final res = await Navigator.push(context, MaterialPageRoute(builder: (c) => const DestinationSearchScreen()));
                              if (ride.destination != null) {
                                _dropController.text = ride.destination!.title;
                              }
                            },
                            onSubmitted: (val) {
                              if (val.trim().isNotEmpty) ride.setDestinationManual(val.trim());
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.search, color: AppTheme.primaryGreen, size: 20),
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const DestinationSearchScreen())),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Ride Selection Panel with Live Fares & Book Button
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -4))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Choose a Ride', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppTheme.textBlack)),
                      TextButton.icon(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ScheduleRideScreen())),
                        icon: const Icon(Icons.schedule, size: 16, color: AppTheme.primaryGreen),
                        label: const Text('Schedule', style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Horizontal Vehicle Choice Cards (With Native Flutter Icons!)
                  SizedBox(
                    height: 105,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: ride.availableVehicles.length,
                      itemBuilder: (context, index) {
                        final v = ride.availableVehicles[index];
                        final isSelected = v.type == ride.selectedOption?.type;
                        final fare = v.calculateFare(distance) - ride.discount;

                        return GestureDetector(
                          onTap: () => ride.selectVehicle(v),
                          child: Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: 10, top: 4, bottom: 4),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isSelected ? AppTheme.primaryGreen.withValues(alpha: 0.1) : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
                              border: Border.all(color: isSelected ? AppTheme.primaryGreen : AppTheme.borderGrey, width: isSelected ? 2 : 1),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(v.icon, size: 30, color: isSelected ? AppTheme.primaryGreen : v.iconColor),
                                const SizedBox(height: 4),
                                Text(v.title.replaceFirst('Flash ', ''), style: const TextStyle(color: AppTheme.textBlack, fontSize: 12, fontWeight: FontWeight.bold)),
                                Text('₹${fare.toStringAsFixed(0)}', style: const TextStyle(color: AppTheme.primaryGreen, fontSize: 13, fontWeight: FontWeight.w900)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),
                  // Direct Action Book Ride Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ride.startSearching();
                        Navigator.push(context, MaterialPageRoute(builder: (c) => const SearchingCaptainScreen()));
                      },
                      child: Text(
                        'Book ${ride.selectedOption?.title ?? "Ride"} • ₹${(ride.selectedOption?.calculateFare(distance) ?? 45.0).toStringAsFixed(0)}',
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
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

# 4. Update Destination Search Screen with Manual Typing & Suggested Places
@'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../models/ride_model.dart';
import '../../providers/ride_provider.dart';

class DestinationSearchScreen extends StatefulWidget {
  const DestinationSearchScreen({super.key});

  @override
  State<DestinationSearchScreen> createState() => _DestinationSearchScreenState();
}

class _DestinationSearchScreenState extends State<DestinationSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _pickupController = TextEditingController();

  final List<PlaceModel> popularPlaces = [
    PlaceModel(title: 'Nellore RTC Main Bus Stand', address: 'Grand Trunk Road, Nellore', distanceKm: 4.2),
    PlaceModel(title: 'Nellore Railway Station', address: 'Railway Feeder Rd, Nellore', distanceKm: 5.8),
    PlaceModel(title: 'VRC Centre Circle', address: 'VRC Circle, Trunk Road, Nellore', distanceKm: 3.1),
    PlaceModel(title: 'Magunta Layout Park', address: 'Magunta Layout, Nellore', distanceKm: 1.5),
    PlaceModel(title: 'Current Office Substation', address: 'Dargamitta, Nellore', distanceKm: 2.8),
    PlaceModel(title: 'MGB Felicity Mall', address: 'Grand Trunk Road, Nellore', distanceKm: 4.9),
  ];

  @override
  void initState() {
    super.initState();
    final ride = Provider.of<RideProvider>(context, listen: false);
    _pickupController.text = ride.pickup.address;
  }

  @override
  Widget build(BuildContext context) {
    final ride = Provider.of<RideProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Search & Select Location')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  controller: _pickupController,
                  style: const TextStyle(color: AppTheme.textBlack, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.circle, color: AppTheme.primaryGreen, size: 14),
                    hintText: 'Pickup Address...',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.my_location, color: AppTheme.primaryGreen),
                      onPressed: () {
                        ride.fetchLiveLocation().then((_) {
                          _pickupController.text = ride.pickup.address;
                        });
                      },
                    ),
                  ),
                  onSubmitted: (val) => ride.setPickupManual(val),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: const TextStyle(color: AppTheme.textBlack, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.location_on, color: Colors.redAccent, size: 20),
                    hintText: 'Type drop location in Nellore...',
                  ),
                  onSubmitted: (val) {
                    if (val.trim().isNotEmpty) {
                      ride.setDestinationManual(val.trim());
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.borderGrey),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(alignment: Alignment.centerLeft, child: Text('Quick Select Places in Nellore', style: TextStyle(color: AppTheme.textGrey, fontWeight: FontWeight.bold))),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: popularPlaces.length,
              itemBuilder: (context, index) {
                final place = popularPlaces[index];
                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.place_rounded, color: AppTheme.primaryGreen),
                  ),
                  title: Text(place.title, style: const TextStyle(color: AppTheme.textBlack, fontWeight: FontWeight.bold)),
                  subtitle: Text('${place.address} • ${place.distanceKm} km', style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)),
                  trailing: Text('₹${(25 + 9 * place.distanceKm).toInt()}', style: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 15)),
                  onTap: () {
                    ride.setDestination(place);
                    Navigator.pop(context);
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

Write-Host "Verifying code health with dart fix and flutter analyze..." -ForegroundColor Green
dart fix --apply | Out-Null
flutter analyze

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " Real Vector Icons & Interactive Pickup/Drop Successfully Updated!            " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green