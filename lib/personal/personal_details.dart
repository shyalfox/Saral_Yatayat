import 'dart:async';

import 'package:flutter/material.dart';
import 'package:saral_yatayat/firestore/firestore_query.dart';
import 'package:saral_yatayat/homepage/home_page.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails(
      {super.key,
      required this.userGender,
      required this.userDisabilityStatus,
      required this.isUserStudent,
      required this.userId,
      required this.userName,
      required this.emailUser,
      required this.userContact});
  final String userGender;
  final String userDisabilityStatus;
  final String isUserStudent;
  final String userId;
  final String userName;
  final String emailUser;
  final String userContact;

  @override
  State<PersonalDetails> createState() => PersonalDetailsState();
}

class PersonalDetailsState extends State<PersonalDetails> {
  TextEditingController fullName = TextEditingController();
  TextEditingController contactNumber = TextEditingController();
  String? userName = 'Hello';
  late String userId;

  late String? emailUser;
  late String? userContact;

  late String? isStudent;

  late String? userDisabilityStatus;

  late String? userGender;
  late String? isStudentController;

  late String? userDisabilityStatusController;

  late String? userGenderController;

  // ignore: unused_element

  void showFillAllFields() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: const Text(
              "Please fill in all fields\nContact Number must be  10 digits long."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
    return;
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Details'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  controller: fullName,
                ),
                TextField(
                  decoration:
                      const InputDecoration(labelText: 'Contact Number'),
                  controller: contactNumber,
                ),
                DropdownButtonFormField<String>(
                  value: userGender,
                  onChanged: (String? newValue) {
                    setState(() {
                      userGenderController = newValue!;
                    });
                  },
                  items:
                      <String>['Male', 'Female', 'Other'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(labelText: 'Gender'),
                ),
                DropdownButtonFormField<String>(
                  value: isStudent,
                  onChanged: (String? newValue) {
                    setState(() {
                      isStudentController = newValue!;
                    });
                  },
                  items: <String>['Yes', 'No'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration:
                      const InputDecoration(labelText: 'Student Status'),
                ),
                DropdownButtonFormField<String>(
                  value: userDisabilityStatus,
                  onChanged: (String? newValue) {
                    setState(() {
                      userDisabilityStatusController = newValue!;
                    });
                  },
                  items: <String>['Yes', 'No'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(labelText: 'Disability'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (fullName.text.isEmpty ||
                    contactNumber.text.isEmpty ||
                    contactNumber.text.length != 10) {
                  showFillAllFields();
                } else {
                  showDialog(
                    context: context,
                    barrierDismissible:
                        false, // Prevent dialog from being dismissed by tapping outside
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        content: Row(
                          children: [
                            CircularProgressIndicator(), // Loading indicator
                            SizedBox(width: 20),
                            Text("Processing..."),
                          ],
                        ),
                      );
                    },
                  );
                  Future.delayed(const Duration(seconds: 2), () {
                    // Hide loading indicator after 2 seconds
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    _showConfirmationDialog();
                  });
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void setValues() {
    userName = fullName.text;
    userContact = contactNumber.text;
    userGender = userGenderController;
    userDisabilityStatus = userDisabilityStatusController;
    isStudent = isStudentController;
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Do you want to save these changes?'),
          actions: [
            TextButton(
              onPressed: () {
                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible:
                      false, // Prevent dialog from being dismissed by tapping outside
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      content: Row(
                        children: [
                          CircularProgressIndicator(), // Loading indicator
                          SizedBox(width: 20),
                          Text("Saving..."),
                        ],
                      ),
                    );
                  },
                );
                setValues();
                updateDataToFirestore(userId, userName, userGender, userContact,
                    isStudent, userDisabilityStatus);

                // Perform asynchronous operations
                Future.delayed(const Duration(seconds: 1), () {
                  // Set new values and update data to Firestore

                  // Close loading indicator dialog
                  Navigator.of(context).pop();

                  // Navigate to the next screen
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SaralYatayatHome(),
                    ),
                    (route) => false,
                  );

                  // Show success message using SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Data uploaded successfully'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                });
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showEditDialog(); // Reopen the edit dialog if user cancels confirmation
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    isStudent = widget.isUserStudent;
    userDisabilityStatus = widget.userDisabilityStatus;
    userGender = widget.userGender;
    userName = widget.userName;
    emailUser = widget.emailUser;
    userContact = widget.userContact;
    //putting default value for edit menu in case user only edits few options
    userGenderController = userGender;
    userDisabilityStatusController = userDisabilityStatus;
    isStudentController = isStudent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {},
          ),
        ],
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text('$userName \'s Profile'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Full Name: $userName',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Email: $emailUser',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Contact Number: $userContact',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Gender: $userGender',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  isStudent == "Yes"
                      ? 'Student Status: Active'
                      : 'Student Status: Non Active',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  userDisabilityStatus == "Yes"
                      ? 'Disability: Yes'
                      : 'Disability: No',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _showEditDialog();
                    fullName.text = userName!;
                    contactNumber.text = userContact!;
                  },
                  icon: const Icon(
                      Icons.settings), // Icon to be displayed before the text
                  label: const Text(
                      'Edit Details'), // Text to be displayed on the button
                )
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 20,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.arrow_back),
            ),
          )
        ],
      ),
    );
  }
}
