Write-Host "Updating ONLY Screen 5 (Home & Live Map Screen) Matching Roadmap Phone #5 Pin-to-Pin..." -ForegroundColor Green

$projectDir = "C:\Users\DELL\Desktop\flash_2_ride"
Set-Location $projectDir

# Update ONLY lib/screens/home/home_screen.dart (Screens 1 to 4 are 100% UNTOUCHED!)
@'
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _currentNavIndex = 0;
  String _selectedCategory = 'Cab';
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
          // 1. High-Fidelity Live Nellore Street Map Layer
          Positioned.fill(
            child: CustomPaint(
              painter: NelloreLiveMapPainter(pulseAnimation: _pulseController),
            ),
          ),

          // 2. Top App Bar with Menu & ≡Flash2Ride Logo
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                left: 16,
                right: 16,
                bottom: 12,
              ),
              decoration: BoxDecoration(
                color: AppTheme.mainBlue,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Menu Hamburger on left
                  Builder(
                    builder: (ctx) => IconButton(
                      icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 28),
                      onPressed: () => Scaffold.of(ctx).openDrawer(),
                    ),
                  ),

                  // Center Logo: ≡Flash2Ride
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(width: 18, height: 3, decoration: BoxDecoration(color: AppTheme.brandYellow, borderRadius: BorderRadius.circular(2))),
                          const SizedBox(height: 2.5),
                          Container(width: 13, height: 3, decoration: BoxDecoration(color: AppTheme.brandYellow, borderRadius: BorderRadius.circular(2))),
                          const SizedBox(height: 2.5),
                          Container(width: 8, height: 3, decoration: BoxDecoration(color: AppTheme.brandYellow, borderRadius: BorderRadius.circular(2))),
                        ],
                      ),
                      const SizedBox(width: 6),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Flash',
                              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic),
                            ),
                            TextSpan(
                              text: '2',
                              style: TextStyle(color: AppTheme.brandYellow, fontSize: 26, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic),
                            ),
                            TextSpan(
                              text: 'Ride',
                              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Notification Bell on right
                  IconButton(
                    icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 26),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),

          // 3. Floating "Where to?" Search Card & Categories (Roadmap #5)
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // A. Elevated "Where to?" Destination Card
                GestureDetector(
                  onTap: () {
                    // Navigate to Screen 6: Destination Search
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Opening Screen 6: Destination Search...'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.search_rounded, color: AppTheme.mainBlue, size: 26),
                            SizedBox(width: 10),
                            Text(
                              'Where to?',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.my_location_rounded, color: AppTheme.mainBlue, size: 18),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Current Location: Nellore, Andhra Pradesh',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF334155),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // B. 4 Service Categories Dock (Bike, Auto, Cab, Parcel)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildCategoryItem('Bike', Icons.two_wheeler_rounded, const Color(0xFF22C55E)),
                      _buildCategoryItem('Auto', Icons.electric_rickshaw_rounded, const Color(0xFFF59E0B)),
                      _buildCategoryItem('Cab', Icons.local_taxi_rounded, AppTheme.mainBlue),
                      _buildCategoryItem('Parcel', Icons.inventory_2_rounded, const Color(0xFF8B5CF6)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // 4. Bottom Navigation Bar matching Roadmap #5 (Home, History, Wallet, Profile)
      bottomNavigationBar: Container(
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
          selectedItemColor: AppTheme.mainBlue,
          unselectedItemColor: const Color(0xFF94A3B8),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_rounded),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_rounded),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String title, IconData icon, Color color) {
    final isSelected = _selectedCategory == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = title),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? color.withValues(alpha: 0.15) : const Color(0xFFF8FAFC),
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? color : const Color(0xFFE2E8F0),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
              color: isSelected ? color : const Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppTheme.mainBlue),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: AppTheme.mainBlue),
            ),
            accountName: const Text('Ramesh Kumar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            accountEmail: const Text('ramesh@gmail.com', style: TextStyle(color: Colors.white70)),
          ),
          ListTile(leading: const Icon(Icons.local_taxi_rounded, color: AppTheme.mainBlue), title: const Text('Book Ride'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.history_rounded), title: const Text('Ride History'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.account_balance_wallet_outlined), title: const Text('Flash Wallet'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.security_rounded), title: const Text('Safety Toolkit'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.settings_outlined), title: const Text('Settings'), onTap: () => Navigator.pop(context)),
          const Divider(),
          ListTile(leading: const Icon(Icons.logout_rounded, color: Colors.redAccent), title: const Text('Logout', style: TextStyle(color: Colors.redAccent)), onTap: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}

// 🎨 High-Definition Nellore City Live Map Painter with Roads, River & Live Pins
class NelloreLiveMapPainter extends CustomPainter {
  final Animation<double> pulseAnimation;

  NelloreLiveMapPainter({required this.pulseAnimation}) : super(repaint: pulseAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Light Terrain Background
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), Paint()..color = const Color(0xFFF3F6F9));

    // 2. Green Parks / Open Areas in Nellore
    final parkPaint = Paint()..color = const Color(0xFFE2F0D9);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.08, h * 0.22, w * 0.35, h * 0.18), const Radius.circular(16)), parkPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.55, h * 0.35, w * 0.38, h * 0.20), const Radius.circular(16)), parkPaint);

    // 3. Roads Network (Penna Bridge, Trunk Road, Mini Bypass)
    final roadBase = Paint()..color = const Color(0xFFE2E8F0)..strokeWidth = 14..strokeCap = StrokeCap.round;
    final roadInner = Paint()..color = Colors.white..strokeWidth = 10..strokeCap = StrokeCap.round;

    // Road 1 (Trunk Road - Vertical)
    canvas.drawLine(Offset(w * 0.35, 0), Offset(w * 0.40, h), roadBase);
    canvas.drawLine(Offset(w * 0.35, 0), Offset(w * 0.40, h), roadInner);

    // Road 2 (Mini Bypass - Curved)
    final bypassPath = Path();
    bypassPath.moveTo(0, h * 0.30);
    bypassPath.quadraticBezierTo(w * 0.50, h * 0.38, w, h * 0.25);
    canvas.drawPath(bypassPath, roadBase);
    canvas.drawPath(bypassPath, roadInner);

    // Road 3 (Cross Link)
    canvas.drawLine(Offset(w * 0.15, h * 0.55), Offset(w * 0.85, h * 0.52), roadBase);
    canvas.drawLine(Offset(w * 0.15, h * 0.55), Offset(w * 0.85, h * 0.52), roadInner);

    // 4. "Nellore" Area Watermark Text
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Nellore',
        style: TextStyle(
          color: const Color(0xFF94A3B8).withValues(alpha: 0.35),
          fontSize: 34,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset(w * 0.42, h * 0.28));

    // 5. Moving / Nearby Vehicles on Nellore Streets
    _drawVehicleMarker(canvas, Offset(w * 0.38, h * 0.20), Icons.local_taxi_rounded, AppTheme.mainBlue);
    _drawVehicleMarker(canvas, Offset(w * 0.22, h * 0.33), Icons.electric_rickshaw_rounded, const Color(0xFFF59E0B));
    _drawVehicleMarker(canvas, Offset(w * 0.65, h * 0.30), Icons.two_wheeler_rounded, const Color(0xFF22C55E));
    _drawVehicleMarker(canvas, Offset(w * 0.70, h * 0.53), Icons.local_taxi_rounded, AppTheme.mainBlue);

    // 6. User Current Location Pulsing Pin (📍) at Center
    final pinCenter = Offset(w * 0.45, h * 0.44);
    final pulseRadius = 14 + (pulseAnimation.value * 12);
    final pulseAlpha = (1.0 - pulseAnimation.value) * 0.4;

    // Animated Pulse Ring
    canvas.drawCircle(
      pinCenter,
      pulseRadius,
      Paint()..color = AppTheme.mainBlue.withValues(alpha: pulseAlpha),
    );

    // Inner Core Marker
    canvas.drawCircle(pinCenter, 10, Paint()..color = Colors.white);
    canvas.drawCircle(pinCenter, 7, Paint()..color = AppTheme.mainBlue);
  }

  void _drawVehicleMarker(Canvas canvas, Offset pos, IconData icon, Color color) {
    // Drop shadow
    canvas.drawCircle(
      pos,
      14,
      Paint()..color = Colors.black.withValues(alpha: 0.12)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    // White background
    canvas.drawCircle(pos, 13, Paint()..color = Colors.white);
    canvas.drawCircle(pos, 13, Paint()..color = color.withValues(alpha: 0.3)..style = PaintingStyle.stroke..strokeWidth = 1.5);

    // Small Vehicle Dot
    canvas.drawCircle(pos, 6, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant NelloreLiveMapPainter oldDelegate) => true;
}
'@ | Set-Content -Path (Join-Path $projectDir 'lib\screens\home\home_screen.dart') -Encoding UTF8

dart fix --apply | Out-Null
flutter analyze

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " Screen 5 (Home & Live Map Screen) Ready! Screens 1-4 Untouched. Press 'R'!   " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green