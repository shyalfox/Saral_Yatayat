import 'package:flutter/material.dart';
import 'package:saral_yatayat/routes/route_locations/chakrapath_route.dart';
import 'floating_back_button.dart';
import 'inkwell.dart';

class ListKathmnadu extends StatelessWidget {
  const ListKathmnadu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kathmandu Routes'),
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
