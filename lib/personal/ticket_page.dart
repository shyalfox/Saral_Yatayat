import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({super.key, required this.userId});
  final String userId;

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  late String userId;
  List<Map<String, dynamic>> qrCodes = [];
  bool isLoading = true;
  List<String> firstThreeWordsList = [];

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    getData();
    Timer(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> getData() async {
    List<Map<String, dynamic>> fetchedQrCodes = await fetchQrCodes(userId);
    setState(() {
      qrCodes = fetchedQrCodes;
      for (int i = 0; i < qrCodes.length; i++) {
        String inputString = '${qrCodes[i]['qr_data']}';
        List<String> parts = inputString.split('|');

        // Extract the first three elements
        String firstThreeWords = parts.take(3).join(' | ');

        // Add the extracted string to the list
        firstThreeWordsList.add(firstThreeWords);
      }
    });
  }

  Future<List<Map<String, dynamic>>> fetchQrCodes(String userId) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('qr_codes')
        .where('userId', isEqualTo: userId)
        .get();

    List<Map<String, dynamic>> qrCodes = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data();
      data['docId'] = doc.id; // Add document ID to the data map
      return data;
    }).toList();
    return qrCodes;
  }

  void showData(Function(AlertDialog) showDialogCallback, int index) async {
    String qrData = '${qrCodes[index]['orderId']}';
    String expireDate = '${qrCodes[index]['date_after_seven_days']}';
    String createDate = '${qrCodes[index]['current_date']}';
    String fareAmount = '${qrCodes[index]['fareValue']}';
    String validDistance = '${qrCodes[index]['fareValidDistance']}';
    String locataions =
        '${qrCodes[index]['originLocation']} to ${qrCodes[index]['destinationLocation']}';

    ByteData? byteData = await QrPainter(
      data: qrData,
      version: QrVersions.auto,
      gapless: false,
    ).toImageData(200);
    if (byteData != null) {
      Uint8List qrCodeBytes = byteData.buffer.asUint8List();
      AlertDialog qrCodeDialog = AlertDialog(
        title: const Text('QR Code'),
        content: SizedBox(
          width: 300, // Adjust the width as needed
          height: 400, // Adjust the height as needed
          child: Column(
            children: [
              Image.memory(qrCodeBytes),
              const SizedBox(
                height: 20,
              ),
              Text(locataions),
              Text('Creation Date: $createDate'),
              Text('Expiry Date: $expireDate'),
              Text('Fare: $fareAmount'),
              Text('Excahngable for trip $validDistance')
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
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
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (qrCodes.isEmpty) {
      return Stack(
        children: [
          const Scaffold(
            body: Center(
              child: Text(
                'No tickets found',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Positioned(
            bottom: 60, // Adjust the distance from the bottom as needed
            right: 16.0, // Adjust the distance from the right as needed
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back),
            ),
          ),
        ],
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Query Example'),
      ),
      body: ListView.builder(
        itemCount: qrCodes.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              // Call the showData function and provide the showDialogCallback
              showData((dialog) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return dialog;
                  },
                );
              }, index);
            },
            child: Container(
              width: double.infinity,
              height: 100,
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Center(
                  child: ListTile(
                    title: Text('Order Details: ${firstThreeWordsList[index]}'),
                    subtitle: Text('Status: ${qrCodes[index]['status']}'),
                    // Add other fields as needed
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
