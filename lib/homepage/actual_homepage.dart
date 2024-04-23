import 'package:flutter/material.dart';
import 'package:saral_yatayat/homepage/home_page.dart';
import '../login_logout/logout.dart';

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
        child: Column(
          children: [
            Text('Welcome to the personalized page! $username'),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SaralYatayatHome()));
                },
                child: const Text('go'))
          ],
        ),
      ),
    );
  }
}
