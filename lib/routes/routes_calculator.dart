import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:saral_yatayat/googleapi/distance_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saral_yatayat/routes/item.dart';

class DistanceCalculator extends StatefulWidget {
  const DistanceCalculator({super.key, required this.items});

  final List<Item> items;

  @override
  DistanceCalculatorState createState() => DistanceCalculatorState();
}

class DistanceCalculatorState extends State<DistanceCalculator> {
  late List<Item> items;

  final DistanceService _distanceService = DistanceService();
  String? _selectedOrigin;
  String? _selectedDestination;
  String _distance = '';
  void _calculateDistance() async {
    String? apiKey = await getApiKey();

    try {
      String distance = await _distanceService.getDistance(
          _selectedOrigin!, _selectedDestination!, apiKey!);
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
  void initState() {
    items = widget.items;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DropdownButton<String>(
            // Change DropdownButton<Item> to DropdownButton<String>
            value: _selectedOrigin,
            onChanged: (String? newValue) {
              // Change type of newValue to String?
              setState(() {
                _selectedOrigin = newValue;
              });
            },
            items: items.map((Item item) {
              return DropdownMenuItem<String>(
                value: item.title, // Use title of the item as value
                child: Text(item.title),
              );
            }).toList(),
            icon: Container(
              alignment: Alignment.bottomLeft,
              child: const Icon(Icons.arrow_drop_down),
            ),
            hint: const Text('Select Origin'),
          ),
          const SizedBox(height: 10),
          DropdownButton<String>(
            value: _selectedDestination,
            onChanged: (String? newValue) {
              setState(() {
                _selectedDestination = newValue;
              });
            },
            items: items.map((Item item) {
              return DropdownMenuItem<String>(
                value: item.title, // Use title of the item as value
                child: Text(item.title),
              );
            }).toList(),
            icon: Container(
              alignment: Alignment.center,
              child: const Icon(Icons.arrow_drop_down),
            ),
            hint: const Text('Select Destination'),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: _selectedOrigin != null && _selectedDestination != null
                ? _selectedOrigin == _selectedDestination
                    ? null
                    : _calculateDistance
                : null,
            child: const Text('Calculate Distance'),
          ),
          const SizedBox(height: 20.0),
          Text(
            'Distance between $_selectedOrigin and $_selectedDestination : \n$_distance',
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
