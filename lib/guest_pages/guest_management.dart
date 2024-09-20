import 'package:flutter/material.dart';
import '../widgets/consts.dart';
import '../widgets/side_drawer.dart';

class GuestManagement extends StatefulWidget {
  const GuestManagement({super.key});

  @override
  State<GuestManagement> createState() => _GuestManagementState();
}

class _GuestManagementState extends State<GuestManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkModeEnabled == false ? Colors.white : Colors.grey,
      drawer: SideDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Guest Dashboard', style:TextStyle(color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor),),
        backgroundColor: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
        iconTheme: IconThemeData(color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Text('Welcome to dashboard'),
      ),
    );
  }
}
