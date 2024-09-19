import 'package:flutter/material.dart';
import 'package:the_hotel_app/widgets/consts.dart';
import 'package:the_hotel_app/widgets/side_drawer.dart';

class GuestDashboard extends StatefulWidget {
  const GuestDashboard({super.key});

  @override
  State<GuestDashboard> createState() => _GuestDashboardState();
}

class _GuestDashboardState extends State<GuestDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Guest Dashboard'),
        backgroundColor: kThemeBlueColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Text('Welcome to dashboard'),
      ),
    );
  }
}

