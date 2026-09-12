import 'dart:async';
import 'package:flutter/material.dart';
import 'live_tracking_screen.dart';

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
  late AnimationController _radarController;
  String _selectedVehicle = 'auto';
  Timer? _autoTransitionTimer;
  bool _partnerFound = false;

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

    // 4 à°¸à±†à°•à°¨à±à°²à°²à±‹ à°†à°Ÿà±‹à°®à±‡à°Ÿà°¿à°•à± à°—à°¾ à°ªà°¾à°°à±à°Ÿà±à°¨à°°à± à°¦à±Šà°°à°¿à°•à°¿à°¨à°Ÿà±à°²à± à°²à±ˆà°µà± à°Ÿà±à°°à°¾à°•à°¿à°‚à°—à± à°¸à±à°•à±à°°à±€à°¨à± à°•à°¿ à°µà±†à°³à±à°¤à±à°‚à°¦à°¿
    _autoTransitionTimer = Timer(const Duration(seconds: 4), () {
      if (!mounted) return;
      setState(() {
        _partnerFound = true;
      });
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        _navigateToLiveTracking();
      });
    });
  }

  void _navigateToLiveTracking() {
    _autoTransitionTimer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LiveTrackingScreen(
          data: {
            'vehicleType': _selectedVehicle,
            'fare': _getVehicleData()['fare'],
          },
        ),
      ),
    );
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
    _autoTransitionTimer?.cancel();
    _radarController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _getVehicleData() {
    switch (_selectedVehicle) {
      case 'bike':
        return {
          'name': 'Flash Bike',
          'fare': '\u20B919',
          'subtitle': _partnerFound ? 'Partner Found! Connecting...' : 'Searching for nearby bike partner...',
          'area': 'Looking for bike partner in Nellore area',
          'type': 'bike',
        };
      case 'car':
      case 'cab':
        return {
          'name': 'Flash Cab',
          'fare': '\u20B949',
          'subtitle': _partnerFound ? 'Partner Found! Connecting...' : 'Searching for nearby cab partner...',
          'area': 'Looking for cab partner in Nellore area',
          'type': 'cab',
        };
      case 'parcel':
        return {
          'name': 'Flash Parcel',
          'fare': '\u20B935',
          'subtitle': _partnerFound ? 'Partner Found! Connecting...' : 'Searching for nearby delivery partner...',
          'area': 'Looking for delivery partner in Nellore area',
          'type': 'parcel',
        };
      case 'auto':
      default:
        return {
          'name': 'Flash Auto',
          'fare': '\u20B926',
          'subtitle': _partnerFound ? 'Partner Found! Connecting...' : 'Searching for nearby partner...',
          'area': 'Looking for partner in Nellore area',
          'type': 'auto',
        };
    }
  }

  Widget _buildPosterVehicleGraphic(String type) {
    switch (type) {
      case 'bike':
        return Container(
          width: 76,
          height: 76,
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: const Center(child: Icon(Icons.two_wheeler_rounded, size: 50, color: Color(0xFF0066FF))),
        );
      case 'cab':
        return Container(
          width: 76,
          height: 76,
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.directions_car_filled_rounded, size: 50, color: Color(0xFF0066FF)),
                Positioned(
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(2)),
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
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: const Center(child: Icon(Icons.inventory_2_rounded, size: 46, color: Color(0xFF0066FF))),
        );
      case 'auto':
      default:
        return Container(
          width: 76,
          height: 76,
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: const Center(child: Icon(Icons.electric_rickshaw, size: 50, color: Color(0xFF0066FF))),
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
          onPressed: () {
            _autoTransitionTimer?.cancel();
            Navigator.maybePop(context);
          },
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
                    // à°°à±‡à°¡à°¾à°°à± à°¸à°°à±à°•à°¿à°²à± (à°•à±à°²à°¿à°•à± à°šà±‡à°¸à°¿à°¨à°¾ à°µà±†à°‚à°Ÿà°¨à±‡ à°²à±ˆà°µà± à°Ÿà±à°°à°¾à°•à°¿à°‚à°—à± à°“à°ªà±†à°¨à± à°…à°µà±à°¤à±à°‚à°¦à°¿)
                    InkWell(
                      onTap: _navigateToLiveTracking,
                      borderRadius: BorderRadius.circular(110),
                      child: SizedBox(
                        width: 220,
                        height: 220,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
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
                                      color: (_partnerFound ? const Color(0xFF00A859) : const Color(0xFF0066FF))
                                          .withOpacity(0.25 * (1 - val)),
                                      width: 1.5,
                                    ),
                                  ),
                                );
                              },
                            ),
                            AnimatedBuilder(
                              animation: _radarController,
                              builder: (context, child) {
                                final val = (_radarController.value + 0.33) % 1.0;
                                return Container(
                                  width: 100 + (val * 90),
                                  height: 100 + (val * 90),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: (_partnerFound ? const Color(0xFF00A859) : const Color(0xFF0066FF))
                                        .withOpacity(0.08 * (1 - val)),
                                    border: Border.all(
                                      color: (_partnerFound ? const Color(0xFF00A859) : const Color(0xFF0066FF))
                                          .withOpacity(0.35 * (1 - val)),
                                      width: 1.5,
                                    ),
                                  ),
                                );
                              },
                            ),
                            AnimatedBuilder(
                              animation: _radarController,
                              builder: (context, child) {
                                final val = _radarController.value;
                                return Container(
                                  width: 100 + (val * 60),
                                  height: 100 + (val * 60),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: (_partnerFound ? const Color(0xFF00A859) : const Color(0xFF0066FF))
                                        .withOpacity(0.12 * (1 - val)),
                                  ),
                                );
                              },
                            ),
                            Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                color: _partnerFound ? const Color(0xFF00A859) : const Color(0xFF0066FF),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: (_partnerFound ? const Color(0xFF00A859) : const Color(0xFF0066FF)).withOpacity(0.4),
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
                    ),

                    const SizedBox(height: 28),

                    // à°¸à°¬à±â€Œà°Ÿà±ˆà°Ÿà°¿à°²à±
                    Text(
                      vData['subtitle'] as String,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _partnerFound ? const Color(0xFF00A859) : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // à°²à±Šà°•à±‡à°·à°¨à± à°µà°¿à°µà°°à°¾à°²à±
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on, color: Color(0xFF0066FF), size: 18),
                        const SizedBox(width: 4),
                        Text(
                          vData['area'] as String,
                          style: const TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // à°¬à±à°¯à°¾à°¡à±à°œà±
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

            // à°¬à°¾à°Ÿà°®à± à°•à°¾à°°à±à°¡à±
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
                        child: const Icon(Icons.shield_outlined, color: Color(0xFF0066FF), size: 24),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Safe & Verified Partners',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Partner details will appear as soon as accepted.',
                              style: TextStyle(fontSize: 12, color: Colors.black54),
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
                      onPressed: () {
                        _autoTransitionTimer?.cancel();
                        Navigator.maybePop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      child: const Text(
                        'Cancel Ride',
                        style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
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