import 'package:flutter/material.dart';
import '../tracking/searching_partner_screen.dart';

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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SearchingPartnerscreen(),
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
                      subtitle: 'Pay directly to Partner after ride',
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
