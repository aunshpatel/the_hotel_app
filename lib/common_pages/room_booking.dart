import 'package:flutter/material.dart';

import '../widgets/consts.dart';
import '../widgets/side_drawer.dart';

class RoomBooking extends StatefulWidget {
  const RoomBooking({super.key});

  @override
  State<RoomBooking> createState() => _RoomBookingState();
}

class _RoomBookingState extends State<RoomBooking> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: isDarkModeEnabled == false ? Colors.white : Colors.grey,
        drawerEnableOpenDragGesture: true,
        drawer: SideDrawer(),
        appBar: AppBar(
          centerTitle: true,
          title: Text('Room Booking Page', style:TextStyle(color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor),),
          backgroundColor: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
          iconTheme: IconThemeData(color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor),
        ),
        body: const Padding(
          padding: EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: SingleChildScrollView(
            child: Text('Room Booking Page')
          ),
        ),
      ),
    );
  }
}
