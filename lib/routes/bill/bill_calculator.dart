import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saral_yatayat/routes/bill/bill_print.dart';

class BillCalculator extends StatefulWidget {
  const BillCalculator(
      {super.key,
      required this.distance,
      required this.selectedOrigin,
      required this.selectedDestination});
  final String distance;
  final String? selectedOrigin;
  final String? selectedDestination;

  @override
  State<BillCalculator> createState() => _BillCalculatorState();
}

class _BillCalculatorState extends State<BillCalculator> {
  String userGender = '';
  String userDisabiliyStatus = '';
  String isUserStudent = '';
  String userId = '';
  late String distance;
  late String selectedOrigin;
  late String selectedDestinatiion;
  double distances = 0.0;
  late Map<String, dynamic> savedData;

  Future<void> getData() async {
    Map<String, dynamic> yummyData = await retrievePersonalizedDaata();
    setState(() {
      savedData = yummyData;
      userGender = savedData['gender'] ??
          ''; // Use null-aware operator to handle null values
      userDisabiliyStatus = savedData['has_disabilities'] ?? '';
      isUserStudent = savedData['is_student'] ?? '';
      String numericString = distance.replaceAll(RegExp(r'[^0-9.]'), '');
      distances = double.parse(numericString);
    });
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
        print("User is not authenticated");
      }
    }
  }

  Future<Map<String, dynamic>> retrievePersonalizedDaata() async {
    Map<String, dynamic> savedData = {};
    try {
      // Query for the document where the specified userId exists
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('user_data')
          .where('userId', isEqualTo: userId)
          .get();

      // Check if there's a document with the specified userId
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document since there should be only one document per userId
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

        DocumentSnapshot updatedDocumentSnapshot = await FirebaseFirestore
            .instance
            .collection('user_data')
            .doc(documentSnapshot.id)
            .get();

        // Populate savedData with the retrieved values
        savedData = updatedDocumentSnapshot.data() as Map<String, dynamic>;
      }

      if (kDebugMode) {
        print('data  retrieved');
      }
    } catch (error) {
      if (kDebugMode) {
        print('failed to retrieve');
      }
    }
    return savedData;
  }

  @override
  void initState() {
    distance = widget.distance;
    getCurrentUser();
    getData();
    selectedOrigin = widget.selectedOrigin!;
    selectedDestinatiion = widget.selectedDestination!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(distances.toString()),
        ElevatedButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TicketBookingPage(
                          originLocation: selectedOrigin,
                          destinationLocation: selectedDestinatiion,
                          distance: distances,
                        ))),
            child: const Text('Press'))
      ],
    );
  }
}
