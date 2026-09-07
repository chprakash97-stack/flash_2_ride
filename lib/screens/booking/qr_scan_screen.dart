import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class QrScanScreen extends StatelessWidget {
  const QrScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Captain QR')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.primaryGreen, width: 3),
              ),
              child: const Icon(Icons.qr_code_scanner_rounded, size: 120, color: AppTheme.primaryGreen),
            ),
            const SizedBox(height: 24),
            const Text('Scan Flash Auto/Bike QR to Ride', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Directly board any Flash vehicle on the street', style: TextStyle(color: AppTheme.textGrey, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
