import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class RideHistoryScreen extends StatelessWidget {
  const RideHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Past Rides & Invoices')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildRideItem('Flash Bike', 'Yesterday, 6:30 PM', 'Magunta Layout ➔ RTC Bus Stand', '₹45', 'Completed'),
          _buildRideItem('Flash Auto', '28 Aug, 10:15 AM', 'Current Office ➔ Railway Station', '₹75', 'Completed'),
          _buildRideItem('Flash Cab', '25 Aug, 2:00 PM', 'VRC Centre ➔ Grand Trunk Rd', '₹140', 'Completed'),
        ],
      ),
    );
  }

  Widget _buildRideItem(String title, String date, String route, String fare, String status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppTheme.cardBlack, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.borderGrey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              Text(fare, style: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 4),
          Text(date, style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)),
          const SizedBox(height: 8),
          Text(route, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }
}
