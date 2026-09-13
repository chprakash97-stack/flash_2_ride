Write-Host "=========================================================" -ForegroundColor Cyan
Write-Host "Fixing Flash Wallet Navigation & Three-Dots Menu..." -ForegroundColor Green
Write-Host "=========================================================" -ForegroundColor Cyan

# 1. ప్రాజెక్ట్ రూట్ ఫోల్డర్ ను గుర్తిస్తుంది
$projectRoot = $PWD
if (-not (Test-Path "$projectRoot\pubspec.yaml")) {
    $parent = (Get-Item $PWD).Parent.FullName
    if (Test-Path "$parent\pubspec.yaml") {
        $projectRoot = $parent
    }
}
Write-Host "Project Directory: $projectRoot" -ForegroundColor Yellow

# 2. పూర్తి Flash Wallet స్క్రీన్ కోడ్
$walletScreenCode = @'
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/config/routes.dart';

class WalletScreen extends StatefulWidget {
  final dynamic data;
  const WalletScreen({super.key, this.data});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  double _balance = 250.00;
  final TextEditingController _amountController = TextEditingController();

  final List<Map<String, dynamic>> _transactions = [
    {
      'title': 'Daily Ride Cashback',
      'date': '12 Sep 2026, 05:30 PM',
      'amount': '+₹25.00',
      'isCredit': true,
      'type': 'Cashback',
      'icon': Icons.arrow_downward_rounded,
    },
    {
      'title': 'Paid for Auto Ride',
      'date': '12 Sep 2026, 02:15 PM',
      'amount': '-₹65.00',
      'isCredit': false,
      'type': 'Ride Payment',
      'icon': Icons.arrow_upward_rounded,
    },
    {
      'title': 'Added to Flash Wallet (UPI)',
      'date': '11 Sep 2026, 10:00 AM',
      'amount': '+₹200.00',
      'isCredit': true,
      'type': 'Top-up',
      'icon': Icons.account_balance_wallet_rounded,
    },
    {
      'title': 'Parcel Delivery Fee',
      'date': '10 Sep 2026, 06:45 PM',
      'amount': '-₹40.00',
      'isCredit': false,
      'type': 'Parcel Payment',
      'icon': Icons.inventory_2_outlined,
    },
    {
      'title': 'Welcome Bonus - Nellore Launch',
      'date': '08 Sep 2026, 09:00 AM',
      'amount': '+₹130.00',
      'isCredit': true,
      'type': 'Promo Bonus',
      'icon': Icons.card_giftcard_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _showAddMoneyBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Top-up Flash Wallet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  prefixText: '₹ ',
                  prefixStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF00A859)),
                  hintText: 'Enter amount',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF00A859), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [100, 200, 500, 1000].map((amt) {
                  return ActionChip(
                    label: Text('+₹$amt', style: const TextStyle(fontWeight: FontWeight.bold)),
                    backgroundColor: const Color(0xFFE8F8F0),
                    side: const BorderSide(color: Color(0xFF00A859)),
                    onPressed: () {
                      setState(() {
                        _amountController.text = amt.toString();
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A859),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    final entered = double.tryParse(_amountController.text);
                    if (entered != null && entered > 0) {
                      setState(() {
                        _balance += entered;
                        _transactions.insert(0, {
                          'title': 'Added to Flash Wallet (UPI)',
                          'date': 'Just Now',
                          'amount': '+₹${entered.toStringAsFixed(2)}',
                          'isCredit': true,
                          'type': 'Top-up',
                          'icon': Icons.account_balance_wallet_rounded,
                        });
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Successfully added ₹$entered to Flash Wallet!'),
                          backgroundColor: const Color(0xFF00A859),
                        ),
                      );
                    }
                  },
                  child: const Text('Proceed to Pay via UPI / Cards', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00A859), Color(0xFF007A3D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF00A859).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6)),
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
                            Text('Instant Checkout Active', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text('₹${_balance.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF00A859),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: _showAddMoneyBottomSheet,
                          icon: const Icon(Icons.add_circle_outline, size: 18),
                          label: const Text('Add Money', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white70),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Send to Bank: Minimum balance required is ₹500.00')),
                            );
                          },
                          icon: const Icon(Icons.send_rounded, size: 18),
                          label: const Text('Transfer', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xFF00A859),
                labelColor: const Color(0xFF00A859),
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(text: 'Transactions'),
                  Tab(text: 'Coupons & Offers'),
                ],
              ),
            ),
            SizedBox(
              height: 450,
              child: TabBarView(
                controller: _tabController,
                children: [
                  ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _transactions.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, idx) {
                      final tx = _transactions[idx];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 4),
                        leading: CircleAvatar(
                          backgroundColor: tx['isCredit'] ? const Color(0xFFE8F8F0) : const Color(0xFFFEE2E2),
                          child: Icon(tx['icon'], color: tx['isCredit'] ? const Color(0xFF00A859) : Colors.red, size: 20),
                        ),
                        title: Text(tx['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: Text('${tx['date']} \u2022 ${tx['type']}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        trailing: Text(
                          tx['amount'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: tx['isCredit'] ? const Color(0xFF00A859) : Colors.red,
                          ),
                        ),
                      );
                    },
                  ),
                  ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildCouponCard('FLASHRIDE50', 'Get 50% OFF up to ₹50 on first 3 Auto rides in Nellore'),
                      _buildCouponCard('NELLOREFAST', 'Flat ₹20 Cashback on Bike rides to Railway Station & VRC'),
                      _buildCouponCard('PARCELFREE', 'Free Delivery on first parcel order within 5km zone'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponCard(String code, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_offer_rounded, color: Color(0xFF00A859), size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(code, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF00A859))),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(fontSize: 12, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
'@

# 3. హోమ్ స్క్రీన్ కోడ్ (త్రీ డాట్స్ మెనూ, డ్రాయర్, బాటమ్ బార్ మరియు హోమ్ స్క్రీన్ వాలెట్ కార్డ్)
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
                _openWallet(); // నేరుగా వాలెట్ స్క్రీన్ ఓపెన్ చేస్తుంది!
              } else if (value == 'history') {
                Navigator.pushNamed(context, AppRoutes.rideHistory);
              } else if (value == 'safety') {
                Navigator.pushNamed(context, AppRoutes.safetyToolkit);
              } else if (value == 'profile') {
                Navigator.pushNamed(context, AppRoutes.userProfile);
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
              accountEmail: Text('+91 99513 82847 \u2022 Nellore'),
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
                Navigator.pushNamed(context, AppRoutes.rideHistory);
              },
            ),
            // సైడ్ మెనూ లో 3వ ఆప్షన్
            ListTile(
              leading: const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF00A859)),
              title: const Text('Flash Wallet', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00A859))),
              subtitle: const Text('Balance: \u20B9250.00'),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: const Color(0xFFE8F8F0), borderRadius: BorderRadius.circular(8)),
                child: const Text('ACTIVE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF00A859))),
              ),
              onTap: () {
                Navigator.pop(context);
                _openWallet();
              },
            ),
            ListTile(
              leading: const Icon(Icons.security_rounded, color: Color(0xFFDC2626)),
              title: const Text('Safety Toolkit & SOS'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.safetyToolkit);
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
            // హోమ్ స్క్రీన్ పైనే డైరెక్ట్ గ్రీన్ వాలెట్ బ్యానర్
            InkWell(
              onTap: _openWallet,
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

      // బాటమ్ బార్ లో 3వ ఆప్షన్ (Wallet)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() => _currentIndex = i);
          if (i == 1) Navigator.pushNamed(context, AppRoutes.rideHistory);
          if (i == 2) _openWallet();
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

# 4. ఫైల్స్ అన్నీ సేవ్ చేయడం
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
Write-Host "SUCCESS! Wallet Screen & Three-Dots Navigation Updated!" -ForegroundColor Green
Write-Host "Now run: flutter run -d chrome" -ForegroundColor Yellow
Write-Host "=========================================================" -ForegroundColor Cyan