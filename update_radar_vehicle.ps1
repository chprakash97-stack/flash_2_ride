Write-Host "Updating Radar Vehicle Screen with Bike, Auto, Car & Parcel support..." -ForegroundColor Green

$code = @'
import 'package:flutter/material.dart';

class SearchingPartnerscreen extends StatefulWidget {
  final String? vehicleType; // 'bike', 'auto', 'car', 'parcel'
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
  late AnimationController _pulseController;
  String _selectedVehicle = 'auto'; // Default: auto
  String _fare = '₹26';

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // హోమ్ స్క్రీన్ నుండి వచ్చిన డేటాను సెట్ చేస్తుంది
    if (widget.vehicleType != null) {
      _selectedVehicle = widget.vehicleType!.toLowerCase();
    }
    if (widget.price != null) {
      _fare = widget.price!;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Route arguments ద్వారా వచ్చిన వెహికల్ డేటాను రీడ్ చేస్తుంది
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      if (args['vehicleType'] != null) {
        setState(() {
          _selectedVehicle = args['vehicleType'].toString().toLowerCase();
          if (args['price'] != null) _fare = args['price'].toString();
        });
      } else if (args['vehicle'] != null) {
        setState(() {
          _selectedVehicle = args['vehicle'].toString().toLowerCase();
        });
      }
    } else if (args is String) {
      setState(() {
        _selectedVehicle = args.toLowerCase();
      });
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  // వెహికల్ వివరాలు (పేరు, ధర, ఐకాన్, అసెట్ పాత్)
  Map<String, dynamic> _getVehicleInfo() {
    switch (_selectedVehicle) {
      case 'bike':
        return {
          'title': 'Flash Bike',
          'fare': _fare == '₹26' ? '₹19' : _fare,
          'icon': Icons.two_wheeler_rounded,
          'assetPath': 'assets/images/bike.png',
          'subText': 'Searching for nearby bike partner...',
          'areaText': 'Looking for bike partner in Nellore area',
        };
      case 'car':
      case 'cab':
        return {
          'title': 'Flash Car',
          'fare': _fare == '₹26' ? '₹49' : _fare,
          'icon': Icons.directions_car_rounded,
          'assetPath': 'assets/images/car.png',
          'subText': 'Searching for nearby car partner...',
          'areaText': 'Looking for car partner in Nellore area',
        };
      case 'parcel':
        return {
          'title': 'Flash Parcel',
          'fare': _fare == '₹26' ? '₹35' : _fare,
          'icon': Icons.inventory_2_rounded,
          'assetPath': 'assets/images/parcel.png',
          'subText': 'Searching for nearby delivery partner...',
          'areaText': 'Looking for delivery partner in Nellore area',
        };
      case 'auto':
      default:
        return {
          'title': 'Flash Auto',
          'fare': _fare,
          'icon': Icons.electric_rickshaw,
          'assetPath': 'assets/images/auto.png',
          'subText': 'Searching for nearby partner...',
          'areaText': 'Looking for partner in Nellore area',
        };
    }
  }

  // ఒరిజినల్ ఇమేజ్ ఉంటే అది చూపిస్తుంది, లేకపోతే వెక్టర్ ఐకాన్ చూపిస్తుంది
  Widget _buildVehicleImage(Map<String, dynamic> info) {
    return Image.asset(
      info['assetPath'],
      width: 64,
      height: 64,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          info['icon'] as IconData,
          color: Colors.white,
          size: 54,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final info = _getVehicleInfo();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
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
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // రేడార్ యానిమేషన్ మరియు మధ్యలో సెలెక్ట్ చేసిన వెహికల్
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // రేడార్ పల్స్ ఎఫెక్ట్
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return Container(
                              width: 120 + (_pulseController.value * 40),
                              height: 120 + (_pulseController.value * 40),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF0066FF).withOpacity(0.15 * (1 - _pulseController.value)),
                              ),
                            );
                          },
                        ),
                        // సెంటర్ సర్కిల్ లోపల కస్టమర్ ఎంచుకున్న వెహికల్ ఇమేజ్
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0066FF),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0066FF).withOpacity(0.35),
                                blurRadius: 25,
                                spreadRadius: 4,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: _buildVehicleImage(info),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // డైనమిక్ మెయిన్ టెక్స్ట్
                    Text(
                      info['subText'],
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
                          info['areaText'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // సెలెక్ట్ అయిన వెహికల్ పేరు & ఫేర్ బ్యాడ్జ్
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBF3FF),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFCCE0FF)),
                      ),
                      child: Text(
                        "${info['title']} • ${info['fare']}",
                        style: const TextStyle(
                          color: Color(0xFF0066FF),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // బాటమ్ కార్డ్
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
                  const SizedBox(height: 20),
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
}

// Aliases for full compatibility
typedef SearchingPartnerScreen = SearchingPartnerscreen;
typedef SearchingCaptainScreen = SearchingPartnerscreen;
'@

# ఫైల్స్ లోకి అప్‌డేట్ చేస్తుంది
$target1 = "$PWD\lib\screens\tracking\searching_partner_screen.dart"
$target2 = "$PWD\lib\screens\tracking\searching_Partner_screen.dart"

[System.IO.File]::WriteAllText($target1, $code, [System.Text.Encoding]::UTF8)
[System.IO.File]::WriteAllText($target2, $code, [System.Text.Encoding]::UTF8)

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "Radar screen updated with dynamic Bike/Auto/Car/Parcel!" -ForegroundColor Green
Write-Host "Now press F5 in Chrome or 'R' in CMD to see the update." -ForegroundColor Yellow
Write-Host "======================================================" -ForegroundColor Cyan