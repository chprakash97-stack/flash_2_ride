import '../features/power_pass_screen.dart';
import '../features/wallet_screen.dart';
import '../location/destination_search_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _currentNavIndex = 0;
  String _selectedVehicle = 'Bike';
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          // -------------------------------------------------------------
          // 1. LAYER 1: Realistic Street Map of Nellore with River & Pins
          // -------------------------------------------------------------
          Positioned.fill(
            child: CustomPaint(
              painter: _NelloreMapPainter(pulseAnimation: _pulseController),
            ),
          ),

          // Current Location Tooltip Bubble on Map (Image 3)
          Positioned(
            top: MediaQuery.of(context).padding.top + 95,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
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
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Current Location',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0058FF)),
                        ),
                        Text(
                          'Nellore, Andhra Pradesh',
                          style: TextStyle(fontSize: 11, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Floating GPS Target Button on top right
          Positioned(
            top: MediaQuery.of(context).padding.top + 95,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.my_location_rounded, color: Color(0xFF0058FF), size: 22),
                onPressed: () {},
              ),
            ),
          ),

          // -------------------------------------------------------------
          // 2. LAYER 2: Seamless Top Header with Logo
          // -------------------------------------------------------------
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopHeader(),
          ),

          // -------------------------------------------------------------
          // 3. LAYER 3: Official Bottom Floating Card (Images 1 & 2 Combined!)
          // -------------------------------------------------------------
          Positioned(
            left: 14,
            right: 14,
            bottom: 12,
            child: _buildWhereToAndVehiclesCard(),
          ),
        ],
      ),

      // -------------------------------------------------------------
      // 4. LAYER 4: Bottom Navigation Bar (Image 3)
      // -------------------------------------------------------------
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Official Seamless Header with Eagle Logo
  Widget _buildTopHeader() {
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
                      return Image.network(
                        'logo_center.png',
                        height: 56,
                        fit: BoxFit.contain,
                        errorBuilder: (ctx, err, st) => const Text(
                          'Flash2Ride',
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 28),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Official Where to? & 4 Vehicles Card matching Demo Image 3
  Widget _buildWhereToAndVehiclesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. "Where to?" Title Row (Image 1)
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

          // 2. Location Pill: Current Location: Nellore, Andhra Pradesh (Image 1)
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const DestinationSearchScreen()));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
              ),
              child: const Row(
                children: [
                  Icon(Icons.my_location_rounded, color: Color(0xFF0058FF), size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Current Location: Nellore, Andhra Pradesh',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF334155),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: Color(0xFF64748B), size: 22),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // 3. Four Vehicles Row: Bike, Auto, Cab, Parcel (Images 2 & 3!)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildVehicleItem('Bike', 'assets/images/vehicle_bike.png', Icons.two_wheeler_rounded),
              _buildVehicleItem('Auto', 'assets/images/vehicle_auto.png', Icons.electric_rickshaw_rounded),
              _buildVehicleItem('Cab', 'assets/images/vehicle_cab.png', Icons.local_taxi_rounded),
              _buildVehicleItem('Parcel', 'assets/images/vehicle_parcel.png', Icons.inventory_2_rounded),
            ],
          ),
        ],
      ),
    );
  }

  // Individual Vehicle Item with Real Cutout Image & Selection
  Widget _buildVehicleItem(String name, String imagePath, IconData fallbackIcon) {
    final isSelected = _selectedVehicle == name;

    return GestureDetector(
      onTap: () => setState(() => _selectedVehicle = name),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circular Vehicle Display Container
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 68,
            height: 60,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF0058FF).withValues(alpha: 0.1) : const Color(0xFFF8FAFC),
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
                  return Image.network(
                    imagePath.replaceFirst('assets/images/', ''),
                    fit: BoxFit.contain,
                    errorBuilder: (ctx, err, st) => Icon(
                      fallbackIcon,
                      color: isSelected ? const Color(0xFF0058FF) : const Color(0xFF475569),
                      size: 28,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 6),
          // Vehicle Name Text
          Text(
            name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
              color: isSelected ? const Color(0xFF0058FF) : const Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }

  // Bottom Navigation Bar matching Image 3 (Home, History, Wallet, Profile)
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap: (index) => setState(() => _currentNavIndex = index),
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

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF0058FF)),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Color(0xFF0058FF)),
            ),
            accountName: Text('Ramesh Kumar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            accountEmail: Text('ramesh@gmail.com', style: TextStyle(color: Colors.white70)),
          ),
          ListTile(leading: const Icon(Icons.local_taxi_rounded, color: Color(0xFF0058FF)), title: const Text('Book Ride'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.history_rounded), title: const Text('Ride History'), onTap: () => Navigator.pop(context)),
            ListTile(leading: const Icon(Icons.account_balance_wallet_outlined), title: const Text('Flash Wallet'), onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => const WalletScreen())); }),
ListTile(
              leading: const Icon(Icons.bolt_rounded),
              title: const Text('Power Pass (Subscriptions)'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PowerPassScreen()));
              },
            ),
          ListTile(leading: const Icon(Icons.security_rounded), title: const Text('Safety Toolkit'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.settings_outlined), title: const Text('Settings'), onTap: () => Navigator.pop(context)),
          const Divider(),
          ListTile(leading: const Icon(Icons.logout_rounded, color: Colors.redAccent), title: const Text('Logout', style: TextStyle(color: Colors.redAccent)), onTap: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}

// Realistic Nellore City Street Map with Penna River & Nearby Cabs/Autos
class _NelloreMapPainter extends CustomPainter {
  final Animation<double> pulseAnimation;

  _NelloreMapPainter({required this.pulseAnimation}) : super(repaint: pulseAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Terrain Base
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), Paint()..color = const Color(0xFFF1F5F9));

    // 2. Green Parks & Open Zones in Nellore
    final parkPaint = Paint()..color = const Color(0xFFDCFCE7);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.08, h * 0.20, w * 0.32, h * 0.16), const Radius.circular(16)), parkPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.58, h * 0.32, w * 0.34, h * 0.18), const Radius.circular(16)), parkPaint);

    // 3. Penna River Stream (Light Blue)
    final riverPaint = Paint()..color = const Color(0xFFBAE6FD)..strokeWidth = 24..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final riverPath = Path();
    riverPath.moveTo(w * 0.85, 0);
    riverPath.quadraticBezierTo(w * 0.78, h * 0.22, w * 0.95, h * 0.45);
    riverPath.quadraticBezierTo(w, h * 0.60, w * 0.90, h * 0.80);
    canvas.drawPath(riverPath, riverPaint);

    // 4. Roads Network (Trunk Road, Mini Bypass Road)
    final roadBase = Paint()..color = const Color(0xFFCBD5E1)..strokeWidth = 14..strokeCap = StrokeCap.round;
    final roadInner = Paint()..color = Colors.white..strokeWidth = 10..strokeCap = StrokeCap.round;

    // Trunk Road (Vertical)
    canvas.drawLine(Offset(w * 0.35, 0), Offset(w * 0.40, h), roadBase);
    canvas.drawLine(Offset(w * 0.35, 0), Offset(w * 0.40, h), roadInner);

    // Mini Bypass Road (Diagonal Curve)
    final bypassPath = Path();
    bypassPath.moveTo(0, h * 0.28);
    bypassPath.quadraticBezierTo(w * 0.50, h * 0.36, w, h * 0.22);
    canvas.drawPath(bypassPath, roadBase);
    canvas.drawPath(bypassPath, roadInner);

    // Connecting street
    canvas.drawLine(Offset(w * 0.15, h * 0.52), Offset(w * 0.85, h * 0.50), roadBase);
    canvas.drawLine(Offset(w * 0.15, h * 0.52), Offset(w * 0.85, h * 0.50), roadInner);

    // 5. "Nellore" Text Label
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'Nellore',
        style: TextStyle(
          color: Color(0xFF0F172A),
          fontSize: 26,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset(w * 0.38, h * 0.36));

    // 6. Dotted Nearby Vehicles (Green Bike, Purple Cab, Yellow Parcel) as in Image 3
    _drawNearbyMarker(canvas, Offset(w * 0.18, h * 0.28), Icons.two_wheeler, const Color(0xFF16A34A));
    _drawNearbyMarker(canvas, Offset(w * 0.31, h * 0.42), Icons.local_taxi, const Color(0xFF6366F1));
    _drawNearbyMarker(canvas, Offset(w * 0.78, h * 0.26), Icons.local_taxi, const Color(0xFF4338CA));
    _drawNearbyMarker(canvas, Offset(w * 0.85, h * 0.36), Icons.inventory_2, const Color(0xFFF59E0B));

    // 7. Center User Location Pulsing Dot
    final userPos = Offset(w * 0.50, h * 0.30);
    final pulseRad = 16 + (pulseAnimation.value * 14);
    final pulseAlpha = (1.0 - pulseAnimation.value) * 0.35;

    canvas.drawCircle(userPos, pulseRad, Paint()..color = const Color(0xFF0058FF).withValues(alpha: pulseAlpha));
    canvas.drawCircle(userPos, 10, Paint()..color = Colors.white);
    canvas.drawCircle(userPos, 7, Paint()..color = const Color(0xFF0058FF));
  }

  void _drawNearbyMarker(Canvas canvas, Offset pos, IconData icon, Color color) {
    canvas.drawCircle(pos, 14, Paint()..color = Colors.black.withValues(alpha: 0.12)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
    canvas.drawCircle(pos, 13, Paint()..color = color);
    canvas.drawCircle(pos, 4, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _NelloreMapPainter oldDelegate) => true;
}

