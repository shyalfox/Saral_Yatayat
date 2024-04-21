import 'package:flutter/material.dart';

class SlidingPageContent extends StatelessWidget {
  final String titleText;
  final String subtitleText;
  final String imgUrl;
  final String captionText;
  static int pageIndex = 0;

  const SlidingPageContent({
    super.key,
    required this.titleText,
    required this.subtitleText,
    required this.imgUrl,
    required this.captionText,
    required int pageIndex,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: ListTile(
            title: Text(
              titleText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 36,
              ),
            ),
            subtitle: Text(
              subtitleText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        Container(
          constraints: const BoxConstraints.expand(height: 400),
          child: Image.asset(imgUrl),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          captionText,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ],
    );
  }
}
