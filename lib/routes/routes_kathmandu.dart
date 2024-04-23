import 'package:flutter/material.dart';
import 'dart:math';

class RoutesKathmandu extends StatelessWidget {
  const RoutesKathmandu({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () => hello(), child: Text('test'));
  }
}

class Location {
  final double latitude;
  final double longitude;

  Location(this.latitude, this.longitude);
}

class DistanceCalculator {
  static double calculateDistance(Location location1, Location location2) {
    const double earthRadius = 6371; // Radius of the earth in km
    double latDifference =
        _degreesToRadians(location2.latitude - location1.latitude);
    double lonDifference =
        _degreesToRadians(location2.longitude - location1.longitude);
    double a = sin(latDifference / 2) * sin(latDifference / 2) +
        cos(_degreesToRadians(location1.latitude)) *
            cos(_degreesToRadians(location2.latitude)) *
            sin(lonDifference / 2) *
            sin(lonDifference / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c; // Distance in km
    return distance;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}

void hello() {
  Location chakrapath = Location(27.742775, 85.331848);
  Location basundhara = Location(27.715113, 85.304047);
  double distance =
      DistanceCalculator.calculateDistance(chakrapath, basundhara);
  print('Distance between Chakrapath and Basundhara: $distance km');
}
// AIzaSyCG7lMm8Zdm9xuj8gHtaa9TDoke5BGVM2I