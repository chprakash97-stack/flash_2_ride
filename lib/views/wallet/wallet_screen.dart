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
      'amount': '- â‚¹145',
      'isCredit': false,
      'icon': Icons.directions_car_rounded,
      'color': const Color(0xFFEF4444),
    },
    {
      'title': 'Cashback',
      'date': '25 Aug, 04:22 PM',
      'amount': '+ â‚¹50',
      'isCredit': true,
      'icon': Icons.card_giftcard_rounded,
      'color': const Color(0xFF10B981),
    },
    {
      'title': 'UPI Add',
      'date': '20 Aug, 11:30 AM',
      'amount': '+ â‚¹250',
      'isCredit': true,
      'icon': Icons.account_balance_wallet_rounded,
      'color': const Color(0xFF2563EB),
    },
  ];

  void _addMoney(double amount) {
    setState(() {
      _balance += amount;
      _transactions.insert(0, {
        'title': 'UPI Top-up',
        'date': 'Just now',
        'amount': '+ â‚¹${amount.toStringAsFixed(0)}',
        'isCredit': true,
        'icon': Icons.add_circle_outline_rounded,
        'color': const Color(0xFF10B981),
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('â‚¹${amount.toStringAsFixed(0)} added to Flash Wallet successfully!'),
        backgroundColor: const Color(0xFF10B981),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // 1. Poster-Accurate Solid Blue Curved Header (Section 6)
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E5BEE), Color(0xFF2563EB)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x332563EB),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  children: [
                    // Top Navigation Row
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Flash Wallet',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Wallet Balance Label
                    const Text(
                      'Wallet Balance',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Large Bold Balance Amount
                    Text(
                      'â‚¹${_balance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Quick Top-up Chips (+100, +250, +500)
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
            ),
          ),

          // 2. Recent Transactions Section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + View All Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Transactions',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Showing all past wallet transactions'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Transactions Card List
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x08000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: _transactions.length,
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        indent: 68,
                        endIndent: 16,
                        color: Color(0xFFF3F4F6),
                      ),
                      itemBuilder: (context, index) {
                        final tx = _transactions[index];
                        final isCredit = tx['isCredit'] as bool;
                        final Color txColor = tx['color'] as Color;

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          leading: CircleAvatar(
                            radius: 22,
                            backgroundColor: txColor.withOpacity(0.12),
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
                              color: isCredit ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.4), width: 1),
        ),
        child: Text(
          '+ â‚¹${amount.toStringAsFixed(0)}',
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