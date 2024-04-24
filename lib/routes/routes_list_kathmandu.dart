import 'package:flutter/material.dart';
import 'package:saral_yatayat/routes/route_locations/chakrapath_route.dart';
import 'floating_back_button.dart';

class ListKathmnadu extends StatelessWidget {
  const ListKathmnadu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            InkWellCard(
              title: 'Chakrapath Route',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChakrapathRoute(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: const Stack(children: [MyFloatingActionButton()]),
    );
  }
}

class InkWellCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const InkWellCard({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 100,
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
