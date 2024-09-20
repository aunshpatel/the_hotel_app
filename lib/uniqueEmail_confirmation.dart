import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_hotel_app/widgets/consts.dart';

Future<bool> isEmailAlreadyRegistered(String email) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('registered_user').where('email', isEqualTo: email).limit(1).get();
    return querySnapshot.docs.isNotEmpty;
  } catch (e) {
    print('Error checking email: $e');
    return false;
  }
}

Future<List<Map<String, DateTime>>> getRoomBookings() async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('booking_data').where('roomID', isEqualTo: roomID).get();

  return snapshot.docs.map((doc) {
    return {
      'checkinDate': (doc['checkInDate'] as Timestamp).toDate(),
      'checkoutDate': (doc['checkOutDate'] as Timestamp).toDate(),
    };
  }).toList();
}
