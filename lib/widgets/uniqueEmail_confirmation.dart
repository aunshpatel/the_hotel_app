import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> isEmailAlreadyRegistered(String email) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('registered_user').where('email', isEqualTo: email).limit(1).get();
    return querySnapshot.docs.isNotEmpty;
  } catch (e) {
    print('Error checking email: $e');
    return false;
  }
}