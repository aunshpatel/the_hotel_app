import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_hotel_app/widgets/consts.dart';

Future<List<Map<String, dynamic>>> getUserData() async {
  QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('registered_user').where("email", isEqualTo: currentUserEmailID.toString()).get();
  List<Map<String, dynamic>> userData = snapshot.docs.map((doc) => doc.data()).toList();
  return userData;
}

Future<Map<String, dynamic>> getPropertyData() async {
  try {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('room_data').doc(roomID).get();
    if (documentSnapshot.exists) {
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      return data;
    } else {
      throw Exception("Document not found");
    }
  } catch(e) {
    throw Exception("Error fetching document: $e");
  }
}

Future<List<Map<String, dynamic>>> getPropertyBookings() async {
  QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('booking_data').where("roomID", isEqualTo: roomID).get();
  List<Map<String, dynamic>> propertyBookingData = snapshot.docs.map((doc) => doc.data()).toList();
  return propertyBookingData;
}