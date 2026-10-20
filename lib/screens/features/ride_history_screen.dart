import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../theme/app_theme.dart';

class RideHistoryScreen extends StatefulWidget {
  const RideHistoryScreen({super.key});

  @override
  State<RideHistoryScreen> createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends State<RideHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // తేదీని ఫార్మాట్ చేసే ఫంక్షన్
  String _formatDate(Timestamp? timestamp) {
    if ( == null) return 'Recent';
    final date = timestamp.toDate();
    final now = DateTime.now();

    final months = [timestamp
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');

    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today, $hour:$minute $period';
    } else if (date.year == now.year && date.month == now.month && date.day == now.day - 1) {
      return 'Yesterday, $hour:$minute $period';
    }

    return '${date.day} ${months[date.month - 1]} ${date.year}, $hour:$minute $period';
  }

  // ఇన్‌వాయిస్ & రైడ్ వివరాల డైలాగ్
  void _showInvoiceDetails(BuildContext context, Map<String, dynamic> rideData, String dateStr) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardBlack,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final fare = rideData['fare'] ?? rideData['totalFare'] ?? 0;
        final paymentMethod = rideData['paymentMethod'] ?? 'Flash Wallet';
        final driverName = rideData['driverName'] ?? 'Captain';

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ride Invoice',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const Divider(color: AppTheme.borderGrey),
              const SizedBox(height: 10),
              _buildInvoiceRow('Vehicle', rideData['vehicleType'] ?? 'Flash Ride'),
              _buildInvoiceRow('Date & Time', dateStr),
              _buildInvoiceRow('Driver', driverName),
              _buildInvoiceRow('Payment Mode', paymentMethod),
              const SizedBox(height: 8),
              const Divider(color: AppTheme.borderGrey),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Fare Paid', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('₹$fare', style: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInvoiceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textGrey, fontSize: 14)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ride History')),
        body: const Center(
          child: Text(
            'Please login to view your ride history.',
            style: TextStyle(color: AppTheme.textGrey),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride History'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryGreen,
          labelColor: Colors.white,
          unselectedLabelColor: AppTheme.textGrey,
          tabs: const [
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Firestore లోని 'rides' కలెక్షన్ నుంచి కరెంట్ యూజర్ రైడ్స్‌ని తెస్తుంది
        stream: FirebaseFirestore.instance
            .collection('rides')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryGreen),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Failed to load rides: ${snapshot.error}',
                  style: const TextStyle(color: Colors.redAccent),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.directions_bike_outlined, size: 64, color: AppTheme.textGrey),
                  SizedBox(height: 16),
                  Text(
                    'No Ride History Found',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }

          final allDocs = snapshot.data!.docs;

          // కంప్లీటెడ్ మరియు క్యాన్సిల్డ్ రైడ్స్‌గా వేరు చేయడం
          final completedRides = allDocs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final status = (data['status'] ?? 'completed').toString().toLowerCase();
            return status == 'completed';
          }).toList();

          final cancelledRides = allDocs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final status = (data['status'] ?? '').toString().toLowerCase();
            return status == 'cancelled' || status == 'canceled';
          }).toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildRidesList(completedRides, isCompletedTab: true),
              _buildRidesList(cancelledRides, isCompletedTab: false),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRidesList(List<QueryDocumentSnapshot> rides, {required bool isCompletedTab}) {
    if (rides.isEmpty) {
      return Center(
        child: Text(
          isCompletedTab ? 'No completed rides yet.' : 'No cancelled rides.',
          style: const TextStyle(color: AppTheme.textGrey, fontSize: 14),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rides.length,
      itemBuilder: (context, index) {
        final rideData = rides[index].data() as Map<String, dynamic>;

        final title = rideData['vehicleType'] ?? 'Flash Ride';
        final fare = rideData['fare'] ?? rideData['totalFare'] ?? 0;
        final status = rideData['status'] ?? (isCompletedTab ? 'Completed' : 'Cancelled');
        final pickup = rideData['pickupAddress'] ?? rideData['pickup'] ?? 'Pickup location';
        final drop = rideData['dropAddress'] ?? rideData['drop'] ?? 'Drop location';
        final route = '$pickup ➔ $drop';
        final dateStr = _formatDate(rideData['createdAt'] as Timestamp?);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cardBlack,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.borderGrey),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    '₹$fare',
                    style: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(dateStr, style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isCompletedTab ? AppTheme.primaryGreen.withOpacity(0.15) : Colors.redAccent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: isCompletedTab ? AppTheme.primaryGreen : Colors.redAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                route,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (isCompletedTab) ...[
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppTheme.borderGrey),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () => _showInvoiceDetails(context, rideData, dateStr),
                        child: const Text('Invoice', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        // Rebook ride logic here
                      },
                      child: const Text('Rebook Ride', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
