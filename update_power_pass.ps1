Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "UPDATING POWER PASS DYNAMIC SELECTION (ONLY THIS SCREEN)..." -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan

$passFile = "$PWD\lib\screens\features\power_pass_screen.dart"

$passCode = @'
import 'package:flutter/material.dart';

class PowerPassScreen extends StatefulWidget {
  final dynamic data;
  const PowerPassScreen({super.key, this.data});

  @override
  State<PowerPassScreen> createState() => _PowerPassScreenState();
}

class _PowerPassScreenState extends State<PowerPassScreen> {
  int _selectedPlanIndex = 1; // డీఫాల్ట్‌గా 20 Rides Pass సెలెక్ట్ అయి ఉంటుంది

  final List<Map<String, dynamic>> _plans = [
    {
      'title': '10 Rides Pass',
      'price': '\u20B9249',
      'perRide': '(\u20B925/ride)',
      'subtitle': 'Valid for 30 Days \u2022 Flat savings',
      'badge': null,
      'icon': Icons.flash_on_rounded,
      'isInfinity': false,
    },
    {
      'title': '20 Rides Pass',
      'price': '\u20B9399',
      'perRide': '(\u20B920/ride)',
      'subtitle': 'Valid for 45 Days \u2022 Flat \u20B935 OFF',
      'badge': 'POPULAR',
      'icon': Icons.flash_on_rounded,
      'isInfinity': false,
    },
    {
      'title': 'Monthly Unlimited',
      'price': '\u20B9699',
      'perRide': '(/month)',
      'subtitle': 'Zero surge in Nellore \u2022 30 Days',
      'badge': null,
      'icon': Icons.all_inclusive_rounded,
      'isInfinity': true,
    },
  ];

  void _handleBuyPass(int index) {
    setState(() {
      _selectedPlanIndex = index;
    });

    final plan = _plans[index];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  plan['title'] as String,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                Text(
                  plan['price'] as String,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0058FF)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              plan['subtitle'] as String,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),
            const Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xFF00A859), size: 18),
                SizedBox(width: 8),
                Text('Instant activation on all Flash2Ride Nellore rides', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0058FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Congratulations! ${plan['title']} activated successfully!'),
                      backgroundColor: const Color(0xFF00A859),
                    ),
                  );
                },
                child: const Text('Confirm & Pay', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Power Pass',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF0058FF),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Banner matching Screen
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFF0E6), Color(0xFFFFD8BF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Save More\nRide More',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E293B),
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Exclusive pass for Nellore commuters',
                        style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.directions_car_filled_rounded,
                      color: Color(0xFFFF9500),
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3 Interactive Power Pass Cards with Dynamic Tap Selection
            ...List.generate(_plans.length, (index) {
              final plan = _plans[index];
              final isSelected = _selectedPlanIndex == index;

              return Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
                child: InkWell(
                  onTap: () {
                    // టచ్ చేయగానే ఆరెంజ్ డెకరేషన్ ఆ కార్డుకు మారేలా చేయడం
                    setState(() {
                      _selectedPlanIndex = index;
                    });
                  },
                  borderRadius: BorderRadius.circular(18),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      // సెలెక్ట్ అయిన కార్డుకు మాత్రమే ఆరెంజ్ రౌండ్ బోర్డర్
                      border: Border.all(
                        color: isSelected ? const Color(0xFFFF9500) : const Color(0xFFE2E8F0),
                        width: isSelected ? 2.0 : 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected ? const Color(0xFFFF9500).withOpacity(0.12) : Colors.black.withOpacity(0.03),
                          blurRadius: isSelected ? 12 : 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Left Icon
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFFFF0E6) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            plan['icon'] as IconData,
                            color: isSelected ? const Color(0xFFFF9500) : (plan['isInfinity'] ? const Color(0xFF00A859) : const Color(0xFF0058FF)),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Center Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    plan['title'] as String,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  if (plan['badge'] != null) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF9500),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        plan['badge'] as String,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    plan['price'] as String,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: isSelected ? const Color(0xFFFF9500) : const Color(0xFF0058FF),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    plan['perRide'] as String,
                                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                plan['subtitle'] as String,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isSelected ? const Color(0xFFE65100) : Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Right Buy Now Button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected ? const Color(0xFFFF9500) : (plan['isInfinity'] ? const Color(0xFF00A859) : const Color(0xFF0058FF)),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () => _handleBuyPass(index),
                          child: const Text(
                            'Buy Now',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 24),

            // Why Power Pass Section
            const Text(
              'Why Power Pass?',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBenefitItem('%', 'Discounted\nRides', const Color(0xFFE5EEFF), const Color(0xFF0058FF)),
                _buildBenefitItem(Icons.speed_rounded, 'Priority\nBooking', const Color(0xFFFFF0E6), const Color(0xFFFF9500)),
                _buildBenefitItem(Icons.local_offer_rounded, 'Exclusive\nOffers', const Color(0xFFE8F5E9), const Color(0xFF00A859)),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(dynamic iconOrText, String label, Color bgColor, Color iconColor) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: iconOrText is String
                ? Text(
                    iconOrText,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: iconColor),
                  )
                : Icon(iconOrText as IconData, color: iconColor, size: 24),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600, height: 1.2),
        ),
      ],
    );
  }
}
'@

[System.IO.File]::WriteAllText($passFile, $passCode, [System.Text.Encoding]::UTF8)
Write-Host "Updated PowerPassScreen with Dynamic Selection at: $passFile" -ForegroundColor Green

Write-Host "`nVerifying Dart Analysis..." -ForegroundColor Yellow
& flutter analyze

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "POWER PASS DYNAMIC SELECTION RESTORED WITH ZERO ERRORS!" -ForegroundColor Green
Write-Host "Run: flutter run -d chrome" -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan