import 'package:flutter/material.dart';

class RideHistoryScreen extends StatefulWidget {
  final dynamic data;
  const RideHistoryScreen({super.key, this.data});

  @override
  State<RideHistoryScreen> createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends State<RideHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _completedRides = [
    {
      'id': 'F2R-89214',
      'date': '28 Aug 2026, 09:15 AM',
      'vehicle': 'Flash Auto',
      'icon': Icons.electric_rickshaw_rounded,
      'fare': '185.50',
      'pickup': 'Current Location, Magunta Layout, Nellore',
      'drop': 'Nellore Bus Stand, Trunk Road',
      'captain': 'Ramesh Babu',
      'rating': 5.0,
    },
    {
      'id': 'F2R-77301',
      'date': '26 Aug 2026, 06:40 PM',
      'vehicle': 'Flash Bike',
      'icon': Icons.two_wheeler_rounded,
      'fare': '65.00',
      'pickup': 'Nellore Railway Station, Station Road',
      'drop': 'VRC Centre, Nellore',
      'captain': 'Suresh Kumar',
      'rating': 4.8,
    },
    {
      'id': 'F2R-65120',
      'date': '24 Aug 2026, 11:20 AM',
      'vehicle': 'Flash Cab',
      'icon': Icons.local_taxi_rounded,
      'fare': '280.00',
      'pickup': 'SPSR Nellore District Court',
      'drop': 'Mini Bypass Road, Nellore',
      'captain': 'Venkatesh Rao',
      'rating': 5.0,
    },
  ];

  final List<Map<String, dynamic>> _cancelledRides = [
    {
      'id': 'F2R-54019',
      'date': '22 Aug 2026, 02:10 PM',
      'vehicle': 'Flash Auto',
      'icon': Icons.electric_rickshaw_rounded,
      'fare': '0.00',
      'pickup': 'Current Location, Dargamitta, Nellore',
      'drop': 'Narayan College, Nellore',
      'reason': 'Driver was too far away',
    },
  ];

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

  Widget _buildRideCard(Map<String, dynamic> ride, bool isCompleted) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Vehicle, Date, Fare
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: isCompleted
                        ? const Color(0xFF10B981).withOpacity(0.12)
                        : const Color(0xFFEF4444).withOpacity(0.12),
                    child: Icon(
                      ride['icon'] as IconData,
                      size: 20,
                      color: isCompleted ? const Color(0xFF059669) : const Color(0xFFDC2626),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride['vehicle'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A)),
                      ),
                      Text(
                        ride['date'] as String,
                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Rs. ${ride['fare']}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isCompleted ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      isCompleted ? 'Completed' : 'Cancelled',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isCompleted ? const Color(0xFF065F46) : const Color(0xFF991B1B),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),

          // Route: Pickup & Drop
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  const Icon(Icons.circle, color: Color(0xFF10B981), size: 12),
                  Container(width: 1.5, height: 26, color: const Color(0xFFCBD5E1)),
                  const Icon(Icons.location_on, color: Color(0xFFEF4444), size: 14),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ride['pickup'] as String,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B), fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      ride['drop'] as String,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B), fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Bottom Action Buttons matching poster
          Row(
            children: [
              if (isCompleted) ...[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Downloading Invoice Receipt for Ride ${ride['id']}...'),
                          backgroundColor: const Color(0xFF2563EB),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.receipt_long_rounded, size: 16),
                    label: const Text('Invoice', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2563EB),
                      side: const BorderSide(color: Color(0xFFBFDBFE)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Rebooking route: ${ride['pickup']} to ${ride['drop']}'),
                        backgroundColor: const Color(0xFF10B981),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: const Text('Rebook Ride', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Ride History',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF2563EB),
          unselectedLabelColor: const Color(0xFF64748B),
          indicatorColor: const Color(0xFF2563EB),
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Completed (3)'),
            Tab(text: 'Cancelled (1)'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: _completedRides.length,
            itemBuilder: (context, index) => _buildRideCard(_completedRides[index], true),
          ),
          ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: _cancelledRides.length,
            itemBuilder: (context, index) => _buildRideCard(_cancelledRides[index], false),
          ),
        ],
      ),
    );
  }
}

