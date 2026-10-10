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
                'Enter Partner Ride Code',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ask your Flash Partner for their 4 or 6-digit ride code.',
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
