import 'package:flutter/material.dart';

class SaralYatayatHome extends StatelessWidget {
  const SaralYatayatHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Page Slider Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  // ignore: unused_field
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
        title: const Text('Page Slider Example'),
      ),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              PageWidget(pageNumber: 1),
              PageWidget(pageNumber: 2),
              PageWidget(pageNumber: 3),
            ],
          ),
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: FloatingActionButton(
              onPressed: () => _onBottomNavItemTapped(0),
              child: const Icon(Icons.home),
            ),
          ),
          Positioned(
            bottom: 20.0,
            left: 20.0,
            child: FloatingActionButton(
              onPressed: () => _onBottomNavItemTapped(1),
              child: const Icon(Icons.search),
            ),
          ),
          Positioned(
            top: 20.0,
            right: 20.0,
            child: FloatingActionButton(
              onPressed: () => _onBottomNavItemTapped(2),
              child: const Icon(Icons.person),
            ),
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
      child: Text(
        'Page $pageNumber',
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}
