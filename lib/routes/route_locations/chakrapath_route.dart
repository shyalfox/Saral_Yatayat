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
  final List<Item> chakrapath = [
    Item(1, 'Gaushala(Start)', '27.7127136, 85.3399811'),
    Item(2, 'Chabahil', '27.7165681, 85.3427506'),
    Item(3, 'Sukhedhara', '27.7283581,85.3455953'),
    Item(4, 'Dhumbarahi', '27.7313066,85.344716'),
    Item(5, 'Chappal Karkhana', '27.7353921,85.3415949'),
    Item(6, 'Narayan Gopal Chwok', '27.7400235,85.3330249'),
    Item(7, 'Basundhara', '27.7384966,85.3227107'),
    Item(8, 'Samakhusi', '27.7349492,85.3171873'),
    Item(9, 'Gongabu', '27.7348556,85.3138949'),
    Item(10, 'Macchapokari', '27.735031,85.3056356'),
    Item(11, 'Balaju', '27.7284981,85.3041272'),
    Item(12, 'Banasthali', '27.7247492,85.2973461'),
    Item(13, 'Dhungedhara', '27.7233525,85.2945109'),
    Item(14, 'Sano Bharyang', '27.7211188,85.2888221'),
    Item(15, 'Thulo Bharyang', '27.719532, 85.286809'),
    Item(16, 'Swyambhu', '27.7160242,85.2835423'),
    Item(17, 'Kalanki Chwok', '27.6939452,85.2810343'),
    Item(18, 'KhasiBAzar', '27.6892162,85.2836813'),
    Item(19, 'Balkhu', '27.684321,85.2966385'),
    Item(20, 'Dhobighat', '27.6729672,85.3019423'),
    Item(21, 'Ekantakuna', '27.6678699,85.306829'),
    Item(22, 'Satdobato', '27.6580887,85.3207409'),
    Item(23, 'Gwarko', '27.6667334,85.33193'),
    Item(24, 'Koteshwor', '27.6787139,85.3490609'),
    Item(25, 'Tinkune', '27.6834517,85.3490277'),
    Item(26, 'Sinamangal', '27.6952656,85.3548333'),
    Item(27, 'Airport (Tribhuvawan International)', '27.6991622,85.3535853'),
    Item(28, 'Gaushala (End)', '27.7068535,85.3444089'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Page'),
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
