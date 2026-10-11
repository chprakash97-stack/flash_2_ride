import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// మీరు క్రియేట్ చేసిన సపరేట్ మ్యాప్ ఫైల్ ఇంపోర్ట్ (జీరో-ల్యాగ్ కోసం)
import 'fast_google_map_view.dart';

// Screens & Views Imports (మీ ఒరిజినల్ ఇంపోర్ట్స్ అన్నీ యథాతథంగా ఉన్నాయి)
import '../../views/history/ride_history_screen.dart';
import '../../views/payment/payment_methods_screen.dart';
import '../../views/support/help_support_screen.dart';
import '../../views/profile/about_us_screen.dart';
import '../../screens/profile/user_profile_screen.dart';
import '../../screens/home/saved_places_screen.dart';
import '../features/refer_earn_screen.dart';
import '../features/power_pass_screen.dart';
import '../features/wallet_screen.dart';
import '../location/destination_search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;
  String _selectedVehicle = 'Bike';

  // Firebase Instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Nellore Default Coordinates
  static const LatLng _nelloreDefault = LatLng(14.4426, 79.9865);
  LatLng _currentLatLng = _nelloreDefault;

  // మ్యాప్‌ను హ్యాంగ్ లేకుండా కంట్రోల్ చేసే గ్లోబల్ కీ
  final GlobalKey<FastGoogleMapViewState> _mapKey = GlobalKey<FastGoogleMapViewState>();

  String _currentAddress = 'Nellore, Andhra Pradesh';
  bool _isLoadingLocation = true;
  StreamSubscription<Position>? _positionStreamSubscription;

  final List<Map<String, dynamic>> _defaultVehicles = [
    {'name': 'Bike', 'image': 'assets/images/vehicle_bike.png', 'icon': Icons.two_wheeler_rounded, 'eta': '2 mins'},
    {'name': 'Auto', 'image': 'assets/images/vehicle_auto.png', 'icon': Icons.electric_rickshaw_rounded, 'eta': '4 mins'},
    {'name': 'Cab', 'image': 'assets/images/vehicle_cab.png', 'icon': Icons.local_taxi_rounded, 'eta': '6 mins'},
    {'name': 'Parcel', 'image': 'assets/images/parcel/parcel_box.png', 'icon': Icons.inventory_2_rounded, 'eta': 'Instant'},
  ];

  @override
  void initState() {
    super.initState();
    _startLiveLocationTracking();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  /// కస్టమర్ మూవ్ అవుతున్నప్పుడు లైవ్ ట్రాకింగ్ (50m ఫిల్టర్‌తో - నో ల్యాగ్)
  Future<void> _startLiveLocationTracking() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) setState(() => _isLoadingLocation = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) setState(() => _isLoadingLocation = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) setState(() => _isLoadingLocation = false);
        return;
      }

      // 1. ప్రారంభ స్థానం తీసుకోవడం
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      _updateLocationState(position.latitude, position.longitude, animateCamera: true);

      // 2. కస్టమర్ డ్రైవింగ్ చేస్తున్నప్పుడు ప్రతి 50 మీటర్లకి ఒకసారి మాత్రమే అప్డేట్ అవుతుంది (నో హ్యాంగ్)
      _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 50,
        ),
      ).listen((pos) {
        _updateLocationState(pos.latitude, pos.longitude, animateCamera: false);
      });
    } catch (e) {
      debugPrint('Location Error: $e');
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  /// లొకేషన్ కోఆర్డినేట్స్ & అడ్రస్ అప్‌డేట్
  Future<void> _updateLocationState(double lat, double lng, {bool animateCamera = false}) async {
    _currentLatLng = LatLng(lat, lng);

    if (animateCamera) {
      _mapKey.currentState?.animateToLocation(_currentLatLng);
    }

    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty && mounted) {
        final place = placemarks.first;
        final subLocality = place.subLocality ?? place.locality ?? '';
        final city = place.locality ?? place.administrativeArea ?? 'Nellore';
        final state = place.administrativeArea ?? 'Andhra Pradesh';
        final formatted = subLocality.isNotEmpty ? '$subLocality, $city' : '$city, $state';

        setState(() {
          _currentAddress = formatted;
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      debugPrint('Geocoding error: $e');
    }
  }

  /// కస్టమర్ 2 కి.మీ దూరం ప్రయాణించి "Where to?" నొక్కినప్పుడు ఆ క్షణపు తాజా GPS లొకేషన్ తీసుకోవడం
  Future<void> _handleWhereToClick() async {
    try {
      final freshPos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      _currentLatLng = LatLng(freshPos.latitude, freshPos.longitude);
    } catch (_) {}

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DestinationSearchScreen(
          selectedVehicle: _selectedVehicle,
        ),
      ),
    );
  }

  /// Logout Action (మీ ఒరిజినల్ లాజిక్)
  Future<void> _handleSignOut() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Log Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await _auth.signOut();
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = _auth.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: _buildDrawer(currentUser),
      body: Stack(
        children: [
          // -------------------------------------------------------------
          // 1. LAYER 1: సపరేట్ ఫైల్ నుండి గూగుల్ మ్యాప్ (100% Zero-Lag & Smooth)
          // -------------------------------------------------------------
          Positioned.fill(
            child: FastGoogleMapView(
              key: _mapKey,
              initialCenter: _nelloreDefault,
            ),
          ),

          // -------------------------------------------------------------
          // 2. LAYER 2: కరెంట్ లొకేషన్ టూల్‌టిప్ బబుల్
          // -------------------------------------------------------------
          Positioned(
            top: MediaQuery.of(context).padding.top + 85,
            left: 20,
            right: 70,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0058FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.location_on, color: Colors.white, size: 14),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Current Location',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0058FF),
                            ),
                          ),
                          _isLoadingLocation
                              ? const SizedBox(
                                  height: 12,
                                  width: 12,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(
                                  _currentAddress,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF475569),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // -------------------------------------------------------------
          // 3. LAYER 3: రీ-సెంటర్ GPS బటన్ (ప్రస్తుత తాజా స్థానానికి రీసెంటర్)
          // -------------------------------------------------------------
          Positioned(
            top: MediaQuery.of(context).padding.top + 85,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.my_location_rounded, color: Color(0xFF0058FF), size: 22),
                tooltip: 'Recenter Map',
                onPressed: () {
                  _mapKey.currentState?.animateToLocation(_currentLatLng);
                },
              ),
            ),
          ),

          // -------------------------------------------------------------
          // 4. LAYER 4: హెడర్ బార్ (నోటిఫికేషన్లతో సహా)
          // -------------------------------------------------------------
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopHeader(currentUser?.uid),
          ),

          // -------------------------------------------------------------
          // 5. LAYER 5: "Where to?" & వాహనాల సెలెక్టర్ కార్డ్
          // -------------------------------------------------------------
          Positioned(
            left: 14,
            right: 14,
            bottom: 12,
            child: _buildWhereToAndVehiclesCard(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// సైడ్ డ్రాయర్ (ఫైర్‌స్టోర్ యూజర్ ప్రొఫైల్ సింక్ - మీ ఒరిజినల్ డిజైన్)
  Widget _buildDrawer(User? currentUser) {
    return Drawer(
      child: currentUser == null
          ? const Center(child: Text('No active user found'))
          : StreamBuilder<DocumentSnapshot>(
              stream: _firestore.collection('users').doc(currentUser.uid).snapshots(),
              builder: (context, snapshot) {
                String displayName = currentUser.displayName ?? 'User';
                String email = currentUser.email ?? '';
                String? photoUrl = currentUser.photoURL;
                double walletBalance = 0.0;

                if (snapshot.hasData && snapshot.data!.exists) {
                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  displayName = data['name'] ?? displayName;
                  email = data['email'] ?? email;
                  photoUrl = data['profilePic'] ?? photoUrl;
                  walletBalance = (data['walletBalance'] as num?)?.toDouble() ?? 0.0;
                }

                return ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    UserAccountsDrawerHeader(
                      decoration: const BoxDecoration(color: Color(0xFF2563EB)),
                      currentAccountPicture: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
                            ? NetworkImage(photoUrl)
                            : null,
                        child: (photoUrl == null || photoUrl.isEmpty)
                            ? Text(
                                displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U',
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2563EB),
                                ),
                              )
                            : null,
                      ),
                      accountName: Text(
                        displayName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      accountEmail: Text(email),
                    ),

                    // 1. Refer & Earn
                    ListTile(
                      leading: const Icon(Icons.card_giftcard_rounded, color: Color(0xFF059669)),
                      title: const Text('Refer & Earn', style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: const Text('Get Wallet Bonus', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ReferEarnScreen()),
                        );
                      },
                    ),

                    // 2. Ride History
                    ListTile(
                      leading: const Icon(Icons.history_rounded, color: Color(0xFF2563EB)),
                      title: const Text('Ride History', style: TextStyle(fontWeight: FontWeight.w600)),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RideHistoryScreen()),
                        );
                      },
                    ),

                    // 3. Flash Wallet
                    ListTile(
                      leading: const Icon(Icons.account_balance_wallet_outlined, color: Color(0xFFD97706)),
                      title: const Text('Flash Wallet', style: TextStyle(fontWeight: FontWeight.w600)),
                      trailing: Text(
                        '₹${walletBalance.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD97706)),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const WalletScreen()),
                        );
                      },
                    ),

                    // 4. Power Pass
                    ListTile(
                      leading: const Icon(Icons.bolt_rounded, color: Color(0xFFF59E0B)),
                      title: const Text('Power Pass (Subscriptions)', style: TextStyle(fontWeight: FontWeight.w600)),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PowerPassScreen()),
                        );
                      },
                    ),

                    // 5. Payment Methods
                    ListTile(
                      leading: const Icon(Icons.payment_rounded, color: Color(0xFF2563EB)),
                      title: const Text('Payment Methods', style: TextStyle(fontWeight: FontWeight.w600)),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PaymentMethodsScreen()),
                        );
                      },
                    ),

                    // 6. Saved Places
                    ListTile(
                      leading: const Icon(Icons.bookmark_border_rounded, color: Color(0xFF2563EB)),
                      title: const Text('Saved Places', style: TextStyle(fontWeight: FontWeight.w600)),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SavedPlacesScreen()),
                        );
                      },
                    ),

                    // 7. Help & Support
                    ListTile(
                      leading: const Icon(Icons.help_outline_rounded, color: Color(0xFF2563EB)),
                      title: const Text('Help & Support', style: TextStyle(fontWeight: FontWeight.w600)),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
                        );
                      },
                    ),

                    // 8. About Us
                    ListTile(
                      leading: const Icon(Icons.info_outline_rounded, color: Color(0xFF2563EB)),
                      title: const Text('About Us', style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: const Text('Version 1.0.0 & Legal Policy', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                      trailing: const Icon(Icons.chevron_right, size: 20, color: Color(0xFF94A3B8)),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AboutUsScreen()),
                        );
                      },
                    ),

                    const Divider(),

                    // 9. Sign Out Button
                    ListTile(
                      leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                      title: const Text(
                        'Log Out',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _handleSignOut();
                      },
                    ),
                  ],
                );
              },
            ),
    );
  }

  /// టాప్ హెడర్ బార్ (నోటిఫికేషన్ల బ్యాడ్జ్ తో)
  Widget _buildTopHeader(String? userId) {
    const Color brandRoyalBlue = Color(0xFF0058FF);

    return Container(
      width: double.infinity,
      color: brandRoyalBlue,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Builder(
                builder: (ctx) => IconButton(
                  icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 32),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                ),
              ),
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/images/logo_center.png',
                    height: 56,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text(
                        'Flash2Ride',
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ),
              ),
              if (userId != null)
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('users')
                      .doc(userId)
                      .collection('notifications')
                      .where('isRead', isEqualTo: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    final int unreadCount = snapshot.hasData ? snapshot.data!.docs.length : 0;

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 28),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {},
                        ),
                        if (unreadCount > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                unreadCount > 9 ? '9+' : '$unreadCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                )
              else
                IconButton(
                  icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 28),
                  onPressed: () {},
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// "Where to?" & వాహనాల సెలెక్టర్ కార్డ్
  Widget _buildWhereToAndVehiclesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.search_rounded, color: Color(0xFF0058FF), size: 30),
              SizedBox(width: 8),
              Text(
                'Where to?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // పికప్ లొకేషన్ బార్ (క్లిక్ చేసినప్పుడు తాజా లైవ్ లొకేషన్ తో ఓపెన్ అవుతుంది)
          GestureDetector(
            onTap: _handleWhereToClick,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Icon(
                    _selectedVehicle == 'Parcel' ? Icons.inventory_2_rounded : Icons.my_location_rounded,
                    color: const Color(0xFF0058FF),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _selectedVehicle == 'Parcel'
                          ? 'Send a Parcel from: $_currentAddress'
                          : 'Pickup: $_currentAddress',
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF334155),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: Color(0xFF64748B), size: 22),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // వాహనాల ఎంపిక (ఫైర్‌స్టోర్ vehicle_types నుండి)
          StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('vehicle_types')
                .where('isActive', isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
              List<Map<String, dynamic>> vehicles = _defaultVehicles;

              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                vehicles = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final name = data['name'] ?? 'Vehicle';
                  IconData icon = Icons.directions_car_rounded;
                  String image = 'assets/images/vehicle_${name.toLowerCase()}.png';

                  if (name == 'Bike') icon = Icons.two_wheeler_rounded;
                  if (name == 'Auto') icon = Icons.electric_rickshaw_rounded;
                  if (name == 'Cab') icon = Icons.local_taxi_rounded;
                  if (name == 'Parcel') {
                    icon = Icons.inventory_2_rounded;
                    image = 'assets/images/parcel/parcel_box.png';
                  }

                  return {
                    'name': name,
                    'image': image,
                    'icon': icon,
                    'eta': data['eta'] ?? '',
                  };
                }).toList();
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: vehicles.map((v) {
                  return _buildVehicleItem(
                    v['name'] as String,
                    v['image'] as String,
                    v['icon'] as IconData,
                    eta: v['eta'] as String?,
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  /// వెహికల్ కార్డ్ బటన్
  Widget _buildVehicleItem(String name, String imagePath, IconData fallbackIcon, {String? eta}) {
    final isSelected = _selectedVehicle == name;

    return GestureDetector(
      onTap: () => setState(() => _selectedVehicle = name),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 68,
            height: 60,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF0058FF).withOpacity(0.1)
                  : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected ? const Color(0xFF0058FF) : const Color(0xFFE2E8F0),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    fallbackIcon,
                    color: isSelected ? const Color(0xFF0058FF) : const Color(0xFF475569),
                    size: 28,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
              color: isSelected ? const Color(0xFF0058FF) : const Color(0xFF334155),
            ),
          ),
          if (eta != null && eta.isNotEmpty)
            Text(
              eta,
              style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }

  /// బాటమ్ నావిగేషన్ బార్
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const RideHistoryScreen()));
            return;
          }
          setState(() => _currentNavIndex = index);
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserProfileScreen()),
            ).then((_) {
              if (mounted) setState(() => _currentNavIndex = 0);
            });
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WalletScreen()),
            ).then((_) {
              if (mounted) setState(() => _currentNavIndex = 0);
            });
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF0058FF),
        unselectedItemColor: const Color(0xFF94A3B8),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}