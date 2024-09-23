import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data_center.dart';
import '../widgets/consts.dart';
import '../widgets/side_drawer.dart';

class GuestManagement extends StatefulWidget {
  const GuestManagement({super.key});

  @override
  State<GuestManagement> createState() => _GuestManagementState();
}

class _GuestManagementState extends State<GuestManagement> {
  late Future<List<Map<String, dynamic>>> bookingsWithRoomsFuture;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    bookingsWithRoomsFuture = getUserBookingsWithRoom();
  }

  checkInFunction(String documentID, bool isCheckedIn) async {
    late String roomID;
    try {
      setState(() {
        _isLoading = true;
      });

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('booking_data').where('documentID', isEqualTo: documentID).get();
      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          await doc.reference.update({
            'isCheckedIn': isCheckedIn,
          });
          setState(() {
            roomID = doc['roomID'];
          });
        }
        QuerySnapshot roomQuerySnapshot = await FirebaseFirestore.instance.collection('room_data').where('documentId', isEqualTo: roomID).get();
        for (QueryDocumentSnapshot doc2 in roomQuerySnapshot.docs) {
          await doc2.reference.update({
            'roomStatus': 'Unavailable',
          });
        }
        bookingsWithRoomsFuture = getUserBookingsWithRoom();
      } else {
        print('Failed');
      }
    } catch (e) {
      print('Error updating room status: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  checkOutFunction(String documentID, bool isCheckedOut) async {
    late String roomID;
    try {
      setState(() {
        _isLoading = true;
      });

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('booking_data').where('documentID', isEqualTo: documentID).get();
      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          await doc.reference.update({
            'isCheckedIn': false,
            'isCheckedOut': isCheckedOut,
          });
          setState(() {
            roomID = doc['roomID'];
          });
        }
        QuerySnapshot roomQuerySnapshot = await FirebaseFirestore.instance.collection('room_data').where('documentId', isEqualTo: roomID).get();
        for (QueryDocumentSnapshot doc2 in roomQuerySnapshot.docs) {
          await doc2.reference.update({
            'roomStatus': 'Available',
          });
        }
        bookingsWithRoomsFuture = getUserBookingsWithRoom();
      } else {
        print('Failed');
      }
    } catch (e) {
      print('Error updating room status: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkModeEnabled == false ? Colors.white : Colors.grey,
      drawer: SideDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Guest Management', style:TextStyle(color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor),),
        backgroundColor: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
        iconTheme: IconThemeData(color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child:  _isLoading
        ? Center(
          child: CircularProgressIndicator.adaptive(
            valueColor: AlwaysStoppedAnimation<Color>(isDarkModeEnabled == false ? kDarkTitleColor : kLightTitleColor),
            backgroundColor: isDarkModeEnabled == false ? kLightTitleColor : kDarkTitleColor,
            strokeWidth: 5,
          )
        )
        : Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future:bookingsWithRoomsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator.adaptive(
                      valueColor: AlwaysStoppedAnimation<Color>(isDarkModeEnabled == false ? kDarkTitleColor : kLightTitleColor),
                      backgroundColor: isDarkModeEnabled == false ? kLightTitleColor : kDarkTitleColor,
                      strokeWidth: 5,
                    ));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    List<Map<String, dynamic>> bookings = snapshot.data!;
                    return ListView.builder(
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> booking = bookings[index];
                        return Column(
                          children: [
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        // Room Number
                                        Row(
                                          children: [
                                            const Text('Room Number:', style: kDarkUnderlineTextSize18),
                                            const SizedBox(width: 8),
                                            Text(' ${booking['roomData']['roomNumber']}', style: kDarkTextSize18),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Text('Daily Rent:', style: kDarkUnderlineTextSize18),
                                            const SizedBox(width: 8),
                                            Text(' ${booking['roomData']['currencyType'].split(' - ')[0]} ${booking['roomData']['rent']}', style: kDarkTextSize18),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Text('Check In Date:', style: kDarkUnderlineTextSize18),
                                            const SizedBox(width: 8),
                                            SizedBox(
                                              width: 168,
                                              child: Text(DateFormat('yMMMMd').format(booking['checkinDate']), softWrap:true, style: kDarkTextSize18),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Text('Check Out Date:', style: kDarkUnderlineTextSize18),
                                            const SizedBox(width: 8),
                                            SizedBox(
                                              width: 158,
                                              child: Text(DateFormat('yMMMMd').format(booking['checkoutDate']), softWrap:true, style: kDarkTextSize18),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Text('Room Availability:', style: kDarkUnderlineTextSize18),
                                            const SizedBox(width: 8),
                                            Text('${booking['roomData']['roomStatus']}', softWrap:true, style: kDarkTextSize18)
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(((!booking['isCheckedIn'] && booking['isCheckedOut']) || booking['isCheckedIn']) ? 'Checked In' : 'Not Checked In', style: kDarkTextSize18),

                                            Text(booking['isCheckedOut'] ? 'Checked Out' : 'Not Checked Out', style: kDarkTextSize18),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            (booking['isCheckedIn'] == false && booking['isCheckedOut'] == false && booking['checkinDate'].isAtSameMomentAs(DateTime.now())) || (booking['isCheckedIn'] == false && booking['isCheckedOut'] == false && booking['checkinDate'].isBefore(DateTime.now())) || (booking['isCheckedIn'] == false && booking['isCheckedOut'] == false && booking['checkinDate'].isAtSameMomentAs(DateTime.now())) ?
                                            MaterialButton(
                                              onPressed: () {
                                                bool boolCheckedIn = false;
                                                if(booking['isCheckedIn'] == true) {
                                                  boolCheckedIn = false;
                                                } else if(booking['isCheckedIn'] == false) {
                                                  boolCheckedIn = true;
                                                }
                                                checkInFunction(booking['documentID'], boolCheckedIn);
                                              },
                                              color:  isDarkModeEnabled == false ? kLightTitleColor : kDarkTitleColor,
                                              child: Text('Check In',style: isDarkModeEnabled == false ? kWhiteBoldTextSize20 : kBlueBoldTextSize20,),
                                            ) : SizedBox(),

                                            (booking['isCheckedIn'] == true && booking['checkinDate'].isAtSameMomentAs(DateTime.now()) && booking['checkoutDate'].isAfter(DateTime.now())) || (booking['isCheckedIn'] == true && booking['checkinDate'].isBefore(DateTime.now()) && booking['checkoutDate'].isAfter(DateTime.now())) || (booking['isCheckedIn'] == true && booking['checkinDate'].isBefore(DateTime.now()) && booking['checkoutDate'].isAtSameMomentAs(DateTime.now())) ?
                                            MaterialButton(
                                              onPressed: () {
                                                bool boolCheckedOut = false;
                                                if(booking['isCheckedOut'] == true) {
                                                  boolCheckedOut = false;
                                                } else if(booking['isCheckedOut'] == false) {
                                                  boolCheckedOut = true;
                                                }
                                                checkOutFunction(booking['documentID'], boolCheckedOut);
                                              },
                                              color:  isDarkModeEnabled == false ? kDarkTitleColor : kLightTitleColor,
                                              child: Text('Check Out',style: isDarkModeEnabled == false ? kWhiteBoldTextSize20 : kBlueBoldTextSize20,),
                                            ) : SizedBox(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20,)
                          ],
                        );
                      },
                    );
                  } else {
                    return Center(child: Text('No bookings found.', style: isDarkModeEnabled == false ? kWhiteBoldTextSize20 : kBlueBoldTextSize20,));
                  }
                },
              ),
            ),
          ],
        )
      ),
    );
  }
}
