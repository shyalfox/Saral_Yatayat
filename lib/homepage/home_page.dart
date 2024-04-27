import 'dart:io';

import 'package:flutter/material.dart';
import 'package:saral_yatayat/personal/personal_page.dart';
import 'package:saral_yatayat/routes/routes.dart';

class SaralYatayatHome extends StatefulWidget {
  const SaralYatayatHome({super.key});

  @override
  SaralYatayatHomeState createState() => SaralYatayatHomeState();
}

class SaralYatayatHomeState extends State<SaralYatayatHome> {
  int _currentPageIndex = 1;

  final PageController _pageController = PageController(initialPage: 1);

  void _onPageChanged(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  void _onBottomNavItemTapped(int index) {
    setState(() {
      _currentPageIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 200),
        curve: Curves.ease,
      );
    });
  }

  Future<bool> onBackPressed(BuildContext context, bool didPop) async {
    if (didPop) {
      return true;
    } else {
      // Show AlertDialog
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Are you sure you want to exit?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  exit(0); // Close the app
                },
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('No'),
              ),
            ],
          );
        },
      );
      // Return false to indicate that back button press is handled
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // Add your help or information action here
            },
          ),
        ],
        title: const Text('Saral Yatayat'),
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) => onBackPressed(context, didPop),
        child: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          physics:
              const NeverScrollableScrollPhysics(), // Disable swipe gesture
          children: const [
            SaralRoutes(),
            SaralPages(),
            ProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: _onBottomNavItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Routes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class SaralPages extends StatelessWidget {
  const SaralPages({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SingleChildScrollView(
        child: Text(
          'Page ',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
