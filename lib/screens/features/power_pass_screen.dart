import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/ride_provider.dart';

class PowerPassScreen extends StatelessWidget {
  const PowerPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = Provider.of<RideProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Flash Power Pass')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: ride.passes.length,
        itemBuilder: (context, index) {
          final pass = ride.passes[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF1E1E24), Color(0xFF141416)]),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.primaryGreen, width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(pass.title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('₹${pass.price.toInt()}', style: const TextStyle(color: AppTheme.primaryGreen, fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(pass.description, style: const TextStyle(color: AppTheme.textGrey, fontSize: 13)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Validity: ${pass.validityDays} Days', style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 12)),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                      onPressed: () {
                        ride.buyPass(pass);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${pass.title} Activated!')));
                      },
                      child: const Text('Buy Pass'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
