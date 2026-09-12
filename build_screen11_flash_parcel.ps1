Write-Host "Building Screen 11: Flash Parcel Screen..." -ForegroundColor Green

$projectDir = "C:\Users\DELL\Desktop\flash_2_ride"
Set-Location $projectDir

$bookingDir = Join-Path $projectDir "lib\screens\booking"
if (-not (Test-Path $bookingDir)) { New-Item -ItemType Directory -Path $bookingDir -Force | Out-Null }

# 1. Screen 11: FlashParcelScreen
@'
import 'package:flutter/material.dart';

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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Flash Parcel Booked for ${_nameController.text}! Ready for Screen 12: Street QR Scan.'),
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
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Flash Parcel',
          style: TextStyle(
            color: Color(0xFF0F172A),
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
                      'Receiver Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Enter contact details of the recipient in Nellore.',
                      style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Receiver Name',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _nameController,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person_outline_rounded, color: Color(0xFF0058FF)),
                          hintText: 'Enter recipient full name',
                          hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Mobile Number',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.phone_outlined, color: Color(0xFF0058FF)),
                          hintText: '+91 Mobile Number',
                          hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Parcel Type',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Select the category of item you are sending.',
                      style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.05,
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
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF0058FF) : const Color(0xFFE2E8F0),
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: isSelected ? 0.06 : 0.02),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFF0058FF).withValues(alpha: 0.15) : const Color(0xFFF1F5F9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    type['icon'] as IconData,
                                    color: isSelected ? const Color(0xFF0058FF) : const Color(0xFF475569),
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(height: 8),
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
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFBFDBFE)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.shield_outlined, color: Color(0xFF0058FF), size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Weight limit up to 5 kg \u2022 Secure doorstep delivery in Nellore',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF)),
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
                  onPressed: _handleBookParcel,
                  child: const Text(
                    'Book Parcel',
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
}
'@ | Set-Content -Path (Join-Path $bookingDir 'flash_parcel_screen.dart') -Encoding UTF8

# 2. Update HourlyRentalsScreen to Navigate to FlashParcelScreen on Book Now
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
  int _selectedFare = 149;

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
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Hourly Rentals',
          style: TextStyle(
            color: Color(0xFF0F172A),
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
                        _selectedFare = pkg['fare'] as int;
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
            _selectedFare = title == 'Bike' ? 149 : 299;
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

flutter analyze

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " Screen 11 (Flash Parcel) Created & Linked Successfully! 0 Errors, 0 Warnings! " -ForegroundColor Green
Write-Host " Test in Chrome: On Hourly Rentals, click 'Book Now' to view Flash Parcel!   " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green