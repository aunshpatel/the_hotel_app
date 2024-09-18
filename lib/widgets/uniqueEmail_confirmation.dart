import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> isEmailAlreadyRegistered(String email, String userCollection) async {
  try {
    // Query Firestore for a document where the email field matches
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(userCollection).where('email', isEqualTo: email).limit(1).get();

    // If the query snapshot is not empty, the email already exists
    return querySnapshot.docs.isNotEmpty;
  } catch (e) {
    print('Error checking email: $e');
    return false;
  }
}
