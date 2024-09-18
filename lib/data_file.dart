import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_hotel_app/widgets/consts.dart';

Future<List<Map<String, dynamic>>> getUserData() async {
  QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('registered_user').where("email", isEqualTo: currentUser.toString()).get();
  List<Map<String, dynamic>> userData = snapshot.docs.map((doc) => doc.data()).toList();
  return userData;
}
