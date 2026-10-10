import 'package:flutter/material.dart';
import '../models/ride_model.dart';
import '../models/pass_model.dart';

enum RideBookingStatus { idle, searching, accepted, arrived, inTrip, completed }

class RideProvider extends ChangeNotifier {
  PlaceModel _pickup = PlaceModel(title: 'Magunta Layout', address: 'Magunta Layout, Nellore (Current GPS)', distanceKm: 0.0);
  PlaceModel? _stopLocation;
  PlaceModel? _destination;
  RideOptionModel? _selectedOption;
  RideBookingStatus _status = RideBookingStatus.idle;
  final String _otp = '4829';
  double _discount = 0.0;
  String? _couponCode;
  DateTime? _scheduledTime;
  FlashPassModel? _activePass;
  bool _isDetectingLocation = false;

  final List<RideOptionModel> availableVehicles = [
    RideOptionModel(type: RideVehicleType.bike, title: 'Flash Bike', subtitle: 'Fastest in traffic', ratePerKm: 9.0, baseFare: 25.0, eta: '2 mins', icon: Icons.two_wheeler_rounded, iconColor: const Color(0xFF00B368)),
    RideOptionModel(type: RideVehicleType.auto, title: 'Flash Auto', subtitle: 'Comfortable & quick', ratePerKm: 14.0, baseFare: 40.0, eta: '3 mins', icon: Icons.electric_rickshaw_rounded, iconColor: const Color(0xFFF59E0B)),
    RideOptionModel(type: RideVehicleType.cab, title: 'Flash Cab', subtitle: 'Affordable AC rides', ratePerKm: 22.0, baseFare: 80.0, eta: '5 mins', icon: Icons.directions_car_rounded, iconColor: const Color(0xFF2563EB)),
    RideOptionModel(type: RideVehicleType.parcel, title: 'Flash Parcel', subtitle: 'Courier in 45 mins', ratePerKm: 8.0, baseFare: 20.0, eta: '4 mins', icon: Icons.inventory_2_rounded, iconColor: const Color(0xFFEA580C)),
  ];

  final List<FlashPassModel> passes = [
    FlashPassModel(id: '1', title: 'Daily Commuter Pass', description: 'Flat â‚¹20 OFF on next 10 Bike/Auto rides', price: 49.0, totalRides: 10, discountPerRide: 20.0, validityDays: 15),
    FlashPassModel(id: '2', title: 'Monthly Super Saver Pass', description: 'Flat â‚¹30 OFF on next 30 rides across all vehicles', price: 149.0, totalRides: 30, discountPerRide: 30.0, validityDays: 30),
  ];

  PlaceModel get pickup => _pickup;
  PlaceModel? get stopLocation => _stopLocation;
  PlaceModel? get destination => _destination;
  RideOptionModel? get selectedOption => _selectedOption ?? availableVehicles.first;
  RideBookingStatus get status => _status;
  String get otp => _otp;
  double get discount => _discount;
  String? get couponCode => _couponCode;
  DateTime? get scheduledTime => _scheduledTime;
  FlashPassModel? get activePass => _activePass;
  bool get isDetectingLocation => _isDetectingLocation;

  Future<void> fetchLiveLocation() async {
    _isDetectingLocation = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));
    _pickup = PlaceModel(
      title: 'Current Live GPS',
      address: 'Magunta Layout, Nellore (Detected)',
      distanceKm: 0.0,
    );
    _isDetectingLocation = false;
    notifyListeners();
  }

  void setPickup(PlaceModel place) {
    _pickup = place;
    notifyListeners();
  }

  void setPickupManual(String text) {
    _pickup = PlaceModel(title: text, address: text, distanceKm: 0.0);
    notifyListeners();
  }

  void setDestination(PlaceModel place) {
    _destination = place;
    _selectedOption = availableVehicles.first;
    notifyListeners();
  }

  void setDestinationManual(String text) {
    _destination = PlaceModel(title: text, address: text, distanceKm: 4.5);
    _selectedOption = availableVehicles.first;
    notifyListeners();
  }

  void setStopLocation(PlaceModel? place) {
    _stopLocation = place;
    notifyListeners();
  }

  void setScheduledTime(DateTime? time) {
    _scheduledTime = time;
    notifyListeners();
  }

  void selectVehicle(RideOptionModel option) {
    _selectedOption = option;
    notifyListeners();
  }

  void applyCoupon(String code) {
    if (code.toUpperCase() == 'FLASH50') {
      _couponCode = 'FLASH50';
      _discount = 25.0;
      notifyListeners();
    }
  }

  void buyPass(FlashPassModel pass) {
    _activePass = pass;
    _discount = pass.discountPerRide;
    notifyListeners();
  }

  void startSearching() {
    _status = RideBookingStatus.searching;
    notifyListeners();
    Future.delayed(const Duration(seconds: 3), () {
      _status = RideBookingStatus.accepted;
      notifyListeners();
    });
  }

  void simulateTripProgression() {
    if (_status == RideBookingStatus.accepted) {
      _status = RideBookingStatus.inTrip;
    } else if (_status == RideBookingStatus.inTrip) {
      _status = RideBookingStatus.completed;
    }
    notifyListeners();
  }

  void cancelRide() {
    _status = RideBookingStatus.idle;
    notifyListeners();
  }

  void resetRide() {
    _status = RideBookingStatus.idle;
    _destination = null;
    _stopLocation = null;
    _discount = 0.0;
    _couponCode = null;
    _scheduledTime = null;
    notifyListeners();
  }
}
