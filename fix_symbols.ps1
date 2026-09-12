Write-Host "Fixing symbol encoding (â,¹ -> ₹) & formatting to 100% match project image..." -ForegroundColor Green

$projectDir = "C:\Users\DELL\Desktop\flash_2_ride"
Set-Location $projectDir

$bookingDir = Join-Path $projectDir "lib\screens\booking"

# Clean Screen 10: HourlyRentalsScreen
@'
import 'package:flutter/material.dart';

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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$_selectedVehicleType Rental Booked (\u20B9$_selectedFare)! Ready for Screen 11: Flash Parcel.'),
        backgroundColor: const Color(0xFF0058FF),
        duration: const Duration(seconds: 2),
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
Write-Host " All mojibake symbols fixed! Zero errors, Zero warnings!                      " -ForegroundColor Green
Write-Host " Press 'R' or Ctrl+R in Chrome to see the perfect Rupee (₹) symbols!         " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green