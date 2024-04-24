import 'package:flutter/material.dart';

import 'package:saral_yatayat/routes/routes_list_kathmandu.dart';

class SaralRoutes extends StatelessWidget {
  const SaralRoutes({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400, // Increased height to accommodate bigger cards
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          const Text(
            'Available Districts',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const DistanceCalculator(),
              //   ),
              // );
            },
            child: Container(
              width: double.infinity, // Expand the card to full width
              height: 100, // Set the height of the card
              padding:
                  const EdgeInsets.all(16), // Add padding for better visibility
              child: const Card(
                child: Center(
                  child: Text(
                    'Kathmandu',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const DistanceCalculator(),
              //   ),
              // );
            },
            child: Container(
              width: double.infinity,
              height: 100,
              padding: const EdgeInsets.all(16),
              child: const Card(
                child: Center(
                  child: Text(
                    'Lalitpur',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ListKathmnadu(),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              height: 100,
              padding: const EdgeInsets.all(16),
              child: const Card(
                child: Center(
                  child: Text(
                    'Bhaktapur',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
