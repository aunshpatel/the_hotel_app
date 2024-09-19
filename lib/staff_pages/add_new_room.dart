import 'package:flutter/material.dart';
import '../widgets/consts.dart';
import '../widgets/side_drawer.dart';

class AddNewRoom extends StatefulWidget {
  const AddNewRoom({super.key});

  @override
  State<AddNewRoom> createState() => _AddNewRoomState();
}

class _AddNewRoomState extends State<AddNewRoom> {
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
          title: Text('Add New Room', style:TextStyle(color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor),),
          backgroundColor: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
          iconTheme: IconThemeData(color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

            ],
          ),
        ),
      ),
    );
  }
}
