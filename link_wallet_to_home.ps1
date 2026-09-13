Write-Host "Connecting Flash Wallet to Home Screen Drawer & Menu..." -ForegroundColor Green

$homeCode = @'
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/config/routes.dart';
import '../../services/location_service.dart';
import '../../models/location_model.dart';
import '../../views/wallet/wallet_screen.dart';
import '../../views/safety/safety_toolkit_screen.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _currentIndex = 0;
  List<LocationModel> _popularPlaces = [];

  @override
  void initState() {
    super.initState();
    _popularPlaces = LocationService.getPopularNellorePlaces();
  }

  void _openWallet() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const WalletScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 26),
            tooltip: 'Menu',
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Row(
          children: [
            Icon(Icons.flash_on_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text('Flash2Ride Nellore', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        backgroundColor: const Color(0xFF0066FF),
        elevation: 0,
        actions: [
          // టాప్ బార్ లో డైరెక్ట్ వాలెట్ బటన్
          IconButton(
            icon: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white),
            tooltip: 'Flash Wallet',
            onPressed: _openWallet,
          ),
          IconButton(
            icon: const Icon(Icons.security_rounded, color: Colors.white),
            tooltip: 'Safety Toolkit',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SafetyToolkitScreen())),
          ),
        ],
      ),

      // మీరు అడిగిన ఆ 3 లైన్స్ / 3 డాట్స్ మెనూ (Drawer)
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text('Ramesh Kumar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              accountEmail: const Text('+91 98765 43210 \u2022 Nellore'),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Color(0xFF0066FF), size: 38),
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF0066FF),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.history_rounded),
              title: const Text('My Rides / Activity'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.rideHistory);
              },
            ),
            // మీరు అడిగిన 3వ ఆప్షన్: Flash Wallet (ఇప్పుడు నేరుగా ఓపెన్ అవుతుంది)
            ListTile(
              leading: const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF0066FF)),
              title: const Text(
                'Flash Wallet',
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0066FF)),
              ),
              subtitle: const Text('Balance: \u20B9250.00'),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F8F0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('ACTIVE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF00A859))),
              ),
              onTap: () {
                Navigator.pop(context); // మెనూ క్లోజ్ చేస్తుంది
                _openWallet();          // వెంటనే వాలెట్ స్క్రీన్ ఓపెన్ చేస్తుంది!
              },
            ),
            ListTile(
              leading: const Icon(Icons.bolt_rounded, color: Colors.amber),
              title: const Text('Power Pass (Subscriptions)'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.security_rounded, color: Color(0xFF00A859)),
              title: const Text('Safety Toolkit & SOS'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SafetyToolkitScreen()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.help_outline_rounded),
              title: const Text('Help & Support'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => Navigator.pushNamed(context, AppRoutes.locationSearch),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Color(0xFF0066FF), size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Where to in Nellore?',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textMuted),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Services', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildServiceCard('Daily Ride', Icons.motorcycle_rounded, AppColors.bike, () {
                  Navigator.pushNamed(context, AppRoutes.rideSelection);
                }),
                const SizedBox(width: 12),
                _buildServiceCard('Auto Rickshaw', Icons.electric_rickshaw_rounded, AppColors.auto, () {
                  Navigator.pushNamed(context, AppRoutes.rideSelection);
                }),
                const SizedBox(width: 12),
                _buildServiceCard('Send Parcel', Icons.inventory_2_rounded, AppColors.parcel, () {
                  Navigator.pushNamed(context, AppRoutes.rideSelection);
                }),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Popular Destinations in Nellore', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ..._popularPlaces.map((place) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFEBF3FF),
                  child: Icon(Icons.location_on, color: Color(0xFF0066FF)),
                ),
                title: Text(place.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(place.address),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(context, AppRoutes.rideSelection, arguments: place),
              ),
            )),
          ],
        ),
      ),

      // కింద ఉండే బాటమ్ బార్ లోని 3వ ఐకాన్ కూడా వాలెట్ కు కనెక్ట్ చేయబడింది
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() => _currentIndex = i);
          if (i == 1) Navigator.pushNamed(context, AppRoutes.rideHistory);
          if (i == 2) _openWallet(); // Opens Wallet!
          if (i == 3) Navigator.pushNamed(context, AppRoutes.userProfile);
        },
        selectedItemColor: const Color(0xFF0066FF),
        unselectedItemColor: AppColors.textMuted,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Activity'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }

  Widget _buildServiceCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              CircleAvatar(backgroundColor: color.withOpacity(0.12), radius: 24, child: Icon(icon, color: color, size: 26)),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
'@

# ఫైల్స్ లోకి అప్‌డేట్ చేస్తుంది
$p1 = "$PWD\lib\screens\home\customer_home_screen.dart"
[System.IO.File]::WriteAllText($p1, $homeCode, [System.Text.Encoding]::UTF8)

$p2 = "$PWD\lib\views\home\home_screen.dart"
if (Test-Path "$PWD\lib\views\home") {
    [System.IO.File]::WriteAllText($p2, $homeCode, [System.Text.Encoding]::UTF8)
}

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "SUCCESS: Flash Wallet connected to Drawer Menu & Bottom Bar!" -ForegroundColor Green
Write-Host "Click Drawer -> 3rd option 'Flash Wallet' to view!" -ForegroundColor Yellow
Write-Host "Now press F5 in Chrome or 'R' in CMD to view." -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan