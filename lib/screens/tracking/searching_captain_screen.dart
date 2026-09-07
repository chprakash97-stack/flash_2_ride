import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/ride_provider.dart';
import 'live_tracking_screen.dart';

class SearchingCaptainScreen extends StatefulWidget {
  const SearchingCaptainScreen({super.key});

  @override
  State<SearchingCaptainScreen> createState() => _SearchingCaptainScreenState();
}

class _SearchingCaptainScreenState extends State<SearchingCaptainScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ride = Provider.of<RideProvider>(context);

    if (ride.status == RideBookingStatus.accepted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const LiveTrackingScreen()));
      });
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: Tween<double>(begin: 0.85, end: 1.15).animate(_pulseController),
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryGreen.withValues(alpha: 0.15),
                  border: Border.all(color: AppTheme.primaryGreen, width: 2),
                ),
                child: const Icon(Icons.radar_rounded, size: 70, color: AppTheme.primaryGreen),
              ),
            ),
            const SizedBox(height: 30),
            const Text('Connecting to Flash Captain...', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Finding the fastest ride near your location in Nellore', style: TextStyle(color: AppTheme.textGrey, fontSize: 13)),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
              onPressed: () {
                ride.cancelRide();
                Navigator.pop(context);
              },
              child: const Text('Cancel Request'),
            ),
          ],
        ),
      ),
    );
  }
}
