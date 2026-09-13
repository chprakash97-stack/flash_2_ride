Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "UPDATING POWER PASS TO EXACT POSTER DESIGN & FIXING TEXT..." -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan

$projectRoot = $PWD

$powerPassFile = "$projectRoot\lib\screens\features\power_pass_screen.dart"
$posterPowerPassCode = @'
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

  void _activatePass(String title, int rides, int price) {
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
                  Text('Activate $title', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(sheetContext).pop()),
                ],
              ),
              const SizedBox(height: 12),
              const Text('Includes Nellore City zone flat savings on every ride', style: TextStyle(color: Color(0xFF00A859), fontWeight: FontWeight.w600, fontSize: 13)),
              const Divider(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Amount', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  Text('\u20B9$price', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF0058FF))),
                ],
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Icon(Icons.check_circle, color: Color(0xFF00A859), size: 16),
                  SizedBox(width: 6),
                  Text('Auto-applied on Bike & Auto rides', style: TextStyle(fontSize: 12, color: Colors.black87)),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0058FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    setState(() {
                      _activePassTitle = title;
                      _remainingRides = rides;
                    });
                    Navigator.of(sheetContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Awesome! $title activated successfully!'),
                        backgroundColor: const Color(0xFF00A859),
                      ),
                    );
                  },
                  child: const Text('Confirm & Pay', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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
            // పోస్టర్ లో ఉన్నట్లే లైట్ ఆరెంజ్ వార్మ్ హీరో కార్డ్
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFF7ED), Color(0xFFFED7AA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFFEDD5)),
                boxShadow: [
                  BoxShadow(color: Colors.orange.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Save More', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E293B), height: 1.15)),
                      const Text('Ride More', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF0058FF), height: 1.15)),
                      const SizedBox(height: 6),
                      const Text('Exclusive pass for Nellore commuters', style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.orange.withOpacity(0.2), blurRadius: 8),
                      ],
                    ),
                    child: const Icon(Icons.local_taxi_rounded, color: Color(0xFFFF9500), size: 38),
                  ),
                ],
              ),
            ),

            if (_activePassTitle != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F8F0),
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
                        style: const TextStyle(color: Color(0xFF00A859), fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            // పాస్ కార్డ్ 1: 10 Rides Pass (₹249)
            _buildPassCard(
              icon: Icons.bolt_rounded,
              iconColor: const Color(0xFF0058FF),
              iconBg: const Color(0xFFEFF6FF),
              title: '10 Rides Pass',
              price: '\u20B9249',
              perRide: '(\u20B925/ride)',
              validity: 'Valid for 30 Days \u2022 Flat savings',
              btnColor: const Color(0xFF0058FF),
              isPopular: false,
              onTap: () => _activatePass('10 Rides Pass', 10, 249),
            ),

            const SizedBox(height: 12),

            // పాస్ కార్డ్ 2: 20 Rides Pass (₹399) - పోస్టర్ మోస్ట్ పాపులర్
            _buildPassCard(
              icon: Icons.bolt_rounded,
              iconColor: const Color(0xFFFF9500),
              iconBg: const Color(0xFFFFF7ED),
              title: '20 Rides Pass',
              price: '\u20B9399',
              perRide: '(\u20B920/ride)',
              validity: 'Valid for 45 Days \u2022 Flat \u20B935 OFF',
              btnColor: const Color(0xFFFF9500),
              isPopular: true,
              onTap: () => _activatePass('20 Rides Pass', 20, 399),
            ),

            const SizedBox(height: 12),

            // పాస్ కార్డ్ 3: Monthly Unlimited Pass (₹699)
            _buildPassCard(
              icon: Icons.all_inclusive_rounded,
              iconColor: const Color(0xFF00A859),
              iconBg: const Color(0xFFE8F8F0),
              title: 'Monthly Unlimited',
              price: '\u20B9699',
              perRide: '(/month)',
              validity: 'Zero surge in Nellore \u2022 30 Days',
              btnColor: const Color(0xFF00A859),
              isPopular: false,
              onTap: () => _activatePass('Monthly Unlimited Pass', 99, 699),
            ),

            const SizedBox(height: 24),
            const Text(
              'Why Power Pass?',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 14),

            // పోస్టర్ లో ఉన్నట్లే 3 రౌండ్ ఐకాన్స్
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWhyItem(Icons.percent_rounded, 'Discounted\nRides', const Color(0xFF0058FF)),
                _buildWhyItem(Icons.near_me_rounded, 'Priority\nBooking', const Color(0xFFFF9500)),
                _buildWhyItem(Icons.card_giftcard_rounded, 'Exclusive\nOffers', const Color(0xFF00A859)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String price,
    required String perRide,
    required String validity,
    required Color btnColor,
    required bool isPopular,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPopular ? const Color(0xFFFF9500) : const Color(0xFFE2E8F0),
          width: isPopular ? 1.8 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isPopular ? const Color(0xFFFF9500).withOpacity(0.08) : Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                    if (isPopular) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(color: const Color(0xFFFF9500), borderRadius: BorderRadius.circular(4)),
                        child: const Text('POPULAR', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(price, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: btnColor)),
                    const SizedBox(width: 6),
                    Text(perRide, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(validity, style: const TextStyle(fontSize: 10.5, color: Color(0xFF00A859), fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: btnColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              minimumSize: const Size(70, 36),
            ),
            onPressed: onTap,
            child: const Text('Buy Now', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildWhyItem(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Color(0xFF334155), height: 1.2),
        ),
      ],
    );
  }
}
'@

[System.IO.File]::WriteAllText($powerPassFile, $posterPowerPassCode, [System.Text.Encoding]::UTF8)
Write-Host "Updated lib\screens\features\power_pass_screen.dart to 1:1 Poster Match!" -ForegroundColor Green

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "SUCCESS! Press 'R' in flutter run terminal to refresh." -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan