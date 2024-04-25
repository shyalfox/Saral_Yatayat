import 'package:flutter/material.dart';

class InkWellCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const InkWellCard({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 100,
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
