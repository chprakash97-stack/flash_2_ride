import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Flash Wallet')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(colors: [Color(0xFF00E676), Color(0xFF00B0FF)]),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Balance', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text('₹${auth.currentUser?.walletBalance.toStringAsFixed(0) ?? "0"}', style: const TextStyle(color: Colors.black, fontSize: 36, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const Text('⚡ Instant Cashback on every ride in Nellore', style: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [100, 250, 500].map((amt) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.cardBlack, foregroundColor: AppTheme.primaryGreen, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                  onPressed: () {
                    auth.updateWallet(amt.toDouble());
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added ₹$amt to Flash Wallet!')));
                  },
                  child: Text('+ ₹$amt'),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
