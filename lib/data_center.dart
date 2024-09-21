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

Future<List<QueryDocumentSnapshot<Object?>>> getRoomData() async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('room_data').where('availability', isEqualTo: 'Available').get();

  return snapshot.docs.toList();
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

Future<List<Map<String, dynamic>>> getUserBookingsWithRoomData() async {
  QuerySnapshot bookingsSnapshot = await FirebaseFirestore.instance.collection('booking_data').where('bookingDoneBy', isEqualTo: currentUserEmailID).get();

  List<Map<String, dynamic>> bookings = bookingsSnapshot.docs.map((doc) {
    return {
      'checkinDate': (doc['checkInDate'] as Timestamp).toDate(),
      'checkoutDate': (doc['checkOutDate'] as Timestamp).toDate(),
      'roomID': doc['roomID'],
      'paymentStatus': doc['paymentStatus'],
      'isCheckedIn': doc['isCheckedIn'],
      'isCheckedOut': doc['isCheckedOut'],
    };
  }).toList();
  for (var booking in bookings) {
    DocumentSnapshot roomSnapshot = await FirebaseFirestore.instance.collection('room_data').doc(booking['roomID']).get();
    if (roomSnapshot.exists) {
      booking['roomData'] = roomSnapshot.data();
    }
  }
  return bookings;
}

Future<List<Map<String, dynamic>>> getUserBookingsWithRoom() async {
  QuerySnapshot bookingsSnapshot = await FirebaseFirestore.instance.collection('booking_data').where('checkInDate', isLessThanOrEqualTo: DateTime.now()).where('checkOutDate', isGreaterThanOrEqualTo: DateTime.now()).get();
  print("getUserBookingsWithRoom: $getUserBookingsWithRoom");
  List<Map<String, dynamic>> bookings = bookingsSnapshot.docs.map((doc) {
    return {
      'checkinDate': (doc['checkInDate'] as Timestamp).toDate(),
      'checkoutDate': (doc['checkOutDate'] as Timestamp).toDate(),
      'roomID': doc['roomID'],
      'documentID': doc['documentID'],
      'paymentStatus': doc['paymentStatus'],
      'isCheckedIn': doc['isCheckedIn'],
      'isCheckedOut': doc['isCheckedOut'],
    };
  }).toList();
  for (var booking in bookings) {
    DocumentSnapshot roomSnapshot = await FirebaseFirestore.instance.collection('room_data').doc(booking['roomID']).get();
    if (roomSnapshot.exists) {
      booking['roomData'] = roomSnapshot.data();
    }
  }
  return bookings;
}
