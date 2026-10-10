import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  final dynamic data;
  const AboutUsScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('About Us & Legal Policy', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFF0058FF),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.flash_on_rounded, size: 60, color: Color(0xFF0058FF)),
            const SizedBox(height: 10),
            const Text('Flash2Ride', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0058FF))),
            const Text('Ride Smart \u2022 Travel Easy', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 6),
            const Text('v1.0.0 \u2022 Nellore Mobility Platform', style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
              child: Column(
                children: [
                  ListTile(title: const Text('Terms of Service'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
                  const Divider(height: 1),
                  ListTile(title: const Text('Privacy Policy'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
                  const Divider(height: 1),
                  ListTile(title: const Text('Contact Us: support@flash2ride.com'), trailing: const Icon(Icons.email_outlined), onTap: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}