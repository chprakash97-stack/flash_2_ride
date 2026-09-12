Write-Host "Updating Choose Ride Type screen with original vehicle images from Home Screen..." -ForegroundColor Green

$projectDir = "C:\Users\DELL\Desktop\flash_2_ride"
Set-Location $projectDir

# 1. Detect exact vehicle asset paths used in home_screen.dart
$homeFile = Join-Path $projectDir "lib\screens\home\home_screen.dart"
$bikeImg = "assets/images/bike.png"
$autoImg = "assets/images/auto.png"
$cabImg = "assets/images/cab.png"
$parcelImg = "assets/images/parcel.png"

if (Test-Path $homeFile) {
    $homeContent = Get-Content -Path $homeFile -Raw -Encoding UTF8
    $matches = [System.Text.RegularExpressions.Regex]::Matches($homeContent, '["'']([^"'']*(?:bike|auto|cab|car|parcel)[^"'']*\.(?:png|jpg|jpeg|webp|svg))["'']', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    foreach ($m in $matches) {
        $val = $m.Groups.Value
        if ($val -match "bike") { $bikeImg = $val }
        if ($val -match "auto") { $autoImg = $val }
        if ($val -match "cab" -or $val -match "car") { $cabImg = $val }
        if ($val -match "parcel" -or $val -match "box") { $parcelImg = $val }
    }
}

# If not in home_screen text, check assets folder on disk
$assetFiles = Get-ChildItem -Path (Join-Path $projectDir "assets") -Recurse -File -ErrorAction SilentlyContinue
if ($assetFiles) {
    foreach ($f in $assetFiles) {
        $relPath = $f.FullName.Substring($projectDir.Length + 1).Replace("\", "/")
        if ($relPath -match "bike" -and ($bikeImg -eq "assets/images/bike.png")) { $bikeImg = $relPath }
        if ($relPath -match "auto" -and ($autoImg -eq "assets/images/auto.png")) { $autoImg = $relPath }
        if (($relPath -match "cab" -or $relPath -match "car") -and ($cabImg -eq "assets/images/cab.png")) { $cabImg = $relPath }
        if (($relPath -match "parcel" -or $relPath -match "box") -and ($parcelImg -eq "assets/images/parcel.png")) { $parcelImg = $relPath }
    }
}

Write-Host "Detected Vehicle Images:" -ForegroundColor Yellow
Write-Host " Bike   : $bikeImg" -ForegroundColor Yellow
Write-Host " Auto   : $autoImg" -ForegroundColor Yellow
Write-Host " Cab    : $cabImg" -ForegroundColor Yellow
Write-Host " Parcel : $parcelImg" -ForegroundColor Yellow

# 2. Write RideCategoryScreen with original vehicle images
$ridePath = Join-Path $projectDir "lib\screens\booking\ride_category_screen.dart"

$rideScreenCode = @"
import 'package:flutter/material.dart';
import 'schedule_ride_screen.dart';

class RideCategoryScreen extends StatefulWidget {
  final String pickupLocation;
  final String dropLocation;
  final String? destination;
  final String? pickup;
  final dynamic location;

  const RideCategoryScreen({
    super.key,
    this.pickupLocation = 'Nellore, Andhra Pradesh',
    this.dropLocation = 'Nellore Bus Stand',
    this.destination,
    this.pickup,
    this.location,
  });

  @override
  State<RideCategoryScreen> createState() => _RideCategoryScreenState();
}

class _RideCategoryScreenState extends State<RideCategoryScreen> {
  String _selectedCategory = 'Flash Auto';
  int _selectedFare = 26;

  final List<Map<String, dynamic>> _categories = const [
    {
      'id': 'Flash Bike',
      'name': 'Flash Bike',
      'fare': 8,
      'time': '2 min',
      'image': '$bikeImg',
      'fallbackIcon': Icons.two_wheeler_rounded,
    },
    {
      'id': 'Flash Auto',
      'name': 'Flash Auto',
      'fare': 26,
      'time': '4 min',
      'image': '$autoImg',
      'fallbackIcon': Icons.electric_rickshaw_rounded,
    },
    {
      'id': 'Flash Cab',
      'name': 'Flash Cab',
      'fare': 49,
      'time': '6 min',
      'image': '$cabImg',
      'fallbackIcon': Icons.local_taxi_rounded,
    },
    {
      'id': 'Flash Parcel',
      'name': 'Flash Parcel',
      'fare': 49,
      'time': '5 min',
      'image': '$parcelImg',
      'fallbackIcon': Icons.inventory_2_rounded,
    },
  ];

  void _handleBookNow() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScheduleRideScreen(
          destination: widget.destination ?? widget.dropLocation,
          rideType: _selectedCategory,
          fare: _selectedFare,
        ),
      ),
    );
  }

  Widget _buildVehicleImage(String imagePath, IconData fallbackIcon, bool isSelected) {
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        width: 44,
        height: 44,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Icon(
          fallbackIcon,
          size: 26,
          color: isSelected ? const Color(0xFF0058FF) : const Color(0xFF475569),
        ),
      );
    } else {
      return Image.asset(
        imagePath,
        width: 44,
        height: 44,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Icon(
          fallbackIcon,
          size: 26,
          color: isSelected ? const Color(0xFF0058FF) : const Color(0xFF475569),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0058FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Choose Ride Type',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFFF1F5F9),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _MapGridPainter(),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: 280,
                        height: 180,
                        child: CustomPaint(
                          painter: _RoutePainter(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 15,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _categories.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = _selectedCategory == cat['id'];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = cat['id'] as String;
                            _selectedFare = cat['fare'] as int;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF0058FF).withValues(alpha: 0.06)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF0058FF) : const Color(0xFFE2E8F0),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF0058FF).withValues(alpha: 0.08)
                                      : const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: _buildVehicleImage(
                                    cat['image'] as String,
                                    cat['fallbackIcon'] as IconData,
                                    isSelected,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cat['name'] as String,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '\u20B9${cat['fare']} \u2022 ${cat['time']} ETA',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected ? const Color(0xFF0058FF) : const Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFF0058FF) : const Color(0xFFCBD5E1),
                                    width: 2,
                                  ),
                                  color: isSelected ? const Color(0xFF0058FF) : Colors.transparent,
                                ),
                                child: isSelected
                                    ? const Center(
                                        child: Icon(Icons.circle, size: 8, color: Colors.white),
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.local_offer_rounded, color: Color(0xFF0058FF), size: 18),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Apply Coupon FLASH50',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                            ),
                          ),
                          Text(
                            'Applied',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
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
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0058FF),
                                foregroundColor: Colors.white,
                                elevation: 4,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                              ),
                              onPressed: _handleBookNow,
                              child: const Text(
                                'Book Now',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..strokeWidth = 1;

    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(20, 140)
      ..lineTo(70, 70)
      ..lineTo(160, 90)
      ..lineTo(250, 30);

    final linePaint = Paint()
      ..color = const Color(0xFF0058FF)
      ..strokeWidth = 4.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);

    final startPaint = Paint()..color = const Color(0xFF10B981);
    canvas.drawCircle(const Offset(20, 140), 7, startPaint);

    final endPaint = Paint()..color = const Color(0xFFEF4444);
    canvas.drawCircle(const Offset(250, 30), 8, endPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
"@

$rideScreenCode | Set-Content -Path $ridePath -Encoding UTF8

flutter analyze

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " Original Vehicle Images (Bike, Auto, Cab, Parcel) Successfully Integrated!  " -ForegroundColor Green
Write-Host " Press 'R' or Ctrl+R in Chrome to see the original vehicle images!            " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green