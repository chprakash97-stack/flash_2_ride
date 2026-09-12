Write-Host "======================================================" -ForegroundColor Cyan
Write-Host " Scanning project for Home Screen Vehicle Images..." -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan

# 1. ప్రాజెక్ట్ లోని అన్ని ఇమేజ్ ఫైల్స్ ను వెతుకుతుంది
$allImages = Get-ChildItem -Path "$PWD\assets" -Recurse -Include *.png,*.jpg,*.jpeg,*.webp,*.svg -ErrorAction SilentlyContinue

Write-Host "Found the following images in assets:" -ForegroundColor Green
$allImages | ForEach-Object { 
    $rel = $_.FullName.Replace($PWD + '\', '').Replace('\', '/')
    Write-Host "  -> $rel" -ForegroundColor Yellow 
}

$bikeAsset = "assets/images/bike.png"
$autoAsset = "assets/images/auto.png"
$carAsset = "assets/images/car.png"
$parcelAsset = "assets/images/parcel.png"

# ఆటోమేటిక్ గా ఫైల్స్ మ్యాచ్ చేస్తుంది
foreach ($img in $allImages) {
    $rel = $img.FullName.Replace($PWD + '\', '').Replace('\', '/')
    if ($rel -match 'bike|motorcycle|two_wheeler') { $bikeAsset = $rel }
    elseif ($rel -match 'auto|rickshaw') { $autoAsset = $rel }
    elseif ($rel -match 'car|cab|taxi') { $carAsset = $rel }
    elseif ($rel -match 'parcel|delivery|box') { $parcelAsset = $rel }
}

# హోమ్ స్క్రీన్ మరియు ఇతర ఫైల్స్ లోని అసెట్ పాత్‌లను కూడా చెక్ చేస్తుంది
Get-ChildItem -Path "$PWD\lib" -Filter *.dart -Recurse | ForEach-Object {
    $content = [System.IO.File]::ReadAllText($_.FullName)
    $matches = [regex]::Matches($content, "['""](assets/[^'""]+\.(png|jpg|jpeg|svg|webp))['""]")
    foreach ($m in $matches) {
        $path = $m.Groups.Value
        if ($path -match 'bike') { $bikeAsset = $path }
        elseif ($path -match 'auto') { $autoAsset = $path }
        elseif ($path -match 'car|cab') { $carAsset = $path }
        elseif ($path -match 'parcel') { $parcelAsset = $path }
    }
}

Write-Host "------------------------------------------------------" -ForegroundColor Cyan
Write-Host "Matched Original Vehicle Assets:" -ForegroundColor Green
Write-Host "  Bike   : $bikeAsset" -ForegroundColor White
Write-Host "  Auto   : $autoAsset" -ForegroundColor White
Write-Host "  Car    : $carAsset" -ForegroundColor White
Write-Host "  Parcel : $parcelAsset" -ForegroundColor White
Write-Host "------------------------------------------------------" -ForegroundColor Cyan

$code = @"
import 'package:flutter/material.dart';

class SearchingPartnerscreen extends StatefulWidget {
  final String? vehicleType;
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
  String _selectedVehicle = 'auto';
  String _fare = '\u20B926';

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

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

  Map<String, dynamic> _getVehicleInfo() {
    switch (_selectedVehicle) {
      case 'bike':
        return {
          'title': 'Flash Bike',
          'fare': _fare == '\u20B926' ? '\u20B919' : _fare,
          'icon': Icons.two_wheeler_rounded,
          'assetPath': '$bikeAsset',
          'subText': 'Searching for nearby bike partner...',
          'areaText': 'Looking for bike partner in Nellore area',
        };
      case 'car':
      case 'cab':
        return {
          'title': 'Flash Car',
          'fare': _fare == '\u20B926' ? '\u20B949' : _fare,
          'icon': Icons.directions_car_rounded,
          'assetPath': '$carAsset',
          'subText': 'Searching for nearby car partner...',
          'areaText': 'Looking for car partner in Nellore area',
        };
      case 'parcel':
        return {
          'title': 'Flash Parcel',
          'fare': _fare == '\u20B926' ? '\u20B935' : _fare,
          'icon': Icons.inventory_2_rounded,
          'assetPath': '$parcelAsset',
          'subText': 'Searching for nearby delivery partner...',
          'areaText': 'Looking for delivery partner in Nellore area',
        };
      case 'auto':
      default:
        return {
          'title': 'Flash Auto',
          'fare': _fare,
          'icon': Icons.electric_rickshaw,
          'assetPath': '$autoAsset',
          'subText': 'Searching for nearby partner...',
          'areaText': 'Looking for partner in Nellore area',
        };
    }
  }

  Widget _buildVehicleImage(Map<String, dynamic> info) {
    return Image.asset(
      info['assetPath'],
      width: 76,
      height: 76,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          info['icon'] as IconData,
          color: const Color(0xFF0066FF),
          size: 56,
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
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return Container(
                              width: 120 + (_pulseController.value * 42),
                              height: 120 + (_pulseController.value * 42),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF0066FF).withOpacity(0.12 * (1 - _pulseController.value)),
                              ),
                            );
                          },
                        ),
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0066FF).withOpacity(0.25),
                                blurRadius: 20,
                                spreadRadius: 3,
                                offset: const Offset(0, 6),
                              ),
                            ],
                            border: Border.all(color: const Color(0xFF0066FF).withOpacity(0.25), width: 2),
                          ),
                          child: Center(
                            child: _buildVehicleImage(info),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      info['subText'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBF3FF),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFCCE0FF)),
                      ),
                      child: Text(
                        "${info['title']} \u2022 ${info['fare']}",
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

typedef SearchingPartnerScreen = SearchingPartnerscreen;
typedef SearchingCaptainScreen = SearchingPartnerscreen;
"@

$target1 = "$PWD\lib\screens\tracking\searching_partner_screen.dart"
$target2 = "$PWD\lib\screens\tracking\searching_Partner_screen.dart"

[System.IO.File]::WriteAllText($target1, $code, [System.Text.Encoding]::UTF8)
[System.IO.File]::WriteAllText($target2, $code, [System.Text.Encoding]::UTF8)

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "Radar screen updated with detected original assets!" -ForegroundColor Green
Write-Host "Please press F5 in Chrome or 'R' in CMD to view." -ForegroundColor Yellow
Write-Host "======================================================" -ForegroundColor Cyan