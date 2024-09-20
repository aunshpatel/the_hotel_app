import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data_center.dart';
import '../widgets/consts.dart';
import '../widgets/side_drawer.dart';

class BookingHistory extends StatefulWidget {
  const BookingHistory({super.key});

  @override
  _BookingHistoryState createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistory> {
  late Future<List<Map<String, dynamic>>> bookingsWithRoomsFuture;

  @override
  void initState() {
    super.initState();
    bookingsWithRoomsFuture = getUserBookingsWithRoomData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: isDarkModeEnabled == false ? Colors.white : Colors.grey,
        drawer: const SideDrawer(),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
          iconTheme: IconThemeData(color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor),
          title: Text('Booking History',style: TextStyle(color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor),),
          bottom: TabBar(
            dividerColor: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor,
            indicatorColor: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor,
            tabs: [
              // Tab(text: 'Past',),
              // Tab(text: 'Current'),
              // Tab(text: 'Future'),
              Tab(child: Text('Past', style: isDarkModeEnabled == false ? kDarkBoldTextSize20 : kBlueBoldTextSize20,),),
              Tab(child: Text('Current', style: isDarkModeEnabled == false ? kDarkBoldTextSize20 : kBlueBoldTextSize20,),),
              Tab(child: Text('Future', style: isDarkModeEnabled == false ? kDarkBoldTextSize20 : kBlueBoldTextSize20,),),
            ],
          ),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: bookingsWithRoomsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No Bookings Available', style: isDarkModeEnabled == false ? kButtonDarkTextSize24 : kButtonBlueTextSize24,));
            }

            BookingClassification classifier = BookingClassification(snapshot.data!);
            return TabBarView(
              children: [
                BookingsList(bookings: classifier.pastBookings, type: 'Past'),
                BookingsList(bookings: classifier.currentBookings, type: 'Current'),
                BookingsList(bookings: classifier.futureBookings, type: 'Future'),
              ],
            );
          },
        ),
      ),
    );
  }
}

class BookingsList extends StatelessWidget {
  final List<Map<String, dynamic>> bookings;
  final String type;

  BookingsList({required this.bookings, required this.type});

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Center(child: Text('No $type Bookings', style: isDarkModeEnabled == false ? kButtonDarkTextSize24 : kButtonBlueTextSize24,));
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          var booking = bookings[index];
          var roomData = booking['roomData'];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Room ${roomData['roomNumber']}', style: kDarkBoldTextSize20),
                  const SizedBox(height:10),
                  Text('Room Type: ${roomData['roomType']}', style: kBoldDarkTextSize18,),
                  const SizedBox(height:10),
                  Text('Rent: ${roomData['currencyType'].split(' - ')[0]} ${roomData['rent']}', style: kBoldDarkTextSize18,),
                  const SizedBox(height:10),
                  Text('Payment Status: ${booking['paymentStatus']}', style: kBoldDarkTextSize18,),
                  const SizedBox(height:10),
                  Text('Check In Date: ${DateFormat('yMMMMd').format(booking['checkinDate'])}', style: kBoldDarkTextSize18,),
                  const SizedBox(height:10),
                  Text('Check In Status: ${booking['isCheckedIn'] == true ? 'Checked In' : 'Not Checked In'}', style: kBoldDarkTextSize18,),
                  const SizedBox(height:10),
                  Text('Check Out Date: ${DateFormat('yMMMMd').format(booking['checkoutDate'])}', style: kBoldDarkTextSize18,),
                  const SizedBox(height:10),
                  Text('Check Out Status: ${booking['isCheckedOut'] == true ? 'Checked Out' : 'Not Checked Out'}', style: kBoldDarkTextSize18,),
                  const SizedBox(height:10),
                  Text('Description: ${roomData['description']}', style: kBoldDarkTextSize18,),
                ],
              ),
            )
          );
        },
      ),
    );
  }
}

class BookingClassification {
  List<Map<String, dynamic>> pastBookings = [];
  List<Map<String, dynamic>> currentBookings = [];
  List<Map<String, dynamic>> futureBookings = [];

  BookingClassification(List<Map<String, dynamic>> bookings) {
    DateTime now = DateTime.now();

    for (var booking in bookings) {
      DateTime checkin = booking['checkinDate'];
      DateTime checkout = booking['checkoutDate'];

      if (checkout.isBefore(now)) {
        pastBookings.add(booking);
      } else if (checkin.isBefore(now) && checkout.isAfter(now)) {
        currentBookings.add(booking);
      } else {
        futureBookings.add(booking);
      }
    }
  }
}


