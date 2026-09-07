import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/ride_provider.dart';
import '../home/home_screen.dart';

class LiveTrackingScreen extends StatelessWidget {
  const LiveTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = Provider.of<RideProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Flash Captain En Route'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_location_rounded, color: AppTheme.primaryGreen),
            tooltip: 'Share Trip',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Live Trip Link Copied! Share on WhatsApp.')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.shield_rounded, color: Colors.redAccent),
            onPressed: () {
              showDialog(
                context: context,
                builder: (c) => AlertDialog(
                  backgroundColor: Colors.white,
                  title: const Text('ðŸš¨ Emergency SOS Triggered', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                  content: const Text('Alert with Live GPS coordinates dispatched to Police Control & Emergency Contacts.', style: TextStyle(color: AppTheme.textBlack)),
                  actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('Dismiss', style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)))],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xFFEEF2F6),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.navigation_rounded, color: AppTheme.primaryGreen, size: 60),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
                        border: Border.all(color: AppTheme.primaryGreen),
                      ),
                      child: Text(
                        ride.status == RideBookingStatus.inTrip ? 'On the way to Destination' : 'Captain arriving in 2 mins',
                        style: const TextStyle(color: AppTheme.textBlack, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 18, offset: Offset(0, -4))],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.primaryGreen),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Start Ride PIN / OTP', style: TextStyle(color: AppTheme.textBlack, fontWeight: FontWeight.bold)),
                      Text(ride.otp, style: const TextStyle(color: AppTheme.primaryGreen, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 4)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: AppTheme.primaryGreen,
                      child: Icon(Icons.person, color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('K. Ramesh (Captain)', style: TextStyle(color: AppTheme.textBlack, fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('â­ 4.9 â€¢ Hero Splendor â€¢ AP 26 AX 4589', style: TextStyle(color: AppTheme.textGrey, fontSize: 12)),
                        ],
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.call, color: AppTheme.primaryGreen), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.chat_bubble_outline, color: AppTheme.primaryGreen), onPressed: () {}),
                  ],
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (ride.status == RideBookingStatus.accepted) {
                        ride.simulateTripProgression();
                      } else {
                        ride.resetRide();
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text('ðŸŽ‰ Trip Completed!', style: TextStyle(color: AppTheme.textBlack, fontWeight: FontWeight.bold)),
                            content: const Text('Total Fare: â‚¹65 Paid via Flash Wallet.\nThank you for riding with Flash 2 Ride!', style: TextStyle(color: AppTheme.textGrey)),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) => const HomeScreen()), (r) => false);
                                },
                                child: const Text('Done', style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: Text(ride.status == RideBookingStatus.accepted ? 'Start Ride (Verify OTP)' : 'Complete Trip & Pay', style: const TextStyle(color: Colors.white)),
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
