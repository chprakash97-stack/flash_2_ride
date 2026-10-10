import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';

class SafetyToolkitScreen extends StatelessWidget {
  const SafetyToolkitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Safety Toolkit & SOS')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.redAccent.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.redAccent)),
            child: const Row(
              children: [
                Icon(Icons.shield_rounded, color: Colors.redAccent, size: 36),
                SizedBox(width: 14),
                Expanded(
                  child: Text('24x7 Safety Shield is Active on every ride.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SwitchListTile(
            tileColor: AppTheme.cardBlack,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            title: const Text('Ride Audio Safety Recording', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: const Text('Encrypted background safety check', style: TextStyle(color: AppTheme.textGrey, fontSize: 12)),
            value: auth.audioSafetyEnabled,
            activeThumbColor: AppTheme.primaryGreen,
            onChanged: (v) => auth.toggleAudioSafety(v),
          ),
          const SizedBox(height: 12),
          ListTile(
            tileColor: AppTheme.cardBlack,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            leading: const Icon(Icons.emergency_share, color: AppTheme.primaryGreen),
            title: const Text('Share Live Location Link', style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios, color: AppTheme.textGrey, size: 14),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Live link ready to share.'))),
          ),
          const SizedBox(height: 12),
          ListTile(
            tileColor: AppTheme.cardBlack,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            leading: const Icon(Icons.verified_user_rounded, color: AppTheme.primaryGreen),
            title: const Text('Free Ride Insurance Policy (Acko)', style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios, color: AppTheme.textGrey, size: 14),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
