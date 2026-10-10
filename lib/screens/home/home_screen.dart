import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../screens/booking/ride_selection_screen.dart';
import '../../screens/booking/flash_parcel_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: const Color(0xFFE5E3DF),
              child: const Center(
                child: Text(
                  "Map View Loading...",
                  style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black87),
                    onPressed: () {},
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
                    ],
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.flash_on, color: AppColors.primary, size: 20),
                      SizedBox(width: 4),
                      Text(
                        "Flash2Ride",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.notifications_none, color: Colors.black87),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 70,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.search, color: AppColors.primary, size: 22),
                        SizedBox(width: 12),
                        Text(
                          "Where to?",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildServiceItem(
                        context,
                        title: 'Bike',
                        icon: Icons.two_wheeler,
                        color: Colors.green,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RideSelectionScreen(),
                            ),
                          );
                        },
                      ),
                      _buildServiceItem(
                        context,
                        title: 'Auto',
                        icon: Icons.electric_rickshaw,
                        color: Colors.orange,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RideSelectionScreen(),
                            ),
                          );
                        },
                      ),
                      _buildServiceItem(
                        context,
                        title: 'Cab',
                        icon: Icons.local_taxi,
                        color: Colors.blue,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RideSelectionScreen(),
                            ),
                          );
                        },
                      ),
                      _buildServiceItem(
                        context,
                        title: 'Parcel',
                        icon: Icons.local_shipping,
                        color: Colors.purple,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const FlashParcelScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildServiceItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }
}
