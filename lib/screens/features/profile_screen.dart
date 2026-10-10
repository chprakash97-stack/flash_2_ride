import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: AppTheme.primaryGreen,
            child: Icon(Icons.person, size: 48, color: Colors.black),
          ),
          const SizedBox(height: 16),
          Center(child: Text(auth.currentUser?.name ?? 'User', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))),
          Center(child: Text('+91 ${auth.currentUser?.phone ?? ""}', style: const TextStyle(color: AppTheme.textGrey))),
          const SizedBox(height: 30),
          ListTile(
            tileColor: AppTheme.cardBlack,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: const Icon(Icons.shield_outlined, color: AppTheme.primaryGreen),
            title: const Text('Emergency SOS Contact', style: TextStyle(color: Colors.white)),
            subtitle: Text(auth.currentUser?.emergencyContact ?? 'Not Set', style: const TextStyle(color: AppTheme.textGrey)),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.withValues(alpha: 0.2), foregroundColor: Colors.redAccent),
            onPressed: () {
              auth.logout();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) => const LoginScreen()), (r) => false);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
