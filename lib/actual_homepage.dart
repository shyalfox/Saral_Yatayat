import 'package:flutter/material.dart';
import 'database/logout.dart';

class TheRealHomePage extends StatefulWidget {
  const TheRealHomePage({super.key, required this.username});
  final String username;

  @override
  State<TheRealHomePage> createState() => _TheRealHomePageState();
}

class _TheRealHomePageState extends State<TheRealHomePage> {
  late String username;
  @override
  void initState() {
    super.initState();
    username = widget.username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Home Page'),
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome to the personalized page! $username'),
      ),
    );
  }
}
