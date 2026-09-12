import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ParcelBookingScreen extends StatefulWidget {
  const ParcelBookingScreen({super.key});

  @override
  State<ParcelBookingScreen> createState() => _ParcelBookingScreenState();
}

class _ParcelBookingScreenState extends State<ParcelBookingScreen> {
  final TextEditingController _receiverName = TextEditingController();
  final TextEditingController _receiverPhone = TextEditingController();
  String _selectedCategory = 'Documents';

  final List<String> categories = ['Documents', 'Clothes', 'Food / Grocery', 'Electronics', 'Medicine'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flash Parcel Courier')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Send Packages in Nellore', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Super fast delivery within 45 minutes.', style: TextStyle(color: AppTheme.textGrey, fontSize: 13)),
            const SizedBox(height: 24),
            const Text('Receiver Details', style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(controller: _receiverName, decoration: const InputDecoration(hintText: "Receiver's Name", prefixIcon: Icon(Icons.person))),
            const SizedBox(height: 12),
            TextField(controller: _receiverPhone, keyboardType: TextInputType.phone, decoration: const InputDecoration(hintText: "Receiver's Phone Number", prefixIcon: Icon(Icons.phone))),
            const SizedBox(height: 24),
            const Text('Package Category', style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: categories.map((cat) {
                final isSel = cat == _selectedCategory;
                return ChoiceChip(
                  label: Text(cat, style: TextStyle(color: isSel ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
                  selected: isSel,
                  selectedColor: AppTheme.primaryGreen,
                  backgroundColor: AppTheme.cardBlack,
                  onSelected: (val) => setState(() => _selectedCategory = cat),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Flash Parcel Request Created! Finding Partner...')));
                  Navigator.pop(context);
                },
                child: const Text('Confirm & Send Parcel (₹39 Base)'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
