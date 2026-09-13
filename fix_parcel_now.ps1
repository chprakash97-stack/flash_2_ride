Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "FIXING CLASS NAMES IN FLASH PARCEL & PARCEL BOOKING..." -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan

$projectRoot = $PWD

# 1. lib\screens\booking\flash_parcel_screen.dart సరిచేయడం
$file1 = "$projectRoot\lib\screens\booking\flash_parcel_screen.dart"
$code1 = @'
import 'package:flutter/material.dart';

class FlashParcelScreen extends StatefulWidget {
  final dynamic data;
  const FlashParcelScreen({super.key, this.data});

  @override
  State<FlashParcelScreen> createState() => _FlashParcelScreenState();
}

class _FlashParcelScreenState extends State<FlashParcelScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Suresh Kumar');
  final TextEditingController _phoneController = TextEditingController(text: '+91 98765 43210');
  String _selectedType = 'Documents';

  final List<Map<String, dynamic>> _parcelTypes = [
    {
      'title': 'Documents',
      'icon': Icons.description_rounded,
      'color': const Color(0xFF0058FF),
      'bgColor': const Color(0xFFEFF6FF),
    },
    {
      'title': 'Clothes',
      'icon': Icons.checkroom_rounded,
      'color': const Color(0xFF8B5CF6),
      'bgColor': const Color(0xFFF5F3FF),
    },
    {
      'title': 'Electronics',
      'icon': Icons.devices_other_rounded,
      'color': const Color(0xFFFF9500),
      'bgColor': const Color(0xFFFFF7ED),
    },
    {
      'title': 'Medicines',
      'icon': Icons.medical_services_rounded,
      'color': const Color(0xFF00A859),
      'bgColor': const Color(0xFFE8F8F0),
    },
    {
      'title': 'Food',
      'icon': Icons.restaurant_rounded,
      'color': const Color(0xFFEF4444),
      'bgColor': const Color(0xFFFEF2F2),
    },
    {
      'title': 'Others',
      'icon': Icons.inventory_2_rounded,
      'color': const Color(0xFF6366F1),
      'bgColor': const Color(0xFFEEF2FF),
    },
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Flash Parcel',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF0058FF),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Receiver Name',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFF1E293B)),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF0058FF)),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFF0058FF), width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Mobile Number',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFF1E293B)),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.phone_outlined, color: Color(0xFF0058FF)),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFF0058FF), width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'Parcel Type',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.95,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: _parcelTypes.length,
                      itemBuilder: (context, index) {
                        final item = _parcelTypes[index];
                        final isSelected = _selectedType == item['title'];
                        final Color color = item['color'] as Color;
                        final Color bgColor = item['bgColor'] as Color;

                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedType = item['title'] as String;
                            });
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isSelected ? bgColor.withOpacity(0.45) : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? color : const Color(0xFFE2E8F0),
                                width: isSelected ? 2.0 : 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isSelected ? color.withOpacity(0.15) : Colors.black.withOpacity(0.02),
                                  blurRadius: isSelected ? 8 : 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: bgColor,
                                      radius: 24,
                                      child: Icon(item['icon'] as IconData, color: color, size: 24),
                                    ),
                                    if (isSelected)
                                      Positioned(
                                        top: -2,
                                        right: -2,
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                                          child: const Icon(Icons.check, color: Colors.white, size: 10),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item['title'] as String,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                    color: isSelected ? color : const Color(0xFF1E293B),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                              'Weight limit up to 5 kg • Secure doorstep delivery in Nellore',
                              style: TextStyle(fontSize: 11, color: Color(0xFF1E40AF), fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0058FF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Flash Parcel order placed for $_selectedType to ${_nameController.text}!'),
                        backgroundColor: const Color(0xFF00A859),
                      ),
                    );
                  },
                  child: const Text(
                    'Book Parcel',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
'@

[System.IO.File]::WriteAllText($file1, $code1, [System.Text.Encoding]::UTF8)
Write-Host "Updated FlashParcelScreen in $file1" -ForegroundColor Green

# 2. lib\screens\booking\parcel_booking_screen.dart సరిచేయడం
$file2 = "$projectRoot\lib\screens\booking\parcel_booking_screen.dart"
if (Test-Path $file2) {
    $code2 = @'
import 'package:flutter/material.dart';
import 'flash_parcel_screen.dart';

class ParcelBookingScreen extends StatelessWidget {
  final dynamic data;
  const ParcelBookingScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return FlashParcelScreen(data: data);
  }
}
'@
    [System.IO.File]::WriteAllText($file2, $code2, [System.Text.Encoding]::UTF8)
    Write-Host "Updated ParcelBookingScreen in $file2" -ForegroundColor Green
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "ERRORS FIXED! Run: flutter run -d chrome" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan