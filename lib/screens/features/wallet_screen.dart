import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WalletScreen extends StatefulWidget {
  final dynamic data;
  const WalletScreen({super.key, this.data});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isAddingMoney = false;

  User? get _currentUser => _auth.currentUser;

  // Firestore లో మనీ యాడ్ చేయడం (Atomic Transaction)
  Future<void> _addMoney(double amount) async {
    final user = _currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in to add money.'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    setState(() => _isAddingMoney = true);

    try {
      final userDocRef = _firestore.collection('users').doc(user.uid);
      final txCollectionRef = userDocRef.collection('wallet_transactions');

      // Firestore Batch ద్వారా బ్యాలెన్స్ మరియు ట్రాన్సాక్షన్ హిస్టరీ ఒకేసారి అప్‌డేట్ అవుతాయి
      WriteBatch batch = _firestore.batch();

      // 1. వాలెట్ బ్యాలెన్స్ పెంచడం
      batch.set(
        userDocRef,
        {
          'walletBalance': FieldValue.increment(amount),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      // 2. ట్రాన్సాక్షన్ హిస్టరీలో రికార్డ్ యాడ్ చేయడం
      final newTxRef = txCollectionRef.doc();
      batch.set(newTxRef, {
        'id': newTxRef.id,
        'title': 'UPI Top-up',
        'amount': amount,
        'isCredit': true,
        'type': 'upi_add',
        'timestamp': FieldValue.serverTimestamp(),
      });

      await batch.commit();

      if (mounted) {
        setState(() => _isAddingMoney = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('₹${amount.toStringAsFixed(0)} added to Flash Wallet successfully!'),
            backgroundColor: const Color(0xFF10B981),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isAddingMoney = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add money: $e'),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // తేదీని అందంగా ఫార్మాట్ చేసే సహాయక ఫంక్షన్
  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'Just now';
    final date = timestamp.toDate();
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} mins ago';

    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');

    return '${date.day} ${months[date.month - 1]}, $hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final user = _currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Flash Wallet', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: const Color(0xFF2563EB),
        ),
        body: const Center(child: Text('User not logged in.')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Flash Wallet',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF2563EB),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Live Hero Wallet Balance Card
            StreamBuilder<DocumentSnapshot>(
              stream: _firestore.collection('users').doc(user.uid).snapshots(),
              builder: (context, snapshot) {
                double currentBalance = 0.0;
                if (snapshot.hasData && snapshot.data!.exists) {
                  final data = snapshot.data!.data() as Map<String, dynamic>?;
                  if (data != null && data['walletBalance'] != null) {
                    currentBalance = (data['walletBalance'] as num).toDouble();
                  }
                }

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E5BEE), Color(0xFF3B82F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2563EB).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Wallet Balance',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '₹${currentBalance.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Quick Recharge Buttons (+100, +250, +500)
                      _isAddingMoney
                          ? const SizedBox(
                              height: 36,
                              width: 36,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildQuickAddChip(100),
                                const SizedBox(width: 12),
                                _buildQuickAddChip(250),
                                const SizedBox(width: 12),
                                _buildQuickAddChip(500),
                              ],
                            ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 28),

            // 2. Recent Transactions Header
            const Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 14),

            // 3. Live Transactions Stream List
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('users')
                  .doc(user.uid)
                  .collection('wallet_transactions')
                  .orderBy('timestamp', descending: true)
                  .limit(15)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(color: Color(0xFF2563EB)),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Column(
                      children: const [
                        Icon(Icons.receipt_long_outlined, size: 48, color: Color(0xFF9CA3AF)),
                        SizedBox(height: 12),
                        Text(
                          'No transactions yet',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF6B7280)),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Recharge your wallet to see activity here.',
                          style: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
                        ),
                      ],
                    ),
                  );
                }

                final docs = snapshot.data!.docs;

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        itemCount: docs.length,
                        separatorBuilder: (context, index) => const Divider(height: 1, indent: 68, endIndent: 16),
                        itemBuilder: (context, index) {
                          final tx = docs[index].data() as Map<String, dynamic>;
                          final isCredit = tx['isCredit'] ?? true;
                          final double amount = (tx['amount'] as num?)?.toDouble() ?? 0.0;
                          final String title = tx['title'] ?? (isCredit ? 'Money Added' : 'Ride Payment');
                          final Timestamp? timestamp = tx['timestamp'] as Timestamp?;
                          final String dateStr = _formatTimestamp(timestamp);

                          // ఐకాన్ & కలర్ నిర్ధారణ
                          IconData iconData = Icons.account_balance_wallet_rounded;
                          Color txColor = const Color(0xFF2563EB);

                          if (!isCredit) {
                            iconData = Icons.directions_car_rounded;
                            txColor = const Color(0xFFEF4444);
                          } else if (title.toLowerCase().contains('cashback')) {
                            iconData = Icons.card_giftcard_rounded;
                            txColor = const Color(0xFF10B981);
                          } else if (title.toLowerCase().contains('top-up')) {
                            iconData = Icons.add_circle_outline_rounded;
                            txColor = const Color(0xFF10B981);
                          }

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            leading: CircleAvatar(
                              radius: 22,
                              backgroundColor: txColor.withOpacity(0.12),
                              child: Icon(iconData, color: txColor, size: 22),
                            ),
                            title: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            subtitle: Text(
                              dateStr,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            trailing: Text(
                              '${isCredit ? '+' : '-'} ₹${amount.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: isCredit ? const Color(0xFF10B981) : const Color(0xFF1F2937),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAddChip(double amount) {
    return InkWell(
      onTap: _isAddingMoney ? null : () => _addMoney(amount),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.4), width: 1),
        ),
        child: Text(
          '+ ₹${amount.toStringAsFixed(0)}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
