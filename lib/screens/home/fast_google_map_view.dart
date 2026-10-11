import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FastGoogleMapView extends StatefulWidget {
  final LatLng initialCenter;

  const FastGoogleMapView({
    super.key,
    required this.initialCenter,
  });

  @override
  State<FastGoogleMapView> createState() => FastGoogleMapViewState();
}

class FastGoogleMapViewState extends State<FastGoogleMapView> {
  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  StreamSubscription<QuerySnapshot>? _driversSubscription;

  @override
  void initState() {
    super.initState();
    _listenToNearbyDrivers();
  }

  @override
  void dispose() {
    _driversSubscription?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  /// హోమ్ స్క్రీన్ నుండి కెమెరాను స్మూత్‌గా మూవ్ చేసే మెథడ్
  void animateToLocation(LatLng target) {
    _controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: 16.0),
      ),
    );
  }

  /// డ్రైవర్లను ఫైర్‌స్టోర్ నుండి వింటూ కేవలం మ్యాప్ లోపలే మార్కర్లను అప్‌డేట్ చేయడం
  void _listenToNearbyDrivers() {
    _driversSubscription = FirebaseFirestore.instance
        .collection('drivers')
        .where('isOnline', isEqualTo: true)
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      final Set<Marker> newMarkers = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final lat = (data['latitude'] as num?)?.toDouble() ?? widget.initialCenter.latitude;
        final lng = (data['longitude'] as num?)?.toDouble() ?? widget.initialCenter.longitude;
        final vehicleType = data['vehicleType'] ?? 'Bike';

        double hue = BitmapDescriptor.hueGreen;
        if (vehicleType == 'Cab') hue = BitmapDescriptor.hueViolet;
        if (vehicleType == 'Auto') hue = BitmapDescriptor.hueOrange;
        if (vehicleType == 'Parcel') hue = BitmapDescriptor.hueCyan;

        newMarkers.add(
          Marker(
            markerId: MarkerId(doc.id),
            position: LatLng(lat, lng),
            icon: BitmapDescriptor.defaultMarkerWithHue(hue),
            flat: true,
          ),
        );
      }

      if (mounted) {
        setState(() {
          _markers = newMarkers;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.initialCenter,
          zoom: 15.5,
        ),
        myLocationEnabled: true, // కస్టమర్ డ్రైవింగ్ చేస్తున్నప్పుడు బ్లూ డాట్ అతనితో పాటే కదులుతుంది
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        compassEnabled: false,
        mapToolbarEnabled: false,
        trafficEnabled: false, // స్పీడ్ కోసం ఆఫ్ చేసాము
        buildingsEnabled: false, // హ్యాంగ్ అవ్వకుండా 3D బిల్డింగ్స్ ఆఫ్
        indoorViewEnabled: false,
        rotateGesturesEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        tiltGesturesEnabled: false,
        padding: const EdgeInsets.only(bottom: 230, top: 90),
        markers: _markers,
        onMapCreated: (controller) {
          _controller = controller;
        },
      ),
    );
  }
}