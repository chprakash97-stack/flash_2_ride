import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/ride_provider.dart';
import '../tracking/searching_captain_screen.dart';

class RideSelectionScreen extends StatelessWidget {
  const RideSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = Provider.of<RideProvider>(context);
    final distance = ride.destination?.distanceKm ?? 4.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(title: const Text('Confirm Ride')),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
              border: Border.all(color: AppTheme.borderGrey),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.circle, color: AppTheme.primaryGreen, size: 14),
                    const SizedBox(width: 12),
                    Expanded(child: Text(ride.pickup.address, style: const TextStyle(color: AppTheme.textBlack, fontSize: 13, fontWeight: FontWeight.w600))),
                  ],
                ),
                if (ride.stopLocation != null) ...[
                  const Divider(color: AppTheme.borderGrey, height: 16),
                  Row(
                    children: [
                      const Icon(Icons.stop_circle, color: Colors.amber, size: 14),
                      const SizedBox(width: 12),
                      Expanded(child: Text('Stop: ${ride.stopLocation!.title}', style: const TextStyle(color: AppTheme.textGrey, fontSize: 13))),
                    ],
                  ),
                ],
                const Divider(color: AppTheme.borderGrey, height: 16),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.redAccent, size: 16),
                    const SizedBox(width: 12),
                    Expanded(child: Text(ride.destination?.title ?? 'Destination', style: const TextStyle(color: AppTheme.textBlack, fontWeight: FontWeight.bold, fontSize: 14))),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: ride.availableVehicles.length,
              itemBuilder: (context, index) {
                final v = ride.availableVehicles[index];
                final fare = (v.calculateFare(distance) - ride.discount).clamp(20.0, 9999.0);
                final isSelected = v.type == ride.selectedOption?.type;

                return GestureDetector(
                  onTap: () => ride.selectVehicle(v),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryGreen.withValues(alpha: 0.08) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1))],
                      border: Border.all(color: isSelected ? AppTheme.primaryGreen : AppTheme.borderGrey, width: isSelected ? 2 : 1),
                    ),
                    child: Row(
                      children: [
                        Icon(v.icon, size: 34, color: isSelected ? AppTheme.primaryGreen : v.iconColor),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(v.title, style: const TextStyle(color: AppTheme.textBlack, fontWeight: FontWeight.bold, fontSize: 16)),
                                  const SizedBox(width: 8),
                                  if (v.type.name == 'bike')
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(color: AppTheme.primaryGreen.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                                      child: const Text('FASTEST', style: TextStyle(color: AppTheme.primaryGreen, fontSize: 10, fontWeight: FontWeight.bold)),
                                    ),
                                ],
                              ),
                              Text('${v.subtitle} â€¢ ETA ${v.eta}', style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)),
                            ],
                          ),
                        ),
                        Text('â‚¹${fare.toStringAsFixed(0)}', style: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.w900, fontSize: 20)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 16, offset: Offset(0, -3))],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.payment, color: AppTheme.primaryGreen, size: 20),
                        SizedBox(width: 8),
                        Text('Payment: Flash Wallet / Cash', style: TextStyle(color: AppTheme.textBlack, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => ride.applyCoupon('FLASH50'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: AppTheme.primaryGreen.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                        child: Text(ride.couponCode != null ? 'FLASH50 Applied' : 'Apply Coupon', style: const TextStyle(color: AppTheme.primaryGreen, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ride.startSearching();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (c) => const SearchingCaptainScreen()),
                      );
                    },
                    child: Text('Book ${ride.selectedOption?.title ?? "Ride"}', style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
