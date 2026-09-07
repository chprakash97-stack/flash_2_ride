import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';

class ReferEarnScreen extends StatelessWidget {
  const ReferEarnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Refer & Earn')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.card_giftcard_rounded, size: 80, color: AppTheme.primaryGreen),
            const SizedBox(height: 16),
            const Text('Invite Friends & Earn ₹50', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Share your referral code. Get ₹50 in your Flash Wallet after their first completed ride.', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textGrey, fontSize: 13)),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppTheme.cardBlack, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.primaryGreen)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(auth.currentUser?.referralCode ?? 'FLASH998', style: const TextStyle(color: AppTheme.primaryGreen, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 3)),
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, color: Colors.white),
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Referral Code Copied!'))),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening WhatsApp Share...'))),
                child: const Text('Share via WhatsApp'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
