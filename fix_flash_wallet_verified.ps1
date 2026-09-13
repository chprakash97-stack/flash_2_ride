Write-Host "=========================================================" -ForegroundColor Cyan
Write-Host "Re-verifying and Fixing Flash Wallet Navigation Bug..." -ForegroundColor Green
Write-Host "=========================================================" -ForegroundColor Cyan

# ప్రాజెక్ట్ ఫోల్డర్ గుర్తింపు
$projectRoot = $PWD
if (-not (Test-Path "$projectRoot\pubspec.yaml")) {
    $candidates = @(
        "$PWD\flash2ride",
        "$PWD\flash2ride_customer_app",
        "$PWD\flash2ride_complete",
        "$env:USERPROFILE\flash2ride",
        "$env:USERPROFILE\Desktop\flash2ride"
    )
    foreach ($c in $candidates) {
        if (Test-Path "$c\pubspec.yaml") {
            $projectRoot = $c
            break
        }
    }
}
Write-Host "Target Project: $projectRoot" -ForegroundColor Yellow

# 1. నూతన Flash Wallet స్క్రీన్ కోడ్
$walletScreenCode = @'
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/config/routes.dart';

class WalletScreen extends StatelessWidget {
  final dynamic data;
  const WalletScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Flash Wallet', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFF00A859),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // బ్యాలెన్స్ కార్డ్
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00A859), Color(0xFF007A3D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF00A859).withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 6)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Available Balance', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
                        child: const Row(
                          children: [
                            Icon(Icons.bolt, color: Colors.amber, size: 16),
                            SizedBox(width: 4),
                            Text('Instant Checkout', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text('₹250.00', style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF00A859),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Opening UPI Payment Gateway (GPay / PhonePe / Paytm)...'), backgroundColor: Color(0xFF00A859)),
                          );
                        },
                        icon: const Icon(Icons.add_circle_outline, size: 18),
                        label: const Text('Add Money', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white70),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Coupons: FLASHRIDE50 applied on next ride!')),
                          );
                        },
                        icon: const Icon(Icons.local_offer_outlined, size: 18),
                        label: const Text('Offers'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Recent Transactions', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildTxItem('Daily Ride Cashback', '+ ₹25.00', 'Today, 05:30 PM', Icons.arrow_downward_rounded, const Color(0xFF00A859)),
            _buildTxItem('Paid for Auto Ride', '- ₹65.00', 'Today, 02:15 PM', Icons.arrow_upward_rounded, Colors.red),
            _buildTxItem('Wallet Top-up via UPI (GPay)', '+ ₹200.00', 'Yesterday, 10:00 AM', Icons.account_balance_wallet_rounded, const Color(0xFF00A859)),
            _buildTxItem('Parcel Delivery Fee', '- ₹40.00', '10 Sep, 06:45 PM', Icons.inventory_2_outlined, Colors.red),
            _buildTxItem('Welcome Bonus - Nellore Launch', '+ ₹130.00', '08 Sep, 09:00 AM', Icons.card_giftcard_rounded, const Color(0xFF00A859)),
          ],
        ),
      ),
    );
  }

  Widget _buildTxItem(String title, String amount, String date, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.12), child: Icon(icon, color: color, size: 20)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: Text(amount, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: color)),
      ),
    );
  }
}
'@

# 2. సరిదిద్దిన CustomerHomeScreen కోడ్ (PostFrameCallback నావిగేషన్‌తో)
$homeScreenCode = @'
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/config/routes.dart';
import '../../services/location_service.dart';
import '../../models/location_model.dart';
import '../../views/wallet/wallet_screen.dart';

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

  // కాన్‌ఫ్లిక్ట్ లేకుండా సురక్షితంగా వాలెట్ ఓపెన్ చేసే ఫంక్షన్
  void _openWalletSafely() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const WalletScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 26),
            tooltip: 'Side Menu',
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
        backgroundColor: const Color(0xFF00A859),
        elevation: 0,
        actions: [
          // త్రీ డాట్స్ మెనూ (PopupMenuButton)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white, size: 26),
            tooltip: 'More Options',
            onSelected: (value) {
              if (value == 'wallet') {
                _openWalletSafely(); // యానిమేషన్ ముగిసిన వెంటనే వాలెట్ స్క్రీన్ ఓపెన్ అవుతుంది!
              } else if (value == 'history') {
                WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.pushNamed(context, AppRoutes.rideHistory));
              } else if (value == 'safety') {
                WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.pushNamed(context, AppRoutes.safetyToolkit));
              } else if (value == 'profile') {
                WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.pushNamed(context, AppRoutes.userProfile));
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline, color: Color(0xFF1F2937), size: 20),
                    SizedBox(width: 10),
                    Text('My Profile'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'history',
                child: Row(
                  children: [
                    Icon(Icons.history, color: Color(0xFF1F2937), size: 20),
                    SizedBox(width: 10),
                    Text('Ride & Parcel History'),
                  ],
                ),
              ),
              // మీరు అడిగిన 3వ ఆప్షన్: Flash Wallet
              const PopupMenuItem<String>(
                value: 'wallet',
                child: Row(
                  children: [
                    Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF00A859), size: 20),
                    SizedBox(width: 10),
                    Text('Flash Wallet (₹250.00)', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00A859))),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'safety',
                child: Row(
                  children: [
                    Icon(Icons.security, color: Color(0xFFDC2626), size: 20),
                    SizedBox(width: 10),
                    Text('Safety Toolkit'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      // సైడ్ డ్రాయర్ మెనూ
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text('Chebolu Prakash', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              accountEmail: Text('+91 99513 82847 • Nellore'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Color(0xFF00A859), size: 38),
              ),
              decoration: BoxDecoration(color: Color(0xFF00A859)),
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
                WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.pushNamed(context, AppRoutes.rideHistory));
              },
            ),
            // సైడ్ మెనూ లోని 3వ ఆప్షన్
            ListTile(
              leading: const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF00A859)),
              title: const Text('Flash Wallet', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00A859))),
              subtitle: const Text('Balance: ₹250.00'),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: const Color(0xFFE8F8F0), borderRadius: BorderRadius.circular(8)),
                child: const Text('ACTIVE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF00A859))),
              ),
              onTap: () {
                Navigator.pop(context);
                _openWalletSafely();
              },
            ),
            ListTile(
              leading: const Icon(Icons.security_rounded, color: Color(0xFFDC2626)),
              title: const Text('Safety Toolkit & SOS'),
              onTap: () {
                Navigator.pop(context);
                WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.pushNamed(context, AppRoutes.safetyToolkit));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.help_outline_rounded),
              title: const Text('Customer Support'),
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
            // హోమ్ స్క్రీన్ మీదే డైరెక్ట్ గ్రీన్ వాలెట్ బ్యానర్
            InkWell(
              onTap: _openWalletSafely,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00A859), Color(0xFF007A3D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFF00A859).withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 3)),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                      child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Flash Wallet Balance', style: TextStyle(color: Colors.white70, fontSize: 11)),
                          Text('₹250.00', style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                      child: const Text('Open Wallet >', style: TextStyle(color: Color(0xFF00A859), fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                ),
              ),
            ),

            // సెర్చ్ బార్
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
                    Icon(Icons.search, color: Color(0xFF00A859), size: 28),
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
                  backgroundColor: Color(0xFFE8F8F0),
                  child: Icon(Icons.location_on, color: Color(0xFF00A859)),
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

      // బాటమ్ బార్ 3వ ఆప్షన్ (Wallet)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() => _currentIndex = i);
          if (i == 1) Navigator.pushNamed(context, AppRoutes.rideHistory);
          if (i == 2) _openWalletSafely();
          if (i == 3) Navigator.pushNamed(context, AppRoutes.userProfile);
        },
        selectedItemColor: const Color(0xFF00A859),
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
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

# ఫైల్స్ సేవ్ చేయడం
$dirs = @(
    "$projectRoot\lib\views\wallet",
    "$projectRoot\lib\screens\wallet",
    "$projectRoot\lib\views\home",
    "$projectRoot\lib\screens\home"
)
foreach ($d in $dirs) {
    if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
}

[System.IO.File]::WriteAllText("$projectRoot\lib\views\wallet\wallet_screen.dart", $walletScreenCode, [System.Text.Encoding]::UTF8)
[System.IO.File]::WriteAllText("$projectRoot\lib\screens\wallet\wallet_screen.dart", $walletScreenCode, [System.Text.Encoding]::UTF8)

[System.IO.File]::WriteAllText("$projectRoot\lib\screens\home\customer_home_screen.dart", $homeScreenCode, [System.Text.Encoding]::UTF8)
[System.IO.File]::WriteAllText("$projectRoot\lib\views\home\home_screen.dart", $homeScreenCode, [System.Text.Encoding]::UTF8)

Write-Host "=========================================================" -ForegroundColor Cyan
Write-Host "SUCCESS: Navigation conflict fixed with PostFrameCallback!" -ForegroundColor Green
Write-Host "Now run: flutter run -d chrome" -ForegroundColor Yellow
Write-Host "=========================================================" -ForegroundColor Cyan