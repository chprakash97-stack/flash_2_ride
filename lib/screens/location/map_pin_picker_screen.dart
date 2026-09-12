import '../booking/ride_category_screen.dart';
import 'package:flutter/material.dart';

class MapPinPickerScreen extends StatefulWidget {
  final String initialLocation;
  const MapPinPickerScreen({super.key, this.initialLocation = 'Nellore Bus Stand, Nellore'});

  @override
  State<MapPinPickerScreen> createState() => _MapPinPickerScreenState();
}

class _MapPinPickerScreenState extends State<MapPinPickerScreen> with SingleTickerProviderStateMixin {
  late String _currentSelectedLocation;
  late AnimationController _bounceController;

  @override
  void initState() {
    super.initState();
    _currentSelectedLocation = widget.initialLocation;
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

    void _handleConfirmLocation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RideCategoryScreen(destination: _currentSelectedLocation),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Fullscreen Interactive Nellore Map Canvas
          const Positioned.fill(
            child: CustomPaint(
              painter: _InteractiveNelloreMapPainter(),
            ),
          ),

          // 2. Top Bar: Back Button & "Drag pin to set location" Tooltip (Roadmap #7)
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0058FF),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0058FF).withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Drag pin to set location',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),

                const SizedBox(width: 44),
              ],
            ),
          ),

          // 3. Center Location Pin with Subtle Float Animation (Roadmap #7)
          Center(
            child: AnimatedBuilder(
              animation: _bounceController,
              builder: (context, child) {
                final bounceOffset = _bounceController.value * -10.0;
                return Transform.translate(
                  offset: Offset(0, bounceOffset - 26),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0058FF),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.location_on_rounded,
                          color: Colors.white,
                          size: 34,
                        ),
                      ),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // 4. Floating My Location Button on right
          Positioned(
            right: 16,
            bottom: 180,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.my_location_rounded, color: Color(0xFF0058FF), size: 24),
                onPressed: () {
                  setState(() {
                    _currentSelectedLocation = 'Nellore Bus Stand, Nellore';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Re-centered to Nellore Bus Stand')),
                  );
                },
              ),
            ),
          ),

          // 5. Bottom Selected Location Card & Confirm Button (Roadmap #7)
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0058FF).withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.location_on_rounded, color: Color(0xFF0058FF), size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Selected Location',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _currentSelectedLocation,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0F172A),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0058FF),
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                      ),
                      onPressed: _handleConfirmLocation,
                      child: const Text(
                        'Confirm',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Detailed Nellore City Map Painter
class _InteractiveNelloreMapPainter extends CustomPainter {
  const _InteractiveNelloreMapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Background terrain
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), Paint()..color = const Color(0xFFF1F5F9));

    // Green Parks in Nellore
    final parkPaint = Paint()..color = const Color(0xFFDCFCE7);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.05, h * 0.15, w * 0.40, h * 0.20), const Radius.circular(20)), parkPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.55, h * 0.45, w * 0.38, h * 0.22), const Radius.circular(20)), parkPaint);

    // Penna River Flow
    final riverPaint = Paint()..color = const Color(0xFFBAE6FD)..strokeWidth = 26..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final riverPath = Path();
    riverPath.moveTo(w * 0.88, 0);
    riverPath.quadraticBezierTo(w * 0.72, h * 0.30, w * 0.95, h * 0.60);
    riverPath.quadraticBezierTo(w * 0.85, h * 0.85, w * 0.65, h);
    canvas.drawPath(riverPath, riverPaint);

    // Major Roads in Nellore
    final roadBase = Paint()..color = const Color(0xFFCBD5E1)..strokeWidth = 14..strokeCap = StrokeCap.round;
    final roadInner = Paint()..color = Colors.white..strokeWidth = 10..strokeCap = StrokeCap.round;

    // Trunk Road
    canvas.drawLine(Offset(w * 0.45, 0), Offset(w * 0.48, h), roadBase);
    canvas.drawLine(Offset(w * 0.45, 0), Offset(w * 0.48, h), roadInner);

    // Mini Bypass Curve
    final bypassPath = Path();
    bypassPath.moveTo(0, h * 0.35);
    bypassPath.quadraticBezierTo(w * 0.50, h * 0.48, w, h * 0.30);
    canvas.drawPath(bypassPath, roadBase);
    canvas.drawPath(bypassPath, roadInner);

    // Connecting street
    canvas.drawLine(Offset(w * 0.15, h * 0.65), Offset(w * 0.85, h * 0.62), roadBase);
    canvas.drawLine(Offset(w * 0.15, h * 0.65), Offset(w * 0.85, h * 0.62), roadInner);

    // Area Label: "Nellore"
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'Nellore',
        style: TextStyle(
          color: Color(0xFF0F172A),
          fontSize: 30,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset(w * 0.38, h * 0.40));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

