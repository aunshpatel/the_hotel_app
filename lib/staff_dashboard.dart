import 'package:flutter/material.dart';
import 'package:the_hotel_app/widgets/consts.dart';
import 'package:the_hotel_app/widgets/side_drawer.dart';

class StaffDashboard extends StatefulWidget {
  const StaffDashboard({super.key});

  @override
  State<StaffDashboard> createState() => _StaffDashboardState();
}

class _StaffDashboardState extends State<StaffDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkModeEnabled == false ? Colors.white : Colors.grey,
      drawer: SideDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Staff Dashboard', style:TextStyle(color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor),),
        backgroundColor: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
        iconTheme: IconThemeData(color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Text('Welcome to staff dashboard'),
      ),
    );
  }
}
