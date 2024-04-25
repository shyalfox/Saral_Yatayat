import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

Future<Map<String, dynamic>> retrievePersonalizedDaata(String userId) async {
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
