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
  final List<Item> items = [
    Item(1, 'Gausala', 27.7084959, 85.3465697),
    Item(2, 'Gopi Krishna ', 27.7222481, 85.3468914),
    Item(3, 'Sukhedhara', 1, 1),
    // Item(4, 'Dhumbarahi'),
    // Item(5, 'Chappal Karkhana'),
    // Item(6, 'Narayan Gopal Chwok'),
    // Item(7, 'Basundhara'),
    // Item(8, 'Samakhusi'),
    // Item(9, 'Gongabu'),
    // Item(10, 'Macchapokari'),
    // Item(11, 'Balaju Stop'),
    // Item(12, 'Banasthali'),
    // Item(13, 'Dhungedhara'),
    // Item(14, 'Sano Bharyang'),
    // Item(15, 'Thulo Bharyang'),
    // Item(16, 'Swyambhu'),
    // Item(17, 'Kalanki Chwok'),
    // Item(18, 'KhasiBAzar'),
    // Item(19, 'Balkhu'),
    // Item(20, 'Sanepa Height'),
    // Item(21, 'Ekantakuna'),
    // Item(22, 'Satdobato'),
    // Item(23, 'Gwarko'),
    // Item(24, 'Koteshwor'),
    // Item(25, 'Tinkune'),
    // Item(26, 'Sinamangal'),
    // Item(27, 'Airport (Tribhuvawan International)'),
    // Item(28, 'Pinglasthan'),
    // Item(29, 'Gaushala'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Page'),
      ),
      body: ListView.builder(
        itemCount: items.length + 2, // Add 2 for the header and the image
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            // Header
            return Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Image.network(
                    'https://via.placeholder.com/350',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Chakrapath Parikrama',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 10),
              ],
            );
          } else if (index == 1) {
            // Spacer after header
            return const SizedBox(height: 10);
          } else {
            // List item
            final item = items[index - 2];
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
              onPressed: () {},
              icon: const Icon(Icons.arrow_back),
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
        return AlertDialog(
          content: SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
            child: DistanceCalculator(
              items: items,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
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
