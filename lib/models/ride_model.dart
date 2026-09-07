import 'package:flutter/material.dart';

enum RideVehicleType { bike, auto, cab, parcel }

class RideOptionModel {
  final RideVehicleType type;
  final String title;
  final String subtitle;
  final double ratePerKm;
  final double baseFare;
  final String eta;
  final IconData icon;
  final Color iconColor;

  RideOptionModel({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.ratePerKm,
    required this.baseFare,
    required this.eta,
    required this.icon,
    required this.iconColor,
  });

  double calculateFare(double distanceKm) {
    return baseFare + (ratePerKm * distanceKm);
  }
}

class PlaceModel {
  final String title;
  final String address;
  final double distanceKm;

  PlaceModel({required this.title, required this.address, required this.distanceKm});
}

class RentalPackageModel {
  final String id;
  final String duration;
  final String distance;
  final double bikeFare;
  final double autoFare;
  final double cabFare;

  RentalPackageModel({
    required this.id,
    required this.duration,
    required this.distance,
    required this.bikeFare,
    required this.autoFare,
    required this.cabFare,
  });
}
