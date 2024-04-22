// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saral_yatayat/home_page_personalization_check.dart';
import 'database/logout.dart';

class HomePagePersonalize extends StatefulWidget {
  const HomePagePersonalize({super.key, required this.username});
  final String username;

  @override
  State<HomePagePersonalize> createState() => _HomePagePersonalizeState();
}

class _HomePagePersonalizeState extends State<HomePagePersonalize> {
  late String username;

  late String _userId;
  int _currentPageIndex = 0;
  final PageController _pageController = PageController();
  String? _selectedGender;
  String? _areYouStudent;
  String? _haveDisabilities;

  Future<void> _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      _userId = user!.uid;
    });
  }

  void _goToNextPage() {
    if (_currentPageIndex < 2) {
      setState(() {
        _currentPageIndex++;
      });
      _pageController.animateToPage(
        _currentPageIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  Future<void> _saveDataToFirestore() async {
    bool status = true;
    try {
      // Query for the document where the specified userId exists
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('user_data')
          .where('userId', isEqualTo: _userId)
          .get();

      // Check if there's a document with the specified userId
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document since there should be only one document per userId
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

        // Update the existing document with the new values
        await FirebaseFirestore.instance
            .collection('user_data')
            .doc(documentSnapshot.id)
            .update({
          'gender': _selectedGender,
          'is_student': _areYouStudent,
          'has_disabilities': _haveDisabilities,
          'is_Personalized': status,
        });
      }

      if (kDebugMode) {
        print('data save to forestore');
      }
    } catch (error) {
      if (kDebugMode) {
        print('failed data save to forestore');
      }
    }
  }

  // Future<void> _saveDataToFirestore() async {
  //   try {
  //     FirebaseFirestore.instance.collection('user_data').add({
  //       'userId': _userId,
  //       'gender': _selectedGender,
  //       'is_student': _areYouStudent,
  //       'has_disabilities': _haveDisabilities,
  //       'is_Personalized': userPersonalized,
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Data saved to Firestore')),
  //     );
  //   } catch (error) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to save data: $error')),
  //     );
  //   }
  // }

  @override
  void initState() {
    _getCurrentUser();
    username = widget.username;
    super.initState();
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
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        children: [
          _buildWelcomePage(),
          _buildGenderPage(),
          _buildStudentAndDisabilitiesPage(),
        ],
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Welcome! $username'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _goToNextPage,
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('What is your gender?'),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: _selectedGender,
            onChanged: (value) {
              setState(() {
                _selectedGender = value;
              });
            },
            items: const [
              DropdownMenuItem(value: 'Male', child: Text('Male')),
              DropdownMenuItem(value: 'Female', child: Text('Female')),
              DropdownMenuItem(value: 'Others', child: Text('Others')),
            ],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Select your gender',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _goToNextPage,
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentAndDisabilitiesPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Are you a student?'),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: _areYouStudent,
            onChanged: (value) {
              setState(() {
                _areYouStudent = value;
              });
            },
            items: const [
              DropdownMenuItem(value: 'Yes', child: Text('Yes')),
              DropdownMenuItem(value: 'No', child: Text('No')),
            ],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Select Option?',
            ),
          ),
          const SizedBox(height: 20),
          const Text('Select Option'),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: _haveDisabilities,
            onChanged: (value) {
              setState(() {
                _haveDisabilities = value;
              });
            },
            items: const [
              DropdownMenuItem(value: 'Yes', child: Text('Yes')),
              DropdownMenuItem(value: 'No', child: Text('No')),
            ],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Do you have disabilities?',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _saveDataToFirestore();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(
                    username: username,
                  ),
                ),
                (route) => false,
              );
            },
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }
}
