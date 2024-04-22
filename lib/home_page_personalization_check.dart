import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saral_yatayat/actual_homepage.dart';
import 'package:saral_yatayat/home_page_personalize.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.username});
  final String username;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late String _userId;
  late String username;
  late StreamController<DocumentSnapshot> _userDataStreamController;

  void _updateUserDataStream() {
    FirebaseFirestore.instance
        .collection('user_data')
        .where('userId', isEqualTo: _userId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        _userDataStreamController.add(snapshot.docs.first);
      } else {
        Map<String, dynamic> userData = {
          'userId': _userId,
          'gender': null,
          'is_student': null,
          'has_disabilities': null,
          'is_Personalized': false,
        };

        FirebaseFirestore.instance
            .collection('user_data')
            .add(userData)
            .then((docRef) => docRef.get())
            .then((snapshot) {
          _userDataStreamController.add(snapshot);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser!.uid;
    username = widget.username;
    _userDataStreamController = StreamController<DocumentSnapshot>();
    _updateUserDataStream();
  }

  @override
  void dispose() {
    _userDataStreamController.close(); // Close the stream controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _userDataStreamController.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator()); // Or any loading indicator
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Text('Document does not exist');
        }

        Map<String, dynamic> userData =
            snapshot.data!.data() as Map<String, dynamic>;
        if (kDebugMode) {
          print('${userData['is_Personalized']}hello');
        }

        if (userData['is_Personalized'] == true) {
          // Build your personalized UI here
          return TheRealHomePage(username: username);
        } else {
          // Navigate to the set() page if is_personalized is false
          // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => HomePagePersonalize(
          //         username: username,
          //       ),
          //     ),
          //   );
          // });
          return HomePagePersonalize(
              username:
                  username); // Placeholder container// Placeholder container
        }
      },
    );
  }
}
