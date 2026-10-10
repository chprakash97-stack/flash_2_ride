import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/ride_model.dart';

class RentalPackagesScreen extends StatelessWidget {
  const RentalPackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<RentalPackageModel> packages = [
      RentalPackageModel(id: '1', duration: '1 Hour', distance: '10 Km included', bikeFare: 99.0, autoFare: 169.0, cabFare: 299.0),
      RentalPackageModel(id: '2', duration: '2 Hours', distance: '20 Km included', bikeFare: 189.0, autoFare: 299.0, cabFare: 549.0),
      RentalPackageModel(id: '3', duration: '4 Hours', distance: '40 Km included', bikeFare: 349.0, autoFare: 549.0, cabFare: 999.0),
      RentalPackageModel(id: '4', duration: '8 Hours', distance: '80 Km included', bikeFare: 649.0, autoFare: 999.0, cabFare: 1899.0),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Hourly Rentals')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: packages.length,
        itemBuilder: (context, index) {
          final p = packages[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppTheme.cardBlack, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.borderGrey)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(p.duration, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: AppTheme.primaryGreen.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                      child: Text(p.distance, style: const TextStyle(color: AppTheme.primaryGreen, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildOption('🏍️ Bike', '₹${p.bikeFare.toInt()}', context),
                    _buildOption('🛺 Auto', '₹${p.autoFare.toInt()}', context),
                    _buildOption('🚗 Cab', '₹${p.cabFare.toInt()}', context),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOption(String name, String price, BuildContext context) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Rental $name selected at $price')));
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(color: AppTheme.backgroundBlack, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.borderGrey)),
        child: Column(
          children: [
            Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(price, style: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
