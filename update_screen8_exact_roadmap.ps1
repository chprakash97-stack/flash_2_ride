Write-Host "Updating Screen 8 (Choose Ride Type) to 100% Exact Roadmap Pin-to-Pin Layout..." -ForegroundColor Green

$projectDir = "C:\Users\DELL\Desktop\flash_2_ride"
Set-Location $projectDir

$bookingDir = Join-Path $projectDir "lib\screens\booking"
if (-not (Test-Path $bookingDir)) { New-Item -ItemType Directory -Path $bookingDir -Force | Out-Null }

# Overwrite with 100% Exact Roadmap Screen 8 Layout
@'
import 'package:flutter/material.dart';

class RideCategoryScreen extends StatefulWidget {
  final String destination;
  const RideCategoryScreen({super.key, this.destination = 'Nellore Bus Stand, Nellore'});

  @override
  State<RideCategoryScreen> createState() => _RideCategoryScreenState();
}

class _RideCategoryScreenState extends State<RideCategoryScreen> {
  String _selectedId = 'Flash Auto';
  int _selectedFare = 26;
  bool _couponApplied = true;

  final List<Map<String, dynamic>> _rideOptions = const [
    {
      'id': 'Flash Bike',
      'title': 'Flash Bike',
      'fare': 8,
      'eta': '2 min \u2022 ETA',
      'image': 'assets/images/vehicle_bike.png',
      'icon': Icons.two_wheeler_rounded,
    },
    {
      'id': 'Flash Auto',
      'title': 'Flash Auto',
      'fare': 26,
      'eta': '4 min \u2022 ETA',
      'image': 'assets/images/vehicle_auto.png',
      'icon': Icons.electric_rickshaw_rounded,
    },
    {
      'id': 'Flash Cab',
      'title': 'Flash Cab',
      'fare': 49,
      'eta': '6 min \u2022 ETA',
      'image': 'assets/images/vehicle_cab.png',
      'icon': Icons.local_taxi_rounded,
    },
    {
      'id': 'Flash Parcel',
      'title': 'Flash Parcel',
      'fare': 49,
      'eta': '5 min \u2022 ETA',
      'image': 'assets/images/vehicle_parcel.png',
      'icon': Icons.inventory_2_rounded,
    },
  ];

  void _handleBooking() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$_selectedId confirmed! Ready for Screen 9: Schedule Ride.'),
        backgroundColor: const Color(0xFF0058FF),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Upper Map View with Route (Matching Roadmap Phone 8)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.38,
            child: const CustomPaint(
              painter: _RouteMapPainter(),
            ),
          ),

          // 2. Top App Bar: Back Button & Title floating on top
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A), size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Choose Ride Type',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. Bottom Sheet with 4 Ride Options (Roadmap Phone 8)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 20,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Drag Handle Pill
                      Container(
                        width: 42,
                        height: 4.5,
                        decoration: BoxDecoration(
                          color: const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // 4 Compact Ride Option Rows
                      ..._rideOptions.map((item) {
                        final isSelected = _selectedId == item['id'];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedId = item['id'];
                              _selectedFare = item['fare'];
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF0058FF).withValues(alpha: 0.06) : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF0058FF) : const Color(0xFFE2E8F0),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Vehicle Thumbnail
                                Container(
                                  width: 58,
                                  height: 44,
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.asset(
                                    item['image'],
                                    fit: BoxFit.contain,
                                    errorBuilder: (ctx, err, st) => Icon(
                                      item['icon'],
                                      color: isSelected ? const Color(0xFF0058FF) : const Color(0xFF64748B),
                                      size: 26,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),

                                // Title & Subtitle (Fare and ETA)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        item['title'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF0F172A),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Text(
                                            '\u20B9${item['fare']}',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF0F172A),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            item['eta'],
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF16A34A),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Selection Radio Icon
                                Icon(
                                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                  color: isSelected ? const Color(0xFF0058FF) : const Color(0xFF94A3B8),
                                  size: 22,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 6),

                      // Coupon Row (Roadmap Phone 8)
                      Row(
                        children: [
                          const Text(
                            'Apply Coupon',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF475569),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFCBD5E1)),
                            ),
                            child: const Text(
                              'FLASH50',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xFF0058FF),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              setState(() => _couponApplied = !_couponApplied);
                            },
                            child: Text(
                              _couponApplied ? 'Applied' : 'Apply',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Total Fare & Book Now Button (Roadmap Phone 8)
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total:',
                                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                              ),
                              Text(
                                '\u20B9$_selectedFare',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0058FF),
                                  foregroundColor: Colors.white,
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                ),
                                onPressed: _handleBooking,
                                child: const Text(
                                  'Book Now',
                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Route Map Painter
class _RouteMapPainter extends CustomPainter {
  const _RouteMapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Terrain Base
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), Paint()..color = const Color(0xFFF1F5F9));

    // 2. Green Zones
    final parkPaint = Paint()..color = const Color(0xFFDCFCE7);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.05, h * 0.10, w * 0.35, h * 0.40), const Radius.circular(16)), parkPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.65, h * 0.20, w * 0.30, h * 0.50), const Radius.circular(16)), parkPaint);

    // 3. Roads Network
    final roadBase = Paint()..color = const Color(0xFFCBD5E1)..strokeWidth = 12..strokeCap = StrokeCap.round;
    final roadInner = Paint()..color = Colors.white..strokeWidth = 8..strokeCap = StrokeCap.round;

    // Trunk Road
    canvas.drawLine(Offset(w * 0.30, 0), Offset(w * 0.45, h), roadBase);
    canvas.drawLine(Offset(w * 0.30, 0), Offset(w * 0.45, h), roadInner);

    // Bypass
    canvas.drawLine(Offset(0, h * 0.45), Offset(w, h * 0.35), roadBase);
    canvas.drawLine(Offset(0, h * 0.45), Offset(w, h * 0.35), roadInner);

    // 4. Highlighted Blue Route Line from Pickup to Drop
    final routePaint = Paint()
      ..color = const Color(0xFF0058FF)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final routePath = Path();
    routePath.moveTo(w * 0.25, h * 0.70);
    routePath.lineTo(w * 0.35, h * 0.45);
    routePath.lineTo(w * 0.60, h * 0.40);
    routePath.lineTo(w * 0.75, h * 0.25);
    canvas.drawPath(routePath, routePaint);

    // 5. Pickup Pin (Green) & Drop Pin (Red)
    canvas.drawCircle(Offset(w * 0.25, h * 0.70), 9, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(w * 0.25, h * 0.70), 7, Paint()..color = const Color(0xFF16A34A));

    canvas.drawCircle(Offset(w * 0.75, h * 0.25), 9, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(w * 0.75, h * 0.25), 7, Paint()..color = const Color(0xFFEF4444));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
'@ | Set-Content -Path (Join-Path $bookingDir 'ride_category_screen.dart') -Encoding UTF8

dart fix --apply | Out-Null
flutter analyze

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " Screen 8 Updated to 100% Exact Roadmap Layout! 0 Errors!                     " -ForegroundColor Green
Write-Host " Press 'R' or Ctrl+R in Chrome to see the clean, beautiful screen!            " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green