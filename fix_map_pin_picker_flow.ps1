Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "LINKING MAP PIN PICKER SCREEN INTO EXACT SEQUENCE FLOW..." -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan

$projectRoot = $PWD

# -------------------------------------------------------------
# 1. Map Pin Picker Screen (Section 2 - Screen 3) ఫైల్ ను సృష్టించడం
# -------------------------------------------------------------
$mapPinFile = "$projectRoot\lib\screens\home\map_pin_picker_screen.dart"
$mapPinCode = @'
import 'package:flutter/material.dart';
import '../../core/config/routes.dart';

class MapPinPickerScreen extends StatefulWidget {
  final dynamic data;
  const MapPinPickerScreen({super.key, this.data});

  @override
  State<MapPinPickerScreen> createState() => _MapPinPickerScreenState();
}

class _MapPinPickerScreenState extends State<MapPinPickerScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  int _selectedLocationIndex = 0;

  final List<Map<String, String>> _locations = [
    {
      'title': 'Nellore Bus Stand',
      'address': 'Nellore Bus Stand, Grand Trunk Road, Nellore',
      'area': 'RTC Central Zone',
    },
    {
      'title': 'VRC Centre',
      'address': 'VRC Centre, Trunk Road, Nellore, Andhra Pradesh',
      'area': 'City Commercial Hub',
    },
    {
      'title': 'Nellore Railway Station',
      'address': 'Railway Station Road, Santhapet, Nellore',
      'area': 'Santhapet',
    },
    {
      'title': 'Current Office Centre',
      'address': 'Dargamitta, Near Current Office, Nellore',
      'area': 'Dargamitta',
    },
    {
      'title': 'Magunta Layout',
      'address': 'Main Road, Magunta Layout, Nellore',
      'area': 'Magunta Urban',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    if (widget.data is Map && widget.data['title'] != null) {
      final passedTitle = widget.data['title'].toString();
      final idx = _locations.indexWhere((l) => l['title']!.toLowerCase().contains(passedTitle.toLowerCase()));
      if (idx != -1) {
        _selectedLocationIndex = idx;
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentLocation = _locations[_selectedLocationIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text(
          'Map Pin Picker',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF0058FF),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          // ఇంటరాక్టివ్ నెల్లూరు మ్యాప్ వ్యూ
          Positioned.fill(
            child: GestureDetector(
              onTapUp: (details) {
                setState(() {
                  _selectedLocationIndex = (_selectedLocationIndex + 1) % _locations.length;
                });
              },
              child: CustomPaint(
                painter: _NelloreMapPainter(selectedIndex: _selectedLocationIndex),
              ),
            ),
          ),

          // పోస్టర్ లోని ఫ్లోటింగ్ పిల్: "Drag pin to set location"
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0058FF),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3)),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.touch_app_outlined, color: Colors.white, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Drag pin to set location',
                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // పోస్టర్ లోని సెంట్రల్ లొకేషన్ పిన్ & పల్సింగ్ టార్గెట్ సర్కిల్
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Color(0xFF5B21B6),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black38, blurRadius: 10, offset: Offset(0, 4)),
                    ],
                  ),
                  child: const Icon(Icons.location_on, color: Colors.white, size: 44),
                ),
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Container(
                      width: 24 + (_pulseController.value * 16),
                      height: 10 + (_pulseController.value * 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5B21B6).withOpacity(0.35 * (1 - _pulseController.value)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),

          // త్వరిత ల్యాండ్‌మార్క్ చిప్స్
          Positioned(
            bottom: 156,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(_locations.length, (idx) {
                  final isSelected = _selectedLocationIndex == idx;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      backgroundColor: isSelected ? const Color(0xFF0058FF) : Colors.white,
                      elevation: 2,
                      avatar: Icon(
                        Icons.location_city,
                        size: 14,
                        color: isSelected ? Colors.white : const Color(0xFF0058FF),
                      ),
                      label: Text(
                        _locations[idx]['title']!,
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF1E293B),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      onPressed: () => setState(() => _selectedLocationIndex = idx),
                    ),
                  );
                }),
              ),
            ),
          ),

          // పోస్టర్ లోని Selected Location కార్డ్ & Confirm బటన్
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, -4)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFF0058FF), size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'Selected Location',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentLocation['address']!,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0058FF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 2,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Location Confirmed: ${currentLocation['title']}'),
                            backgroundColor: const Color(0xFF00A859),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                        // ఇక్కడి Confirm నొక్కినప్పుడు మాత్రమే "చూసింగ్ రైడ్ టైప్స్" కి వెళ్లడం
                        Navigator.pushNamed(
                          context,
                          AppRoutes.rideSelection,
                          arguments: {
                            'destination': currentLocation['title'],
                            'address': currentLocation['address'],
                          },
                        );
                      },
                      child: const Text(
                        'Confirm',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
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

class _NelloreMapPainter extends CustomPainter {
  final int selectedIndex;
  _NelloreMapPainter({required this.selectedIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFE2E8F0);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final riverPaint = Paint()
      ..color = const Color(0xFFBFDBFE)
      ..strokeWidth = 28
      ..style = PaintingStyle.stroke;
    final riverPath = Path()
      ..moveTo(0, size.height * 0.15)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.22, size.width, size.height * 0.12);
    canvas.drawPath(riverPath, riverPaint);

    final parkPaint = Paint()..color = const Color(0xFFDCFCE7);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(20, size.height * 0.28, 90, 70), const Radius.circular(12)), parkPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(size.width - 120, size.height * 0.50, 100, 60), const Radius.circular(12)), parkPaint);

    final highwayBorder = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 16
      ..style = PaintingStyle.stroke;
    final highwayPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(size.width * 0.52, 0), Offset(size.width * 0.48, size.height), highwayBorder);
    canvas.drawLine(Offset(size.width * 0.52, 0), Offset(size.width * 0.48, size.height), highwayPaint);

    canvas.drawLine(Offset(0, size.height * 0.35), Offset(size.width, size.height * 0.65), highwayBorder);
    canvas.drawLine(Offset(0, size.height * 0.35), Offset(size.width, size.height * 0.65), highwayPaint);

    final secondaryRoad = Paint()
      ..color = Colors.white
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(size.width * 0.2, size.height * 0.45), Offset(size.width * 0.8, size.height * 0.45), secondaryRoad);
    canvas.drawLine(Offset(size.width * 0.3, size.height * 0.2), Offset(size.width * 0.3, size.height * 0.7), secondaryRoad);
    canvas.drawLine(Offset(size.width * 0.75, size.height * 0.25), Offset(size.width * 0.75, size.height * 0.75), secondaryRoad);
  }

  @override
  bool shouldRepaint(covariant _NelloreMapPainter oldDelegate) =>
      oldDelegate.selectedIndex != selectedIndex;
}
'@
[System.IO.File]::WriteAllText($mapPinFile, $mapPinCode, [System.Text.Encoding]::UTF8)
Write-Host "Created MapPinPickerScreen at: $mapPinFile" -ForegroundColor Green

# -------------------------------------------------------------
# 2. Location Search Screen లో డెస్టినేషన్ ఎంచుకోగానే Map Pin Picker కి వెళ్లేలా లింక్ చేయడం
# -------------------------------------------------------------
$searchFile = "$projectRoot\lib\screens\home\location_search_screen.dart"
if (Test-Path $searchFile) {
    $txt = Get-Content $searchFile -Raw -Encoding UTF8
    if ($txt -notmatch "map_pin_picker_screen\.dart") {
        $txt = "import 'map_pin_picker_screen.dart';`n" + $txt
    }
    
    # _selectDestination ఫంక్షన్ ను MapPinPickerScreen కి రీడైరెక్ట్ చేయడం
    $oldFunc = 'Navigator\.pushNamed\(context,\s*AppRoutes\.rideSelection,\s*arguments:\s*place\);'
    $newFunc = @"
Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapPinPickerScreen(
          data: {
            'title': place.title,
            'address': place.address,
          },
        ),
      ),
    );
"@
    $txt = [System.Text.RegularExpressions.Regex]::Replace($txt, $oldFunc, $newFunc)
    
    # కింద బటన్ లేకపోతే Confirm బటన్ ను యాడ్ చేయడం
    if ($txt -notmatch "child: const Text\('Confirm'\)") {
        $bottomConfirm = @"
          Expanded(
            child: ListView.separated(
"@
        $withBtn = @"
          // పోస్టర్ లోని Bottom Confirm Button (Section 2 Screen 2)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, -2))],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0058FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
                onPressed: () {
                  final sel = _filteredPlaces.isNotEmpty ? _filteredPlaces.first : _allPlaces.first;
                  _selectDestination(sel);
                },
                child: const Text('Confirm', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
"@
        # Confirm బటన్ ను లిస్ట్ కింద ఉండేలా చేయడం
        $btnPattern = '(\s*Expanded\s*\([\s\S]*?\),\s*\n)(\s*\],\s*\n\s*\),)'
        $btnInsert = @"
`$1
          // Bottom Confirm Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, -2))],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0058FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  final sel = _filteredPlaces.isNotEmpty ? _filteredPlaces.first : _allPlaces.first;
                  _selectDestination(sel);
                },
                child: const Text('Confirm', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ),
`$2
"@
        $txt = [System.Text.RegularExpressions.Regex]::Replace($txt, $btnPattern, $btnInsert)
    }
    
    [System.IO.File]::WriteAllText($searchFile, $txt, [System.Text.Encoding]::UTF8)
    Write-Host "Successfully linked Destination Search to MapPinPickerScreen in: $searchFile" -ForegroundColor Green
}

Write-Host "`nVerifying Dart Analysis..." -ForegroundColor Yellow
& flutter analyze

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "SEQUENCE RESTORED: PICKUP -> MAP PIN PICKER -> CHOOSE RIDE TYPE!" -ForegroundColor Green
Write-Host "Now Run: flutter run -d chrome" -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan