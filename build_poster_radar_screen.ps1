Write-Host "Updating Screen to exact Project Poster Model (Bike, Auto, Cab, Parcel)..." -ForegroundColor Green

$code = @'
import 'package:flutter/material.dart';

class SearchingPartnerscreen extends StatefulWidget {
  final String? vehicleType; // 'bike', 'auto', 'cab', 'parcel'
  final String? price;
  final dynamic data;

  const SearchingPartnerscreen({
    super.key,
    this.vehicleType,
    this.price,
    this.data,
  });

  @override
  State<SearchingPartnerscreen> createState() => _SearchingPartnerscreenState();
}

class _SearchingPartnerscreenState extends State<SearchingPartnerscreen> with SingleTickerProviderStateMixin {
  late AnimationController _radarController;
  String _selectedVehicle = 'auto';

  @override
  void initState() {
    super.initState();
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();

    if (widget.vehicleType != null && widget.vehicleType!.isNotEmpty) {
      _selectedVehicle = widget.vehicleType!.toLowerCase();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      final v = args['vehicleType'] ?? args['vehicle'] ?? args['type'];
      if (v != null) {
        setState(() {
          _selectedVehicle = v.toString().toLowerCase();
        });
      }
    } else if (args is String && args.isNotEmpty) {
      setState(() {
        _selectedVehicle = args.toLowerCase();
      });
    }
  }

  @override
  void dispose() {
    _radarController.dispose();
    super.dispose();
  }

  // పోస్టర్ లోని 4 కేటగిరీల డేటా (Section 3 & Section 4)
  Map<String, dynamic> _getVehicleData() {
    switch (_selectedVehicle) {
      case 'bike':
        return {
          'name': 'Flash Bike',
          'fare': '\u20B919',
          'subtitle': 'Searching for nearby bike partner...',
          'area': 'Looking for bike partner in Nellore area',
          'type': 'bike',
        };
      case 'car':
      case 'cab':
        return {
          'name': 'Flash Cab',
          'fare': '\u20B949',
          'subtitle': 'Searching for nearby cab partner...',
          'area': 'Looking for cab partner in Nellore area',
          'type': 'cab',
        };
      case 'parcel':
        return {
          'name': 'Flash Parcel',
          'fare': '\u20B935',
          'subtitle': 'Searching for nearby delivery partner...',
          'area': 'Looking for delivery partner in Nellore area',
          'type': 'parcel',
        };
      case 'auto':
      default:
        return {
          'name': 'Flash Auto',
          'fare': '\u20B926',
          'subtitle': 'Searching for nearby partner...',
          'area': 'Looking for partner in Nellore area',
          'type': 'auto',
        };
    }
  }

  // పోస్టర్ మోడల్ వెహికల్ గ్రాఫిక్
  Widget _buildPosterVehicleGraphic(String type) {
    switch (type) {
      case 'bike':
        return Container(
          width: 76,
          height: 76,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(Icons.two_wheeler_rounded, size: 50, color: Color(0xFF0066FF)),
          ),
        );
      case 'cab':
        return Container(
          width: 76,
          height: 76,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.directions_car_filled_rounded, size: 50, color: Color(0xFF0066FF)),
                Positioned(
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: const Text('CAB', style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: Colors.black)),
                  ),
                ),
              ],
            ),
          ),
        );
      case 'parcel':
        return Container(
          width: 76,
          height: 76,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(Icons.inventory_2_rounded, size: 46, color: Color(0xFF0066FF)),
          ),
        );
      case 'auto':
      default:
        return Container(
          width: 76,
          height: 76,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(Icons.electric_rickshaw, size: 50, color: Color(0xFF0066FF)),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vData = _getVehicleData();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Searching Partner',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0066FF),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // మీరు లైవ్ గా క్లిక్ చేసి చూసుకోవడానికి 4 వెహికల్ టాబ్స్
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              color: const Color(0xFFF4F7FC),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickTab('bike', 'Bike', Icons.two_wheeler_rounded),
                  _buildQuickTab('auto', 'Auto', Icons.electric_rickshaw),
                  _buildQuickTab('cab', 'Cab', Icons.directions_car_rounded),
                  _buildQuickTab('parcel', 'Parcel', Icons.inventory_2_rounded),
                ],
              ),
            ),

            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // పోస్టర్ లోని రేడార్ తరంగాలు (Concentric Radar Rings)
                    SizedBox(
                      width: 220,
                      height: 220,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 3వ బయటి తరంగం
                          AnimatedBuilder(
                            animation: _radarController,
                            builder: (context, child) {
                              final val = (_radarController.value + 0.66) % 1.0;
                              return Container(
                                width: 100 + (val * 110),
                                height: 100 + (val * 110),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF0066FF).withOpacity(0.25 * (1 - val)),
                                    width: 1.5,
                                  ),
                                ),
                              );
                            },
                          ),
                          // 2వ మధ్య తరంగం
                          AnimatedBuilder(
                            animation: _radarController,
                            builder: (context, child) {
                              final val = (_radarController.value + 0.33) % 1.0;
                              return Container(
                                width: 100 + (val * 90),
                                height: 100 + (val * 90),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF0066FF).withOpacity(0.08 * (1 - val)),
                                  border: Border.all(
                                    color: const Color(0xFF0066FF).withOpacity(0.35 * (1 - val)),
                                    width: 1.5,
                                  ),
                                ),
                              );
                            },
                          ),
                          // 1వ లోపలి తరంగం
                          AnimatedBuilder(
                            animation: _radarController,
                            builder: (context, child) {
                              final val = _radarController.value;
                              return Container(
                                width: 100 + (val * 60),
                                height: 100 + (val * 60),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF0066FF).withOpacity(0.12 * (1 - val)),
                                ),
                              );
                            },
                          ),
                          // మధ్యలోని బ్లూ రేడార్ పాడ్ + వెహికల్
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0066FF),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF0066FF).withOpacity(0.4),
                                  blurRadius: 25,
                                  spreadRadius: 4,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Center(
                              child: _buildPosterVehicleGraphic(vData['type'] as String),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // సబ్‌టైటిల్
                    Text(
                      vData['subtitle'] as String,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // లొకేషన్ వివరాలు
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on, color: Color(0xFF0066FF), size: 18),
                        const SizedBox(width: 4),
                        Text(
                          vData['area'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // బ్యాడ్జ్ (Flash Auto • ₹26)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBF3FF),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFCCE0FF)),
                      ),
                      child: Text(
                        "${vData['name']} \u2022 ${vData['fare']}",
                        style: const TextStyle(
                          color: Color(0xFF0066FF),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // పోస్టర్ లోని బాటమ్ కార్డ్
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 15,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBF3FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.shield_outlined,
                          color: Color(0xFF0066FF),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Safe & Verified Partners',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Partner details will appear as soon as accepted.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => Navigator.maybePop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Cancel Ride',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickTab(String id, String label, IconData icon) {
    final isSel = _selectedVehicle == id;
    return InkWell(
      onTap: () => setState(() => _selectedVehicle = id),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSel ? const Color(0xFF0066FF) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSel ? const Color(0xFF0066FF) : const Color(0xFFD0D7DE)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isSel ? Colors.white : Colors.black87),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSel ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

typedef SearchingPartnerScreen = SearchingPartnerscreen;
typedef SearchingCaptainScreen = SearchingPartnerscreen;
'@

# ఫైల్స్ లోకి అప్‌డేట్ చేస్తుంది
$target1 = "$PWD\lib\screens\tracking\searching_partner_screen.dart"
$target2 = "$PWD\lib\screens\tracking\searching_Partner_screen.dart"

[System.IO.File]::WriteAllText($target1, $code, [System.Text.Encoding]::UTF8)
[System.IO.File]::WriteAllText($target2, $code, [System.Text.Encoding]::UTF8)

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "SUCCESS: Screen updated to exact Poster Model!" -ForegroundColor Green
Write-Host "Now press F5 in Chrome or 'R' in CMD to view." -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan