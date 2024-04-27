import 'dart:async';

import 'package:flutter/material.dart';

class SaralPages extends StatefulWidget {
  const SaralPages({super.key});

  @override
  State<SaralPages> createState() => _SaralPagesState();
}

class _SaralPagesState extends State<SaralPages> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  // ignore: unused_field
  late Timer _timer;
  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPageIndex < 2) {
        _currentPageIndex++;
      } else {
        _currentPageIndex = 0;
      }
      _pageController.animateToPage(
        _currentPageIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.26,
              child: Card(
                elevation: 10,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (int index) {
                    setState(() {
                      _currentPageIndex = index;
                    });
                  },
                  children: <Widget>[
                    Image.asset(
                      'assets/images/saralboss.jpg',
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      'assets/images/saralboss.jpg',
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      'assets/images/saralboss.jpg',
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Our CEO says Hi!!!!!!!!!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
              )
            ],
          )
        ],
      ),
    );
  }
}
