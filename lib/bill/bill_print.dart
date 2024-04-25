import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saral_yatayat/routes/item.dart';

class TicketBookingPage extends StatefulWidget {
  const TicketBookingPage(
      {super.key,
      required this.originLocation,
      required this.destinationLocation,
      required this.distance});
  final String originLocation;
  final String destinationLocation;
  final double distance;

  @override
  TicketBookingPageState createState() => TicketBookingPageState();
}

class TicketBookingPageState extends State<TicketBookingPage> {
  late String originLocation;
  late String destinationLocation;
  late double distance;
  double discount = 0.0;
  String discountEligibility = '';

  String userGender = '';
  String userDisabilityStatus = '';
  String isUserStudent = '';
  String userId = '';
  late Map<String, dynamic> savedData;
  Future<void> discountCalculator() async {
    setState(() {
      if (isUserStudent == 'Yes' && userDisabilityStatus == 'Yes') {
        discount = 15;
        discountEligibility =
            'You are eligible for Student & Disability Discount';
      } else if (isUserStudent == 'Yes' && userDisabilityStatus == 'No') {
        discount = 10;
        discountEligibility = 'You are eligible for student discount';
      } else if (isUserStudent == 'No' && userDisabilityStatus == 'Yes') {
        discount = 10;
        discountEligibility = 'You are eligible for disability discount';
      } else {
        discount = 0;
        discountEligibility = 'Sorry you are not eligible for discounts';
      }
    });
  }

  Future<void> getData() async {
    Map<String, dynamic> yummyData = await retrievePersonalizedDaata();
    setState(() {
      savedData = yummyData;
      userGender = savedData['gender'] ??
          ''; // Use null-aware operator to handle null values
      userDisabilityStatus = savedData['has_disabilities'] ?? '';
      isUserStudent = savedData['is_student'] ?? '';
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

  String findLocationTitle(String coordinates) {
    for (Item item in chakrapath) {
      if (item.locCoordinates == coordinates) {
        return item.title;
      }
    }
    return 'Not found';
  }

  @override
  void initState() {
    distance = widget.distance;
    getCurrentUser();
    getData();
    originLocation = findLocationTitle(widget.originLocation);
    destinationLocation = findLocationTitle(widget.destinationLocation);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Booking Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('Origin Location'),
              subtitle: Text(originLocation),
            ),
            ListTile(
              title: const Text('Destination Location'),
              subtitle: Text(destinationLocation),
            ),
            ListTile(
              title: const Text('Total Distance'),
              subtitle: Text('$distance km'),
            ),
            isUserStudent == 'Yes' && userDisabilityStatus == 'Yes'
                ? const ListTile(
                    title: Text('15% Discount'),
                    subtitle: Text(
                        'You are eligible for Student & Disability Discount'),
                  )
                : isUserStudent == 'Yes' && userDisabilityStatus == 'No'
                    ? const ListTile(
                        title: Text('10% Discount'),
                        subtitle: Text('You are eligible for student discount'),
                      )
                    : isUserStudent == 'No' && userDisabilityStatus == 'Yes'
                        ? const ListTile(
                            title: Text('10% Discount'),
                            subtitle: Text(
                                'You are eligible for disability discount'),
                          )
                        : const ListTile(
                            title: Text('No Discount'),
                            subtitle: Text(
                                'Sorry you are not eligible for discounts'),
                          ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Perform order action
                  },
                  child: const Text('Order'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Perform cancel action
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
