Write-Host "Building Poster Screen 2: Live Tracking Screen..." -ForegroundColor Green

$code = @'
import 'package:flutter/material.dart';

class LiveTrackingScreen extends StatefulWidget {
  final dynamic data;
  const LiveTrackingScreen({super.key, this.data});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Live Tracking',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0066FF),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.security_rounded, color: Colors.white),
            tooltip: 'Safety Toolkit',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Flash 2 Ride 24x7 Safety Toolkit Active')),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // 1. సిమ్యులేటెడ్ లైవ్ మ్యాప్ బ్యాక్‌గ్రౌండ్ (Simulated Live Route Map)
          Positioned.fill(
            child: Container(
              color: const Color(0xFFE8EEF5),
              child: CustomPaint(
                painter: _MapRoutePainter(pulseAnimation: _pulseController),
              ),
            ),
          ),

          // 2. టాప్ ఫ్లోటింగ్ ETA కార్డ్ (Arriving in 3 mins)
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBF3FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.access_time_filled_rounded, color: Color(0xFF0066FF), size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Arriving in 3 mins',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0066FF),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Flash 2 Partner is on the way to pickup',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F8F0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'ON TIME',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF00A859)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. బాటమ్ ఫ్లోటింగ్ పార్ట్నర్ & రైడ్ ఇన్ఫో కార్డ్
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag Handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // పార్ట్నర్ ప్రొఫైల్ రో
                  Row(
                    children: [
                      Stack(
                        children: [
                          const CircleAvatar(
                            radius: 28,
                            backgroundColor: Color(0xFFEBF3FF),
                            child: Icon(Icons.person, size: 36, color: Color(0xFF0066FF)),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Color(0xFF00A859),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.check, size: 12, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ramesh Babu',
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 15),
                                const SizedBox(width: 4),
                                const Text('4.9', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEBF3FF),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'AP 26 TX 2344',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0066FF)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            const Text('Flash Auto • Bajaj Maxima Z', style: TextStyle(fontSize: 12, color: Colors.black54)),
                          ],
                        ),
                      ),
                      // Call & Chat బటన్లు
                      IconButton(
                        onPressed: () {},
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFE8F8F0),
                          foregroundColor: const Color(0xFF00A859),
                        ),
                        icon: const Icon(Icons.phone),
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        onPressed: () {},
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFEBF3FF),
                          foregroundColor: const Color(0xFF0066FF),
                        ),
                        icon: const Icon(Icons.chat_bubble_outline),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 14),

                  // Start Ride OTP బాక్స్ (పోస్టర్ మోడల్)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F7FC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE0E6ED)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start Ride PIN / OTP',
                              style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Share with partner to start',
                              style: TextStyle(fontSize: 11, color: Colors.black38),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            _buildOtpDigit('4'),
                            const SizedBox(width: 6),
                            _buildOtpDigit('8'),
                            const SizedBox(width: 6),
                            _buildOtpDigit('2'),
                            const SizedBox(width: 6),
                            _buildOtpDigit('9'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // పికప్ & డ్రాప్ వివరాలు
                  Row(
                    children: [
                      Column(
                        children: [
                          const Icon(Icons.circle, color: Color(0xFF00A859), size: 12),
                          Container(width: 1.5, height: 24, color: Colors.grey.shade300),
                          const Icon(Icons.square, color: Colors.red, size: 12),
                        ],
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Location (VRC Centre, Nellore)',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Nellore Bus Stand, Trunk Road',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('\u20B926', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0066FF))),
                          Text('Cash', style: TextStyle(fontSize: 12, color: Colors.black54)),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // బాటమ్ బటన్లు: Share Trip & Cancel Ride
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.share_outlined, size: 18),
                          label: const Text('Share Trip'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF0066FF),
                            side: const BorderSide(color: Color(0xFF0066FF)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.maybePop(context),
                          icon: const Icon(Icons.cancel_outlined, size: 18),
                          label: const Text('Cancel Ride'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpDigit(String digit) {
    return Container(
      width: 28,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF0066FF).withOpacity(0.4)),
      ),
      child: Center(
        child: Text(
          digit,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0066FF)),
        ),
      ),
    );
  }
}

// మ్యాప్ రూట్ లైన్ మరియు వెహికల్ మూవ్‌మెంట్ పెయింటర్
class _MapRoutePainter extends CustomPainter {
  final Animation<double> pulseAnimation;
  _MapRoutePainter({required this.pulseAnimation}) : super(repaint: pulseAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    // రోడ్లు
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final roadBorder = Paint()
      ..color = const Color(0xFFD6DFE8)
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // రోడ్ గ్రిడ్
    canvas.drawLine(Offset(0, size.height * 0.25), Offset(size.width, size.height * 0.25), roadBorder);
    canvas.drawLine(Offset(0, size.height * 0.25), Offset(size.width, size.height * 0.25), roadPaint);

    canvas.drawLine(Offset(size.width * 0.3, 0), Offset(size.width * 0.3, size.height), roadBorder);
    canvas.drawLine(Offset(size.width * 0.3, 0), Offset(size.width * 0.3, size.height), roadPaint);

    canvas.drawLine(Offset(0, size.height * 0.45), Offset(size.width, size.height * 0.45), roadBorder);
    canvas.drawLine(Offset(0, size.height * 0.45), Offset(size.width, size.height * 0.45), roadPaint);

    // నీలం రంగు యాక్టివ్ రూట్ లైన్ (Active Navigation Polyline)
    final routePaint = Paint()
      ..color = const Color(0xFF0066FF)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width * 0.75, size.height * 0.18);
    path.lineTo(size.width * 0.3, size.height * 0.25);
    path.lineTo(size.width * 0.3, size.height * 0.45);
    path.lineTo(size.width * 0.55, size.height * 0.45);
    canvas.drawPath(path, routePaint);

    // యూజర్ పికప్ పిన్ (గ్రీన్ పల్స్)
    final pickupPoint = Offset(size.width * 0.55, size.height * 0.45);
    final pulseRadius = 12 + (pulseAnimation.value * 14);
    final pulsePaint = Paint()
      ..color = const Color(0xFF00A859).withOpacity(0.3 * (1 - pulseAnimation.value))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(pickupPoint, pulseRadius, pulsePaint);

    final dotPaint = Paint()..color = const Color(0xFF00A859);
    canvas.drawCircle(pickupPoint, 8, dotPaint);

    final innerDot = Paint()..color = Colors.white;
    canvas.drawCircle(pickupPoint, 3, innerDot);

    // మూవింగ్ పార్ట్నర్ మార్కర్ (Vehicle Marker on Route)
    final partnerPos = Offset(size.width * 0.3, size.height * 0.32);
    final markerPaint = Paint()
      ..color = const Color(0xFF0066FF)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(partnerPos, 16, markerPaint);

    final markerBorder = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(partnerPos, 16, markerBorder);
  }

  @override
  bool shouldRepaint(covariant _MapRoutePainter oldDelegate) => true;
}
'@

# 1. screens/tracking లో అప్‌డేట్ చేస్తుంది
$target1 = "$PWD\lib\screens\tracking\live_tracking_screen.dart"
if (Test-Path "$PWD\lib\screens\tracking") {
    [System.IO.File]::WriteAllText($target1, $code, [System.Text.Encoding]::UTF8)
    Write-Host "[OK] Updated: $target1" -ForegroundColor Green
}

# 2. screens/ride లో అప్‌డేట్ చేస్తుంది
$target2 = "$PWD\lib\screens\ride\live_tracking_screen.dart"
if (Test-Path "$PWD\lib\screens\ride") {
    [System.IO.File]::WriteAllText($target2, $code, [System.Text.Encoding]::UTF8)
    Write-Host "[OK] Updated: $target2" -ForegroundColor Green
}

# 3. views/tracking లో అప్‌డేట్ చేస్తుంది
$target3 = "$PWD\lib\views\tracking\live_ride_tracking_screen.dart"
if (Test-Path "$PWD\lib\views\tracking") {
    [System.IO.File]::WriteAllText($target3, $code, [System.Text.Encoding]::UTF8)
    Write-Host "[OK] Updated: $target3" -ForegroundColor Green
}

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "SUCCESS: Live Tracking screen updated to Poster Model!" -ForegroundColor Green
Write-Host "Now press F5 in Chrome or 'R' in CMD to view." -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan