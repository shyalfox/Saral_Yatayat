import 'package:flutter/material.dart';
import 'package:saral_yatayat/homepage/home_page.dart';
import 'package:saral_yatayat/routes/routes_calculator.dart';
import 'package:saral_yatayat/routes/item.dart';

class ChakrapathRoute extends StatefulWidget {
  const ChakrapathRoute({super.key});

  @override
  State<ChakrapathRoute> createState() => _ChakrapathRouteState();
}

class _ChakrapathRouteState extends State<ChakrapathRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chakrapath Route'),
      ),
      body: ListView.builder(
        itemCount: chakrapath.length + 2, // Add 2 for the header and the image
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            // Header
            return Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Image.asset(
                    'assets/images/chakrapath.png',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Chakrapath Parikrama',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.all(1.0),
                  child: Text(
                    'Note: Observe from bottom to top if the Saral vehicles swaps Start point with End point',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            );
          } else if (index == 1) {
            // Spacer after header
            return const SizedBox(height: 10);
          } else {
            // List item
            final item = chakrapath[index - 2];
            return CardItem(item: item);
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SaralYatayatHome(),
                  ),
                );
              },
              icon: const Icon(Icons.home),
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.location_on),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        height: 50,
        width: 80,
        child: FloatingActionButton(
          onPressed: () => _showPopup(context),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.stay_primary_landscape_rounded),
              SizedBox(
                  width: 8), // Add some spacing between the icon and the text
              Text('Ticket'), // Your ticket text
            ],
          ),
        ),
      ),
    );
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero, // Set insetPadding to zero
          child: AlertDialog(
            title: const Text('Select Locations'),
            content: OverflowBox(
              minWidth: 0.0,
              maxWidth: double.infinity,
              minHeight: 0.0,
              maxHeight: double.infinity,
              child: DistanceCalculator(items: chakrapath),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CardItem extends StatelessWidget {
  final Item item;

  const CardItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('${item.locId}) ${item.title}'),
      ),
    );
  }
}
