# ==========================================================
# Flash2Ride - Update ONLY Flash Wallet Screen from Poster
# ==========================================================
Write-Host "Updating Flash Wallet Screen from Poster design..." -ForegroundColor Cyan

# Complete Flash Wallet Screen code matching Section 6 of the Poster
$walletScreenCode = @'
import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {
  final dynamic data;
  const WalletScreen({super.key, this.data});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  double _balance = 250.00;

  final List<Map<String, dynamic>> _transactions = [
    {
      'title': 'Ride Payment',
      'date': '25 Aug, 10:15 AM',
      'amount': '- \u20B9145',
      'isCredit': false,
      'icon': Icons.directions_car_rounded,
      'color': Color(0xFFEF4444),
    },
    {
      'title': 'Cashback',
      'date': '25 Aug, 04:22 PM',
      'amount': '+ \u20B950',
      'isCredit': true,
      'icon': Icons.card_giftcard_rounded,
      'color': Color(0xFF10B981),
    },
    {
      'title': 'UPI Add',
      'date': '20 Aug, 11:30 AM',
      'amount': '+ \u20B9250',
      'isCredit': true,
      'icon': Icons.account_balance_wallet_rounded,
      'color': Color(0xFF2563EB),
    },
  ];

  void _addMoney(double amount) {
    setState(() {
      _balance += amount;
      _transactions.insert(0, {
        'title': 'UPI Top-up',
        'date': 'Just now',
        'amount': '+ \u20B9${amount.toStringAsFixed(0)}',
        'isCredit': true,
        'icon': Icons.add_circle_outline_rounded,
        'color': const Color(0xFF10B981),
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('\u20B9${amount.toStringAsFixed(0)} added to Flash Wallet successfully!'),
        backgroundColor: const Color(0xFF10B981),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Flash Wallet',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF2563EB),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Wallet Balance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E5BEE), Color(0xFF3B82F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Wallet Balance',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '\u20B9${_balance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Quick Recharge Buttons (+100, +250, +500)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildQuickAddChip(100),
                      const SizedBox(width: 12),
                      _buildQuickAddChip(250),
                      const SizedBox(width: 12),
                      _buildQuickAddChip(500),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Recent Transactions Header
            const Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 14),

            // Transactions Card List
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    itemCount: _transactions.length,
                    separatorBuilder: (context, index) => const Divider(height: 1, indent: 68, endIndent: 16),
                    itemBuilder: (context, index) {
                      final tx = _transactions[index];
                      final isCredit = tx['isCredit'] as bool;
                      final Color txColor = tx['color'] as Color;

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        leading: CircleAvatar(
                          radius: 22,
                          backgroundColor: txColor.withValues(alpha: 0.12),
                          child: Icon(
                            tx['icon'] as IconData,
                            color: txColor,
                            size: 22,
                          ),
                        ),
                        title: Text(
                          tx['title'] as String,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        subtitle: Text(
                          tx['date'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        trailing: Text(
                          tx['amount'] as String,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isCredit ? const Color(0xFF10B981) : const Color(0xFF1F2937),
                          ),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  // View All Button
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Showing all past wallet transactions'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      alignment: Alignment.center,
                      child: const Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAddChip(double amount) {
    return InkWell(
      onTap: () => _addMoney(amount),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1),
        ),
        child: Text(
          '+ \u20B9${amount.toStringAsFixed(0)}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
'@

# ONLY update wallet_screen files, touching NOTHING ELSE in the project
if (Test-Path "lib\screens\features") {
    Set-Content -Path "lib\screens\features\wallet_screen.dart" -Value $walletScreenCode -Encoding UTF8
    Write-Host "[OK] Updated lib\screens\features\wallet_screen.dart" -ForegroundColor Green
}
if (Test-Path "lib\views\wallet") {
    Set-Content -Path "lib\views\wallet\wallet_screen.dart" -Value $walletScreenCode -Encoding UTF8
    Write-Host "[OK] Updated lib\views\wallet\wallet_screen.dart" -ForegroundColor Green
}

Write-Host "`nRunning flutter analyze verification..." -ForegroundColor Cyan
flutter analyze