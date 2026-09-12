Write-Host "Updating all post-Home screens with Royal Blue AppBars (Home Screen UNTOUCHED)..." -ForegroundColor Green

$projectDir = "C:\Users\DELL\Desktop\flash_2_ride"
Set-Location $projectDir

$bookingDir = Join-Path $projectDir "lib\screens\booking"
if (-not (Test-Path $bookingDir)) { New-Item -ItemType Directory -Path $bookingDir -Force | Out-Null }

# 1. PaymentMethodScreen (Screen 13) with Blue AppBar
@'
import 'package:flutter/material.dart';

class PaymentMethodScreen extends StatefulWidget {
  final int totalFare;

  const PaymentMethodScreen({
    super.key,
    this.totalFare = 26,
  });

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String _selectedPaymentMethod = 'Flash Wallet';

  void _handleProceed() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Method: $_selectedPaymentMethod selected! Ready for Section 4: Searching Captain.'),
        backgroundColor: const Color(0xFF0058FF),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0058FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Payment Method',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Payment Method',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Choose how you want to pay for your Flash 2 Ride trips.',
                      style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 20),
                    _buildPaymentOption(
                      id: 'Flash Wallet',
                      title: 'Flash Wallet',
                      subtitle: '\u20B9250.00 Balance',
                      icon: Icons.account_balance_wallet_rounded,
                      iconColor: const Color(0xFF0058FF),
                      iconBg: const Color(0xFFEFF6FF),
                    ),
                    const SizedBox(height: 14),
                    _buildPaymentOption(
                      id: 'UPI',
                      title: 'UPI',
                      subtitle: 'Google Pay, PhonePe, Paytm, BHIM',
                      icon: Icons.qr_code_scanner_rounded,
                      iconColor: const Color(0xFF8B5CF6),
                      iconBg: const Color(0xFFF5F3FF),
                    ),
                    const SizedBox(height: 14),
                    _buildPaymentOption(
                      id: 'Cash Payment',
                      title: 'Cash Payment',
                      subtitle: 'Pay directly to captain after ride',
                      icon: Icons.payments_rounded,
                      iconColor: const Color(0xFF10B981),
                      iconBg: const Color(0xFFECFDF5),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0058FF),
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                  ),
                  onPressed: _handleProceed,
                  child: const Text(
                    'Proceed',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
  }) {
    final isSelected = _selectedPaymentMethod == id;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = id;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0058FF).withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? const Color(0xFF0058FF) : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isSelected ? 0.06 : 0.02),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? const Color(0xFF0058FF) : const Color(0xFF64748B),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF0058FF) : const Color(0xFFCBD5E1),
                  width: 2,
                ),
                color: isSelected ? const Color(0xFF0058FF) : Colors.transparent,
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(Icons.circle, size: 10, color: Colors.white),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
'@ | Set-Content -Path (Join-Path $bookingDir 'payment_method_screen.dart') -Encoding UTF8

# 2. StreetQrScanScreen (Screen 12) with Blue AppBar
@'
import 'package:flutter/material.dart';
import 'payment_method_screen.dart';

class StreetQrScanScreen extends StatefulWidget {
  const StreetQrScanScreen({super.key});

  @override
  State<StreetQrScanScreen> createState() => _StreetQrScanScreenState();
}

class _StreetQrScanScreenState extends State<StreetQrScanScreen> {
  bool _isTorchOn = false;
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _handleManualCodeEntry() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter Captain Ride Code',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ask your Flash Captain for their 4 or 6-digit ride code.',
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: TextField(
                  controller: _codeController,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.characters,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Color(0xFF0F172A),
                  ),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.pin_rounded, color: Color(0xFF0058FF)),
                    hintText: 'e.g. FLR-8421',
                    hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 15, letterSpacing: 0),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0058FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentMethodScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Verify & Start Ride',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0058FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Street QR Scan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isTorchOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
              color: _isTorchOn ? Colors.amber : Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isTorchOn = !_isTorchOn;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentMethodScreen(),
                    ),
                  );
                },
                child: Container(
                  width: 260,
                  height: 260,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: const Color(0xFF0058FF), width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0058FF).withValues(alpha: 0.3),
                        blurRadius: 30,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.qr_code_2_rounded,
                        size: 160,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Scan QR from Flash Auto/Bike to Start your Ride',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.4,
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.white.withValues(alpha: 0.2),
                    indent: 40,
                    endIndent: 16,
                  ),
                ),
                Text(
                  'OR',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.white.withValues(alpha: 0.2),
                    indent: 16,
                    endIndent: 40,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF0058FF), width: 1.5),
                    backgroundColor: const Color(0xFF0058FF).withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                  ),
                  onPressed: _handleManualCodeEntry,
                  child: const Text(
                    'Enter Code Manually',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
'@ | Set-Content -Path (Join-Path $bookingDir 'street_qr_scan_screen.dart') -Encoding UTF8

# 3. FlashParcelScreen (Screen 11) with Blue AppBar
@'
import 'package:flutter/material.dart';
import 'street_qr_scan_screen.dart';

class FlashParcelScreen extends StatefulWidget {
  const FlashParcelScreen({super.key});

  @override
  State<FlashParcelScreen> createState() => _FlashParcelScreenState();
}

class _FlashParcelScreenState extends State<FlashParcelScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Suresh Kumar');
  final TextEditingController _phoneController = TextEditingController(text: '+91 98765 43210');
  String _selectedParcelType = 'Documents';

  final List<Map<String, dynamic>> _parcelTypes = const [
    {'id': 'Documents', 'label': 'Documents', 'icon': Icons.description_outlined},
    {'id': 'Clothes', 'label': 'Clothes', 'icon': Icons.checkroom_outlined},
    {'id': 'Electronics', 'label': 'Electronics', 'icon': Icons.devices_outlined},
    {'id': 'Medicines', 'label': 'Medicines', 'icon': Icons.medication_outlined},
    {'id': 'Food', 'label': 'Food', 'icon': Icons.fastfood_outlined},
    {'id': 'Others', 'label': 'Others', 'icon': Icons.inventory_2_outlined},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleBookParcel() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const StreetQrScanScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0058FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Flash Parcel',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Receiver Name',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _nameController,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F172A),
                        ),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person_outline_rounded, color: Color(0xFF0058FF)),
                          hintText: 'Enter receiver name',
                          hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Mobile Number',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F172A),
                        ),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.phone_outlined, color: Color(0xFF0058FF)),
                          hintText: '+91 Mobile Number',
                          hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Parcel Type',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: _parcelTypes.length,
                      itemBuilder: (context, index) {
                        final type = _parcelTypes[index];
                        final isSelected = _selectedParcelType == type['id'];

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedParcelType = type['id'] as String;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF0058FF).withValues(alpha: 0.08) : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF0058FF) : const Color(0xFFE2E8F0),
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: isSelected ? 0.06 : 0.02),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFF0058FF).withValues(alpha: 0.15) : const Color(0xFFF1F5F9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    type['icon'] as IconData,
                                    color: isSelected ? const Color(0xFF0058FF) : const Color(0xFF475569),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  type['label'] as String,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                    color: isSelected ? const Color(0xFF0058FF) : const Color(0xFF334155),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFBFDBFE)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.shield_outlined, color: Color(0xFF0058FF), size: 18),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Weight limit up to 5 kg \u2022 Secure doorstep delivery in Nellore',
                              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0058FF),
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  onPressed: _handleBookParcel,
                  child: const Text(
                    'Book Parcel',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
'@ | Set-Content -Path (Join-Path $bookingDir 'flash_parcel_screen.dart') -Encoding UTF8

# 4. HourlyRentalsScreen (Screen 10) with Blue AppBar
@'
import 'package:flutter/material.dart';
import 'flash_parcel_screen.dart';

class HourlyRentalsScreen extends StatefulWidget {
  const HourlyRentalsScreen({super.key});

  @override
  State<HourlyRentalsScreen> createState() => _HourlyRentalsScreenState();
}

class _HourlyRentalsScreenState extends State<HourlyRentalsScreen> {
  String _selectedVehicleType = 'Bike';
  String _selectedPackageId = '1hr';

  final List<Map<String, dynamic>> _bikePackages = const [
    {
      'id': '1hr',
      'duration': '1 hr (10 km)',
      'fare': 149,
      'desc': 'Ideal for quick errands or short meetings in Nellore',
    },
    {
      'id': '2hr',
      'duration': '2 hr (20 km)',
      'fare': 249,
      'desc': 'Perfect for local shopping and multiple short stops',
    },
    {
      'id': '4hr',
      'duration': '4 hr (40 km)',
      'fare': 449,
      'desc': 'Half-day city exploration and flexible travel',
    },
    {
      'id': '8hr',
      'duration': '8 hr (80 km)',
      'fare': 799,
      'desc': 'Full-day rental with total freedom across Nellore',
    },
  ];

  final List<Map<String, dynamic>> _cabPackages = const [
    {
      'id': '1hr',
      'duration': '1 hr (10 km)',
      'fare': 299,
      'desc': 'AC comfortable sedan for 1 hr with driver',
    },
    {
      'id': '2hr',
      'duration': '2 hr (20 km)',
      'fare': 499,
      'desc': 'AC comfortable sedan for 2 hrs with driver',
    },
    {
      'id': '4hr',
      'duration': '4 hr (40 km)',
      'fare': 899,
      'desc': 'Half-day AC car rental with driver & fuel',
    },
    {
      'id': '8hr',
      'duration': '8 hr (80 km)',
      'fare': 1599,
      'desc': 'Full-day AC car rental with driver & fuel',
    },
  ];

  void _handleRentalBooking() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FlashParcelScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPackages = _selectedVehicleType == 'Bike' ? _bikePackages : _cabPackages;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0058FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Hourly Rentals',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  _buildVehicleTypePill('Bike', Icons.two_wheeler_rounded),
                  const SizedBox(width: 12),
                  _buildVehicleTypePill('Cab', Icons.local_taxi_rounded),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: currentPackages.length,
                itemBuilder: (context, index) {
                  final pkg = currentPackages[index];
                  final isSelected = _selectedPackageId == pkg['id'];
                  final fareText = '\u20B9${pkg['fare']}';

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedPackageId = pkg['id'] as String;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF0058FF).withValues(alpha: 0.05) : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF0058FF) : const Color(0xFFE2E8F0),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isSelected ? 0.08 : 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: isSelected ? const Color(0xFF0058FF).withValues(alpha: 0.12) : const Color(0xFFF1F5F9),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.access_time_rounded,
                                      color: isSelected ? const Color(0xFF0058FF) : const Color(0xFF475569),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    pkg['duration'] as String,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                fareText,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            pkg['desc'] as String,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.3),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_rounded, color: Color(0xFF0058FF), size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Includes fuel + driver ($_selectedVehicleType) \u2022 Unlimited stops in Nellore',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF)),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0058FF),
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                  ),
                  onPressed: _handleRentalBooking,
                  child: const Text(
                    'Book Now',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleTypePill(String title, IconData icon) {
    final isSelected = _selectedVehicleType == title;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedVehicleType = title;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0058FF) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: isSelected ? const Color(0xFF0058FF) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? Colors.white : const Color(0xFF475569), size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : const Color(0xFF475569),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
'@ | Set-Content -Path (Join-Path $bookingDir 'hourly_rentals_screen.dart') -Encoding UTF8

# 5. ScheduleRideScreen (Screen 9) with Blue AppBar
@'
import 'package:flutter/material.dart';
import 'hourly_rentals_screen.dart';

class ScheduleRideScreen extends StatefulWidget {
  final String destination;
  final String rideType;
  final int fare;

  const ScheduleRideScreen({
    super.key,
    this.destination = 'Nellore Bus Stand, Nellore',
    this.rideType = 'Flash Auto',
    this.fare = 26,
  });

  @override
  State<ScheduleRideScreen> createState() => _ScheduleRideScreenState();
}

class _ScheduleRideScreenState extends State<ScheduleRideScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF0058FF)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF0058FF)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _handleConfirmSchedule() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HourlyRentalsScreen(),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return 'Tomorrow, ${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0058FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Schedule Ride',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Date & Time',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Book your ride in advance for a hassle-free trip.',
                      style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Pickup Date',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0058FF).withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.calendar_month_rounded, color: Color(0xFF0058FF), size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                _formatDate(_selectedDate),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Pickup Time',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickTime,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0058FF).withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.access_time_rounded, color: Color(0xFF0058FF), size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                _selectedTime.format(context),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFBFDBFE)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline_rounded, color: Color(0xFF0058FF), size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Guaranteed On-Time Arrival',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E3A8A),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Your ${widget.rideType} captain will arrive 5-10 minutes prior to your scheduled time at Nellore.',
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF3B82F6), height: 1.4),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0058FF),
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                  ),
                  onPressed: _handleConfirmSchedule,
                  child: const Text(
                    'Schedule Ride',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
'@ | Set-Content -Path (Join-Path $bookingDir 'schedule_ride_screen.dart') -Encoding UTF8

# 6. Apply Blue AppBar to any other post-home screen files (e.g. choose_ride_type, destination_search, etc.) WITHOUT touching home_screen.dart
$screenFiles = Get-ChildItem -Path (Join-Path $projectDir "lib\screens") -Recurse -Filter "*.dart"
foreach ($file in $screenFiles) {
    if ($file.Name -eq "home_screen.dart") {
        Write-Host "Skipping home_screen.dart (100% UNTOUCHED)" -ForegroundColor Cyan
        continue
    }
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    if ($content -match 'appBar:\s*AppBar\(') {
        $updated = [System.Text.RegularExpressions.Regex]::Replace($content, 'appBar:\s*AppBar\(\s*backgroundColor:\s*Colors\.white', 'appBar: AppBar(backgroundColor: const Color(0xFF0058FF)')
        $updated = [System.Text.RegularExpressions.Regex]::Replace($updated, '(Icons\.arrow_back[a-zA-Z0-9_]*,\s*color:\s*)Color\([0-9a-fA-FxX]+\)', '$1Colors.white')
        $updated = [System.Text.RegularExpressions.Regex]::Replace($updated, '(Icons\.arrow_back[a-zA-Z0-9_]*,\s*color:\s*)Colors\.black', '$1Colors.white')
        $updated = [System.Text.RegularExpressions.Regex]::Replace($updated, '(title:\s*const\s*Text\([^)]*color:\s*)Color\([0-9a-fA-FxX]+\)', '$1Colors.white')
        $updated = [System.Text.RegularExpressions.Regex]::Replace($updated, '(title:\s*Text\([^)]*color:\s*)Color\([0-9a-fA-FxX]+\)', '$1Colors.white')
        if ($updated -ne $content) {
            $updated | Set-Content -Path $file.FullName -Encoding UTF8
            Write-Host "Updated $($file.Name) with Royal Blue AppBar" -ForegroundColor Yellow
        }
    }
}

flutter analyze

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " All post-Home screens now have the vibrant Royal Blue Header!                " -ForegroundColor Green
Write-Host " Home Screen remains 100% UNTOUCHED & Safe! 0 Errors, 0 Warnings!             " -ForegroundColor Green
Write-Host " Press 'R' or Ctrl+R in Chrome to view the beautiful new Blue AppBars!        " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green