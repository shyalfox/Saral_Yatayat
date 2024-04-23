import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:saral_yatayat/googleapi/distance_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DistanceCalculator extends StatefulWidget {
  const DistanceCalculator({super.key});

  @override
  DistanceCalculatorState createState() => DistanceCalculatorState();
}

class DistanceCalculatorState extends State<DistanceCalculator> {
  final DistanceService _distanceService = DistanceService();
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  String _distance = '';

  void _calculateDistance() async {
    String? apiKey = await getApiKey();

    String origin = _originController.text;
    String destination = _destinationController.text;
    try {
      String distance =
          await _distanceService.getDistance(origin, destination, apiKey);
      setState(() {
        _distance = distance;
      });
    } catch (e) {
      setState(() {
        _distance = 'Error: $e';
      });
    }
  }

  Future<String?> getApiKey() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('secret')
          .doc('values')
          .get();

      // Access the data directly from the snapshot
      Map<String, dynamic>? data = snapshot.data();
      if (data != null && data.isNotEmpty) {
        // Return the first value in the document
        String firstValue = data.values.first.toString();
        return firstValue;
      } else {
        // If data is empty or not found
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching API key: $e');
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Distance Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _originController,
              decoration: const InputDecoration(labelText: 'Origin'),
            ),
            TextField(
              controller: _destinationController,
              decoration: const InputDecoration(labelText: 'Destination'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _calculateDistance,
              child: const Text('Calculate Distance'),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Distance: $_distance',
              style: const TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
