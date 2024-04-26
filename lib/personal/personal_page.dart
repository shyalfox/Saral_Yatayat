import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:saral_yatayat/login_logout/logout.dart';
import 'package:saral_yatayat/firestore/firestore_query.dart';
import 'package:saral_yatayat/personal/personal_details.dart';
import 'dart:async';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = '';
  String emailUser = '';
  String userContact = '';
  String userGender = '';
  String userDisabilityStatus = '';
  String isUserStudent = '';
  String userId = '';
  String imgUrl = '';
  late Map<String, dynamic> savedData;
  late Map<String, dynamic> savedYummyData;
  bool isLoading = true;

  void setGenderImage() {
    if (userGender == 'Male') {
      imgUrl = 'assets/images/male.png';
    } else {
      imgUrl = 'assets/images/female.png';
    }
  }

  Future<void> getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    } else {
      // Handle the case where user is null
      if (kDebugMode) {
        if (kDebugMode) {
          print("User is not authenticated");
        }
      }
    }
  }

  Future<void> getData() async {
    Map<String, dynamic> yummyData = await retrievePersonalizedDaata(userId);
    Map<String, dynamic> yummyUserData =
        await retrievePersonalizedUserData(userId);

    setState(() {
      savedData = yummyData;
      savedYummyData = yummyUserData;
      userGender = savedData['gender'] ??
          ''; // Use null-aware operator to handle null values
      userDisabilityStatus = savedData['has_disabilities'] ?? '';
      isUserStudent = savedData['is_student'] ?? '';
      userName = savedYummyData['name'];
      emailUser = savedYummyData['email'];
      userContact = savedYummyData['contact_number'];
    });
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
    getCurrentUser();
    getData();

    setGenderImage();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          InkWellCardPersonal(title: 'Profile Page', onTap: () {}),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Example background color
                  borderRadius:
                      BorderRadius.circular(10), // Example border radius
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.grey.withOpacity(0.5), // Example shadow color
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // Example shadow offset
                    ),
                  ],
                ),
                child: Image.asset(
                  imgUrl,
                  width: 100, // Example width
                  height: 100, // Example height
                  fit: BoxFit
                      .contain, // Ensure the entire image is visible without cropping or zooming
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          InkWellCardPersonal(
              title: 'Personal Details',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PersonalDetails(
                              userGender: userGender,
                              userDisabilityStatus: userDisabilityStatus,
                              isUserStudent: isUserStudent,
                              userId: userId,
                              userName: userName,
                              emailUser: emailUser,
                              userContact: userContact,
                            )));
              }),
          const SizedBox(height: 20),
          InkWellCardPersonal(title: 'Tickets', onTap: () {}),
          const SizedBox(height: 20),
          InkWellCardPersonal(
              title: 'FeedBacks/Questions',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Feebacks/Questions'),
                      content: const Text('Feature Coming Soon'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              }),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  logout(context);
                },
                icon: const Icon(
                    Icons.logout), // Icon to be displayed before the text
                label: const Text(
                    'Sign Out'), // Text to be displayed on the button
              )
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class InkWellCardPersonal extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const InkWellCardPersonal(
      {super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 1,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                // Add your report or feedback form here
              ],
            ),
          ),
        ),
      ),
    );
  }
}
