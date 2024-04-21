import 'package:saral_yatayat/firebase_options.dart';
import 'package:saral_yatayat/sliding_page.dart';
import 'package:saral_yatayat/home_page.dart'; // Import your HomePage widget
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          background: Colors.blue.shade400,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(144, 66, 164, 245),
          elevation: 4,
        ),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Waiting for authentication check
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            // Authentication check completed
            if (snapshot.hasData) {
              // User is logged in, navigate to HomePage
              return const HomePage(
                username: 'User',
              );
            } else {
              // User is not logged in, navigate to SlidingPage
              return const SlidingPage();
            }
          }
        },
      ),
    );
  }
}
