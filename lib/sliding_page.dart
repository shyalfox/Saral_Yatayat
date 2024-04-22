import 'package:saral_yatayat/login_page.dart';
import 'package:saral_yatayat/sliding_page_content.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SlidingPage extends StatefulWidget {
  const SlidingPage({super.key});

  @override
  State<SlidingPage> createState() => _SlidingPageState();
}

class _SlidingPageState extends State<SlidingPage> {
  final PageController _pageController =
      PageController(initialPage: SlidingPageContent.pageIndex);
  final int slidingPages = 4;

  bool showSkip = true;
  bool showStarted = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(5),
        child: Container(
          decoration: BoxDecoration(color: Colors.blue.shade400),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(
          10.0,
        ),
        child: Card(
          elevation: 10,
          color: Colors.blue.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      SlidingPageContent.pageIndex = index;
                      showSkip = index < slidingPages - 1;
                      index == slidingPages - 1
                          ? showStarted = true
                          : showStarted = false;
                    });
                  },
                  children: const [
                    SlidingPageContent(
                      titleText: 'Hello1',
                      subtitleText: 'Welcome to Saral Yatayat',
                      imgUrl: 'assets/images/slide1.jpg',
                      captionText: 'Let \'s Start The Journey',
                      pageIndex: 0,
                    ),
                    SlidingPageContent(
                      titleText: 'Hello2',
                      subtitleText: 'Welcome to Saral Yatayat',
                      imgUrl: 'assets/images/slide1.jpg',
                      captionText: 'Let \'s Start The Journey',
                      pageIndex: 1,
                    ),
                    SlidingPageContent(
                      titleText: 'Hello3',
                      subtitleText: 'Welcome to Saral Yatayat',
                      imgUrl: 'assets/images/slide1.jpg',
                      captionText: 'Let \'s Start The Journey',
                      pageIndex: 2,
                    ),
                    SlidingPageContent(
                      titleText: 'Hello4',
                      subtitleText: 'Welcome to Saral Yatayat',
                      imgUrl: 'assets/images/slide1.jpg',
                      captionText: 'Let \'s Start The Journey',
                      pageIndex: 3,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: showSkip,
                    child: SizedBox(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            setState(() {
                              SlidingPageContent.pageIndex = slidingPages - 1;
                              _pageController.jumpToPage(slidingPages - 1);
                            });
                          },
                          child: const Text(
                            'Skip',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      ],
                    )),
                  ),
                  Visibility(
                    visible: showStarted,
                    child: SizedBox(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                          },
                          child: const Text(
                            'Get Started',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      ],
                    )),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 50,
                child: AnimatedSmoothIndicator(
                  activeIndex: SlidingPageContent.pageIndex,
                  count: slidingPages,
                  effect: const WormEffect(),
                ),
              )
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
