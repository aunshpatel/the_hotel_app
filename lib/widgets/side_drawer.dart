import 'package:flutter/material.dart';

import 'consts.dart';
class SideDrawer extends StatefulWidget {
  const SideDrawer({super.key});

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: isDarkModeEnabled == false ? Colors.white : Colors.grey,
      elevation: 20,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            //Image
            SizedBox(
              height: 170,
              child: Image.asset('images/the-hotel-app-high-resolution-logo.jpeg')
            ),
            if(isGuestOrStaff == 'staff') ...[
              //Dashboard Page
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: kThemeBlackColor,
                    )
                  )
                ),
                child: ListTile(
                  title: Wrap(
                    children: [
                      Text('Dash', style: isDarkModeEnabled == false ? kLightBoldTextSize20 : kWhiteBoldTextSize20),
                      Text('board', style: isDarkModeEnabled == false ? kLightBoldTextSize20 : kWhiteBoldTextSize20,),
                    ],
                  ),
                  onTap: (){
                    Navigator.pushNamed(context, '/staff_dashboard');
                  },
                ),
              ),
            ],
            if(isGuestOrStaff == 'guest') ...[
              //Dashboard Page
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: kThemeBlackColor,
                    )
                  )
                ),
                child: ListTile(
                  title: Wrap(
                    children: [
                      Text('My ', style: isDarkModeEnabled == false ? kLightBoldTextSize20 : kWhiteBoldTextSize20),
                      Text('Dashboard', style: isDarkModeEnabled == false ? kLightBoldTextSize20 : kWhiteBoldTextSize20,),
                    ],
                  ),
                  onTap: (){
                    Navigator.pushNamed(context, '/guest_dashboard');
                  },
                ),
              ),
            ],
            //Profile Page
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: kThemeBlackColor,
                  )
                )
              ),
              child: ListTile(
                title: Wrap(
                  children: [
                    Text('My ', style: isDarkModeEnabled == false ? kLightBoldTextSize20 : kWhiteBoldTextSize20),
                    Text('Profile', style: isDarkModeEnabled == false ? kLightBoldTextSize20 : kWhiteBoldTextSize20,),
                  ],
                ),
                onTap: (){
                  Navigator.pushNamed(context, '/profile_page');
                },
              ),
            ),
          ],
        ),
      )
    );
  }
}
