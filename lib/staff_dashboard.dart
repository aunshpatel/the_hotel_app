import 'package:flutter/material.dart';
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
      drawer: SideDrawer(),
      appBar: AppBar(
        title: Text('Guest Dashboard'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Text('Welcome to dashboard'),
      ),
    );
  }
}
