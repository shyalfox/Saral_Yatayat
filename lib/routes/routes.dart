import 'package:flutter/material.dart';

import 'package:saral_yatayat/routes/routes_list_kathmandu.dart';
import 'package:saral_yatayat/routes/inkwell.dart';

class SaralRoutes extends StatelessWidget {
  const SaralRoutes({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400, // Increased height to accommodate bigger cards
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 8,
          ),
          const Text(
            'Available Districts',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          InkWellCard(
            title: 'Kathmandu',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ListKathmnadu(),
                ),
              );
            },
          ),
          InkWellCard(
            title: 'Lalitpur',
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Lalipur Route'),
                    content: const Text('Coming Soon'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          InkWellCard(
            title: 'Bhaktapur',
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Bhaktapur Route'),
                    content: const Text('Coming Soon'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
