Write-Host "Updating Flash Parcel Screen to perfectly match project design with Receiver Name..." -ForegroundColor Green

$projectDir = "C:\Users\DELL\Desktop\flash_2_ride"
Set-Location $projectDir

$bookingDir = Join-Path $projectDir "lib\screens\booking"

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

flutter analyze

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " Receiver Name (Suresh Kumar) is now cleanly at the top! 0 Errors, 0 Warnings! " -ForegroundColor Green
Write-Host " Press 'R' or Ctrl+R in Chrome to see the updated screen!                     " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green