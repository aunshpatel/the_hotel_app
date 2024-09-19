import 'package:flutter/material.dart';
import '../widgets/consts.dart';
import '../widgets/side_drawer.dart';

class UpdateRoom extends StatefulWidget {
  const UpdateRoom({super.key});

  @override
  State<UpdateRoom> createState() => _UpdateRoomState();
}

class _UpdateRoomState extends State<UpdateRoom> {
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
          title: Text('Update A Room', style:TextStyle(color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor),),
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
