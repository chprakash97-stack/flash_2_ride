Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "BUILDING POSTER SECTION 6 SCREEN 2: POWER PASS..." -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan

$projectRoot = $PWD

# 1. lib\screens\features\power_pass_screen.dart ఫైల్ క్రియేట్ చేయడం
$powerPassFile = "$projectRoot\lib\screens\features\power_pass_screen.dart"
$powerPassCode = @'
import 'package:flutter/material.dart';

class PowerPassScreen extends StatefulWidget {
  final dynamic data;
  const PowerPassScreen({super.key, this.data});

  @override
  State<PowerPassScreen> createState() => _PowerPassScreenState();
}

class _PowerPassScreenState extends State<PowerPassScreen> {
  String? _activePassTitle;
  int _remainingRides = 0;

  final List<Map<String, dynamic>> _passes = [
    {
      'id': 'pass_10',
      'title': '10 Rides Pass',
      'rides': 10,
      'validity': 'Valid for 30 Days',
      'discount': 'Flat \u20B925 - \u20B950 OFF per ride',
      'price': 249,
      'originalPrice': 500,
      'isPopular': false,
    },
    {
      'id': 'pass_20',
      'title': '20 Rides Pass',
      'rides': 20,
      'validity': 'Valid for 45 Days',
      'discount': 'Flat \u20B935 - \u20B960 OFF per ride',
      'price': 399,
      'originalPrice': 1000,
      'isPopular': true,
    },
    {
      'id': 'pass_unlimited',
      'title': 'Nellore Commute Pass',
      'rides': 50,
      'validity': 'Valid for 30 Days',
      'discount': 'Zero Surge Pricing + Priority Booking',
      'price': 699,
      'originalPrice': 1500,
      'isPopular': false,
    },
  ];

  void _showPurchaseSheet(Map<String, dynamic> pass) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
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
                  Text(
                    'Activate ${pass["title"]}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(sheetContext).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                pass['discount'] as String,
                style: const TextStyle(color: Color(0xFF00A859), fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Text(
                pass['validity'] as String,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const Divider(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Amount Payable', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  Text(
                    '\u20B9${pass["price"]}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0058FF)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Icon(Icons.check_circle, color: Color(0xFF00A859), size: 16),
                  SizedBox(width: 6),
                  Text('Auto-applied on all Bike & Auto rides in Nellore', style: TextStyle(fontSize: 12, color: Colors.black87)),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0058FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    setState(() {
                      _activePassTitle = pass['title'] as String;
                      _remainingRides = pass['rides'] as int;
                    });
                    Navigator.of(sheetContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Awesome! ${pass["title"]} activated successfully!'),
                        backgroundColor: const Color(0xFF00A859),
                      ),
                    );
                  },
                  child: const Text(
                    'Confirm & Buy Pass',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Power Pass', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFF0058FF),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // హీరో బ్యానర్
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.bolt_rounded, color: Colors.amber, size: 28),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Save More, Ride More',
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Exclusive pass for Nellore daily commuters',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (_activePassTitle != null) ...[
                    const Divider(color: Colors.white24, height: 26),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00A859).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF00A859)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.verified, color: Color(0xFF00A859), size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Active: $_activePassTitle ($_remainingRides rides left)',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Available Passes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
            ),
            const SizedBox(height: 14),

            // పాస్ కార్డుల లిస్ట్
            ..._passes.map((pass) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: pass['isPopular'] ? const Color(0xFFFF9500) : const Color(0xFFE5E7EB),
                  width: pass['isPopular'] ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Column(
                  children: [
                    if (pass['isPopular'])
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        color: const Color(0xFFFF9500),
                        child: const Text(
                          '★ MOST POPULAR - BEST VALUE ★',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    pass['title'] as String,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    pass['validity'] as String,
                                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    '\u20B9${pass["originalPrice"]}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '\u20B9${pass["price"]}',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: pass['isPopular'] ? const Color(0xFFFF9500) : const Color(0xFF0058FF),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F8F0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.savings_outlined, color: Color(0xFF00A859), size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  pass['discount'] as String,
                                  style: const TextStyle(color: Color(0xFF00A859), fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: pass['isPopular'] ? const Color(0xFFFF9500) : const Color(0xFF0058FF),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () => _showPurchaseSheet(pass),
                              child: const Text(
                                'Buy Now',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),

            const SizedBox(height: 16),
            const Text(
              'Why Power Pass?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
            ),
            const SizedBox(height: 14),

            // బెనిఫిట్స్ వివరాలు
            Row(
              children: [
                _buildBenefitCard(Icons.percent_rounded, 'Discounted Fares', 'Flat savings on daily rides', const Color(0xFF0058FF)),
                const SizedBox(width: 10),
                _buildBenefitCard(Icons.flash_on_rounded, 'Priority Match', 'Quick captain arrival in Nellore', const Color(0xFFFF9500)),
                const SizedBox(width: 10),
                _buildBenefitCard(Icons.shield_outlined, 'Zero Surge', 'No extra charges in rain / rush', const Color(0xFF00A859)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitCard(IconData icon, String title, String desc, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.12),
              radius: 20,
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              desc,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
'@

[System.IO.File]::WriteAllText($powerPassFile, $powerPassCode, [System.Text.Encoding]::UTF8)
Write-Host "Created lib\screens\features\power_pass_screen.dart" -ForegroundColor Green

# 2. lib\screens\home\home_screen.dart లో Power Pass లింక్ కనెక్ట్ చేయడం
$homeFile = "$projectRoot\lib\screens\home\home_screen.dart"
if (Test-Path $homeFile) {
    $c = Get-Content $homeFile -Raw -Encoding UTF8

    # ఇంపోర్ట్ లేకపోతే జోడించడం
    if ($c -notmatch "power_pass_screen\.dart") {
        $c = "import '../features/power_pass_screen.dart';`n" + $c
    }

    $powerPassTile = @"
ListTile(
              leading: const Icon(Icons.bolt_rounded),
              title: const Text('Power Pass (Subscriptions)'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PowerPassScreen()));
              },
            ),
"@

    # Flash Wallet కింద Power Pass లేకపోతే చేర్చడం
    if ($c -notmatch "Power Pass \(Subscriptions\)") {
        $lines = $c.Split("`n")
        $out = @()
        foreach ($line in $lines) {
            $out += $line
            if ($line -match "Text\('Flash Wallet'\)") {
                $out += $powerPassTile
            }
        }
        $c = $out -join "`n"
        Write-Host "Added Power Pass (Subscriptions) to Drawer Menu!" -ForegroundColor Green
    }

    [System.IO.File]::WriteAllText($homeFile, $c, [System.Text.Encoding]::UTF8)
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "POWER PASS SCREEN READY! Press 'R' in terminal to view!" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan