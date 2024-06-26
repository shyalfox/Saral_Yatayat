import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:saral_yatayat/firestore/firestore_query.dart';
import 'package:saral_yatayat/routes/item.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';

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
  double fare = 0;
  String fareValidDistance = '';
  double finalFare = 0;
  String discountEligibility = '';
  String userGender = '';
  String userDisabilityStatus = '';
  String isUserStudent = '';
  String userId = '';
  late Map<String, dynamic> savedData;
  // Future<void> saveOrderDetails() async {
  //   try {
  //     // Generate a new order ID
  //     String orderId = FirebaseFirestore.instance.collection('orders').doc().id;

  //     // Check if the 'orders' collection exists, if not, create it
  //     CollectionReference ordersCollection =
  //         FirebaseFirestore.instance.collection('orders');

  //     // Save order details
  //     await ordersCollection.doc(orderId).set({
  //       'orderId': orderId,
  //       'userId': userId,
  //       'originLocation': originLocation,
  //       'destinationLocation': destinationLocation,
  //       'distance': distance,
  //       'discount': discount,
  //       'discountEligibility': discountEligibility,
  //       // Add more fields as needed
  //     });

  //     // Show a success message or perform any other actions after saving the order
  //   } catch (error) {
  //     // Handle errors
  //     if (kDebugMode) {
  //       print('Failed to save order: $error');
  //     }
  //   }
  // }

  void fareCalculator() {
    if (isUserStudent == "Yes" && userDisabilityStatus == "Yes") {
      discount = 15;
    } else if (isUserStudent == "Yes" || userDisabilityStatus == "Yes") {
      discount = 10;
    }

    if (distance <= 5) {
      fare = 20;
      fareValidDistance = '0-5km';
    } else if (distance > 5 && distance < 10) {
      fare = 25;
      fareValidDistance = '0-10km';
    } else if (distance > 10 && distance < 15) {
      fare = 30;
      fareValidDistance = '0-15km';
    } else {
      fare = 35;
      fareValidDistance = '0-25km';
    }
    finalFare = fare - ((discount * fare) / 100);
    if (kDebugMode) {
      print(fare);
      print(discount);
    }
  }

  Future<void> getData() async {
    Map<String, dynamic> yummyData = await retrievePersonalizedDaata(userId);
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

  String findLocationTitle(String coordinates) {
    for (Item item in chakrapath) {
      if (item.locCoordinates == coordinates) {
        return item.title;
      }
    }
    return 'Not found';
  }

  // DateTime currentDate = DateTime.now();
  // print('Current Date: ${DateFormat('yyyy-MM-dd').format(currentDate)}');

  // // Get date after seven days
  // DateTime dateAfterSevenDays = currentDate.add(Duration(days: 7));
  // print('Date After Seven Days: ${DateFormat('yyyy-MM-dd').format(dateAfterSevenDays)}');

  void showSuccess(Function(AlertDialog) showDialogCallback) async {
    // Combine the information into a single string
    String qrData =
        '$originLocation|$destinationLocation|$fare|$discount|$finalFare|$fareValidDistance';
    String orderId = DateTime.now().millisecondsSinceEpoch.toString();

    // Generate the QR code image and convert it to bytes
    ByteData? byteData = await QrPainter(
      data: orderId,
      version: QrVersions.auto,
      gapless: false,
    ).toImageData(200);

    if (byteData != null) {
      Uint8List qrCodeBytes = byteData.buffer.asUint8List();
      await FirebaseFirestore.instance.collection('qr_codes').add({
        'orderId': orderId,
        'originLocation': originLocation,
        'destinationLocation': destinationLocation,
        'fareValidDistance': fareValidDistance,
        'fareValue': 'Rs $finalFare',
        'discount': discount,

        'userId': userId,
        'qr_data': qrData,
        'status': 'Unclaimed',
        'current_date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'date_after_seven_days': DateFormat('yyyy-MM-dd')
            .format(DateTime.now().add(const Duration(days: 7))),

        // Add other fields as needed
      });
      // Create the QR code dialog
      AlertDialog qrCodeDialog = AlertDialog(
        title: const Text('QR Code'),
        content: SizedBox(
          width: 200, // Adjust the width as needed
          height: 300, // Adjust the height as needed
          child: Column(
            children: [
              Image.memory(qrCodeBytes),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Purchase Successful! ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                'You Can find Your tickets in Profile  Section',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      );

      // Invoke the callback function to show the dialog
      showDialogCallback(qrCodeDialog);
    } else {
      // Handle the case where byteData is null
    }
  }

  @override
  void initState() {
    super.initState();
    distance = widget.distance;
    getCurrentUser();
    getData();
    getData().then((_) {
      // Call fareCalculator after getData is completed
      fareCalculator();
      // Call setState to update the UI with the calculated fare
    });
    originLocation = findLocationTitle(widget.originLocation);
    destinationLocation = findLocationTitle(widget.destinationLocation);
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
            ListTile(
              title: const Text('Fare Amount'),
              subtitle: Text('Rs $fare'),
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
            ListTile(
              title: const Text('Final Amount'),
              subtitle: Text(
                'Rs $finalFare',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20.0),
            Center(
              child: Column(
                children: [
                  const Text(
                    'Note',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                      'This ticket can be exchanged for any Trip between $fareValidDistance'),
                ],
              ),
            ),
            const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showSuccess((AlertDialog dialog) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return dialog;
                        },
                      );
                    });
                  },
                  child: const Text('Order'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
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
