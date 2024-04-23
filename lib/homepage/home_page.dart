import 'package:flutter/material.dart';
import 'package:saral_yatayat/routes/routes.dart';

class SaralYatayatHome extends StatefulWidget {
  const SaralYatayatHome({super.key});

  @override
  SaralYatayatHomeState createState() => SaralYatayatHomeState();
}

class SaralYatayatHomeState extends State<SaralYatayatHome> {
  int _currentPageIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

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
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const Icon(Icons.car_repair),
        title: const Text('Saral Yatayat'),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe gesture
        children: const [
          SaralRoutes(),
          PageWidget(pageNumber: 2),
          PageWidget(pageNumber: 3),
        ],
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

class PageWidget extends StatelessWidget {
  final int pageNumber;

  const PageWidget({super.key, required this.pageNumber});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Text(
          'Page $pageNumber',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
