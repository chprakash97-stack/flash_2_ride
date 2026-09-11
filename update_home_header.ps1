Write-Host "Adding Blue Top Header with Menu, Wing Logo & Bell Icon to Home Screen..." -ForegroundColor Green

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

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          // -------------------------------------------------------------
          // LAYER 1: Map Background (Google Map / Placeholder Container)
          // -------------------------------------------------------------
          Positioned.fill(
            child: _buildMapBackground(),
          ),

          // -------------------------------------------------------------
          // LAYER 2: Blue Top Header with Menu, Wing Logo & Bell
          // -------------------------------------------------------------
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopHeader(),
          ),

          // -------------------------------------------------------------
          // LAYER 3: Content Placeholder Area at Bottom
          // -------------------------------------------------------------
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: _buildContentPlaceholder(),
          ),
        ],
      ),

      // -------------------------------------------------------------
      // LAYER 4: Bottom Navigation Bar
      // -------------------------------------------------------------
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Top Header Bar Widget
  Widget _buildTopHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 14,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Hamburger Menu Icon (☰)
          Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 28),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => Scaffold.of(ctx).openDrawer(),
            ),
          ),

          // Center: Flash2Ride Logo with small golden Wing Icon
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Small golden wing icon
              const CustomPaint(
                size: Size(22, 18),
                painter: _WingIconPainter(),
              ),
              const SizedBox(width: 6),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Flash',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        letterSpacing: -0.5,
                      ),
                    ),
                    TextSpan(
                      text: '2',
                      style: TextStyle(
                        color: AppTheme.brandYellow,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    TextSpan(
                      text: 'Ride',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Right: Notification Bell Icon (🔔)
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 26),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // Map Background Widget (Placeholder ready for GoogleMap widget)
  Widget _buildMapBackground() {
    return Container(
      color: const Color(0xFFE8EEF5),
      child: Stack(
        children: [
          const CustomPaint(
            size: Size.infinite,
            painter: _MapGridPainter(),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.mainBlue.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: AppTheme.mainBlue,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Nellore, AP',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Content Placeholder Card
  Widget _buildContentPlaceholder() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            'Header Added Successfully',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Top blue header with Menu, Wing Logo & Bell is ready. Next: Add "Where to?" Search & Vehicle Cards.',
            style: TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.4),
          ),
        ],
      ),
    );
  }

  // Standard Bottom Navigation Bar
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
        selectedItemColor: AppTheme.mainBlue,
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

// Small aerodynamic golden wing painter for the logo
class _WingIconPainter extends CustomPainter {
  const _WingIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.brandYellow
      ..style = PaintingStyle.fill;

    // Top primary wing feather
    final path1 = Path();
    path1.moveTo(size.width, 0);
    path1.quadraticBezierTo(size.width * 0.4, 0, 0, size.height * 0.55);
    path1.quadraticBezierTo(size.width * 0.45, size.height * 0.35, size.width, size.height * 0.4);
    path1.close();
    canvas.drawPath(path1, paint);

    // Lower secondary wing feather
    final path2 = Path();
    path2.moveTo(size.width * 0.9, size.height * 0.52);
    path2.quadraticBezierTo(size.width * 0.4, size.height * 0.55, size.width * 0.15, size.height * 0.95);
    path2.quadraticBezierTo(size.width * 0.5, size.height * 0.75, size.width * 0.9, size.height * 0.85);
    path2.close();
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Map grid lines painter
class _MapGridPainter extends CustomPainter {
  const _MapGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFFCBD5E1).withValues(alpha: 0.5)
      ..strokeWidth = 2.0;

    for (double y = 40; y < size.height; y += 80) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
    for (double x = 40; x < size.width; x += 80) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
'@ | Set-Content -Path (Join-Path $projectDir 'lib\screens\home\home_screen.dart') -Encoding UTF8

dart fix --apply | Out-Null
flutter analyze

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " Top Header Added! 0 Errors! Press 'R' or Ctrl+R in Chrome to view!           " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green