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

Future<Map<String, dynamic>> retrievePersonalizedUserData(String userId) async {
  Map<String, dynamic> savedData = {};
  try {
    // Query for the document where the specified userId exists
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    // Check if the document with the specified userId exists
    if (documentSnapshot.exists) {
      // Populate savedData with the retrieved values
      savedData = documentSnapshot.data() as Map<String, dynamic>;
    }

    if (kDebugMode) {
      print('Data retrieved');
    }
  } catch (error) {
    if (kDebugMode) {
      print('Failed to retrieve data: $error');
    }
  }
  return savedData;
}

Future<void> updateDataToFirestore(
    String userId,
    String? userName,
    String? userGender,
    String? userContact,
    String? isStudent,
    String? userDisabilityStatus) async {
  try {
    // Update the existing document with the new values
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'name': userName,
      'contact_number': userContact,
    });
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('user_data')
        .where('userId', isEqualTo: userId)
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
        'gender': userGender,
        'is_student': isStudent,
        'has_disabilities': userDisabilityStatus,
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
