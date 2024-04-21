import 'package:saral_yatayat/firebase_options.dart';
import 'package:saral_yatayat/sliding_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue, background: Colors.blue.shade400),
          appBarTheme: const AppBarTheme(
              backgroundColor: Color.fromARGB(144, 66, 164, 245),
              elevation: 4)),
      home: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const SlidingPage();
  }
}
