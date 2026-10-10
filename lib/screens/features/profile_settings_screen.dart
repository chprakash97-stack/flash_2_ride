import 'package:flutter/material.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final dynamic data;
  const ProfileSettingsScreen({super.key, this.data});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Profile & Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFF0058FF),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: const Row(
                children: [
                  CircleAvatar(radius: 30, backgroundColor: Color(0xFFE5EEFF), child: Icon(Icons.person, color: Color(0xFF0058FF), size: 36)),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ramesh Kumar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('+91 98765 43210', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      Text('ramesh@gmail.com', style: TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}