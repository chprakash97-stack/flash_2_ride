import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> issues = [
      'Lost an item during ride',
      'Charged higher than estimated fare',
      'Partner refused duty / behaved rudely',
      'Safety or vehicle cleanliness issue',
      'Payment & refund status',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('24/7 Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('How can we help you?', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...issues.map((issue) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                tileColor: AppTheme.cardBlack,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                title: Text(issue, style: const TextStyle(color: Colors.white, fontSize: 14)),
                trailing: const Icon(Icons.arrow_forward_ios, color: AppTheme.textGrey, size: 14),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Support Ticket Opened for: $issue')));
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
