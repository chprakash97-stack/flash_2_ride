import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatefulWidget {
  final dynamic data;
  const PaymentMethodsScreen({super.key, this.data});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Payment Methods', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFF0058FF),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('UPI IDs', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
              child: const ListTile(
                leading: Icon(Icons.account_balance, color: Color(0xFF0058FF)),
                title: Text('ramesh@okhdfcbank', style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: Icon(Icons.verified, color: Color(0xFF00A859), size: 20),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Credit / Debit Cards', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
              child: const ListTile(
                leading: Icon(Icons.credit_card, color: Color(0xFFFF9500)),
                title: Text('\u2022\u2022\u2022\u2022 \u2022\u2022\u2022\u2022 \u2022\u2022\u2022\u2022 1234', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('HDFC Bank \u2022 Expires 08/29'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}