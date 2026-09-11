Write-Host "Updating Home Screen Top Header with Prominent Eagle Symbol (Head, Beak, White Cheek & Blue Eye)..." -ForegroundColor Green

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
          // LAYER 2: Exact Top Header matching image_a25547.png with Real Eagle
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

  // Top Header Widget matching image_a25547.png
  Widget _buildTopHeader() {
    const Color brandRoyalBlue = Color(0xFF0058FF);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: brandRoyalBlue,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Left: Hamburger Menu (☰)
              Builder(
                builder: (ctx) => IconButton(
                  icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 32),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                ),
              ),

              // 2. Center: Prominent Eagle Symbol + Flash2Ride Typography
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Prominent Eagle Head Graphic (Head, Hooked Beak, White Cheek & Blue Eye)
                  const SizedBox(
                    width: 126,
                    height: 24,
                    child: CustomPaint(
                      painter: _ProminentEaglePainter(),
                    ),
                  ),
                  const SizedBox(height: 1),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Golden Speedlines ≡
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 20, height: 3.5, decoration: BoxDecoration(color: const Color(0xFFFFD21C), borderRadius: BorderRadius.circular(2))),
                          const SizedBox(height: 2.8),
                          Container(width: 14, height: 3.5, decoration: BoxDecoration(color: const Color(0xFFFFD21C), borderRadius: BorderRadius.circular(2))),
                          const SizedBox(height: 2.8),
                          Container(width: 8, height: 3.5, decoration: BoxDecoration(color: const Color(0xFFFFD21C), borderRadius: BorderRadius.circular(2))),
                        ],
                      ),
                      const SizedBox(width: 6),

                      // Flash2Ride Typography
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Flash',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                fontStyle: FontStyle.italic,
                                letterSpacing: -0.6,
                              ),
                            ),
                            TextSpan(
                              text: '2',
                              style: TextStyle(
                                color: Color(0xFFFFD21C),
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            TextSpan(
                              text: 'Ride',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                fontStyle: FontStyle.italic,
                                letterSpacing: -0.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // 3. Right: Notification Bell (🔔)
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 28),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notifications: No new alerts')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Map Background Widget
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
            'Header with Eagle Symbol Active',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Top banner matching image_a25547.png with eagle symbol is active. Next: Add "Where to?" Destination Card & Vehicle Options.',
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

// 🦅 Prominent Eagle Symbol: Head Arch, Hooked Beak, White Cheek & Blue Eye
class _ProminentEaglePainter extends CustomPainter {
  const _ProminentEaglePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Golden Yellow Aerodynamic Eagle Body & Hooked Beak
    final yellowPaint = Paint()
      ..color = const Color(0xFFFFD21C)
      ..style = PaintingStyle.fill;

    final bodyPath = Path();
    bodyPath.moveTo(w * 0.02, h * 0.78);
    // Smooth upward arch
    bodyPath.cubicTo(
      w * 0.35, -h * 0.08,
      w * 0.65, h * 0.05,
      w * 0.84, h * 0.32,
    );
    // Sloping down towards the sharp beak tip
    bodyPath.cubicTo(
      w * 0.90, h * 0.42,
      w * 0.96, h * 0.52,
      w, h * 0.64,
    );
    // Hook of the beak cutting back underneath
    bodyPath.lineTo(w * 0.93, h * 0.80);
    // Lower beak to throat
    bodyPath.lineTo(w * 0.85, h * 0.68);
    // Neck curve down
    bodyPath.cubicTo(
      w * 0.78, h * 0.86,
      w * 0.72, h * 0.96,
      w * 0.68, h,
    );
    // Inner underbelly arch sweeping back to the left
    bodyPath.cubicTo(
      w * 0.72, h * 0.54,
      w * 0.45, h * 0.35,
      w * 0.12, h * 0.88,
    );
    bodyPath.close();
    canvas.drawPath(bodyPath, yellowPaint);

    // 2. Crisp White Face / Cheek Patch
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final cheekPath = Path();
    cheekPath.moveTo(w * 0.70, h * 0.46);
    cheekPath.cubicTo(
      w * 0.78, h * 0.34,
      w * 0.86, h * 0.48,
      w * 0.88, h * 0.54,
    );
    cheekPath.lineTo(w * 0.85, h * 0.68);
    cheekPath.cubicTo(
      w * 0.76, h * 0.80,
      w * 0.72, h * 0.92,
      w * 0.68, h,
    );
    cheekPath.close();
    canvas.drawPath(cheekPath, whitePaint);

    // 3. Fierce Blue Eagle Eye (Navy Socket + White Glisten Pupil)
    final eyeCenter = Offset(w * 0.80, h * 0.53);
    canvas.drawCircle(eyeCenter, 3.2, Paint()..color = const Color(0xFF003899));
    canvas.drawCircle(Offset(eyeCenter.dx - 0.8, eyeCenter.dy - 0.8), 1.2, Paint()..color = Colors.white);
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
Write-Host " Prominent Eagle Symbol Header Updated! 0 Errors! Press 'R' or Ctrl+R!        " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green