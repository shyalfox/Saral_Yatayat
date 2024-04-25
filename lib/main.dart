import 'package:flutter/foundation.dart';

import 'package:saral_yatayat/firebase_options.dart';
import 'package:saral_yatayat/homepage/home_page.dart';
import 'package:saral_yatayat/slidingpage/sliding_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
              // User is logged in, retrieve user data and navigate to HomePage
              return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .get(),
                builder: (context, userDataSnapshot) {
                  if (userDataSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    // Waiting for user data retrieval
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    // User data retrieval completed
                    // String userName =
                    //     userDataSnapshot.data!.get('name') ?? 'Unknown';
                    if (kDebugMode) {
                      print('userName');
                    }
                    return const SaralYatayatHome();
                  }
                },
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
