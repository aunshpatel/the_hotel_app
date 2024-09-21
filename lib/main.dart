import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_hotel_app/common_pages/booking_history.dart';
import 'package:the_hotel_app/common_pages/room_booking.dart';
import 'package:the_hotel_app/common_pages/registration_screen.dart';
import 'package:the_hotel_app/staff_pages/guest_management.dart';
import 'package:the_hotel_app/staff_pages/add_new_room.dart';
import 'package:the_hotel_app/widgets/consts.dart';
import 'common_pages/profile_page.dart';
import 'common_pages/room_listings.dart';
import 'data_file.dart';
import 'firebase_options.dart';
import 'common_pages/login_screen.dart';

void main() async{
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AnimationController animationController;
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
    _loginFunction();
  }

  _loginFunction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserEmailID = prefs.getString('emailID') ?? '';
      password = prefs.getString('password') ?? '';
      isGuestOrStaff = prefs.getString('isGuestOrStaff') ?? '';
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      isDarkModeEnabled = prefs.getBool('isDarkModeEnabled') ?? false;
    });
    if(isLoggedIn == true) {
      try{
        final user = await auth.signInWithEmailAndPassword(email: currentUserEmailID, password: password);
        if(user != null){
          final usrData = await getUserData();
          setState(() {
            isLoggedIn = true;
            currentUserJoiningDate = (usrData[0]['joiningDate']).toDate();
            currentUserBirthday = (usrData[0]['birthday']).toDate();
            isGuestOrStaff = usrData[0]['isGuestOrStaff'];
          });
        }
      } catch(e) {
        setState(() {
          showSpinner = false;
        });
        commonAlertBox(context, 'WARNING!', e.toString());
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          return somethingWentWrong(context);
        }
        if(snapshot.connectionState == ConnectionState.done) {
          return showSpinner == true ? Center(
            child: CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation<Color>(isDarkModeEnabled == false ? kDarkTitleColor : kLightTitleColor),
              backgroundColor: isDarkModeEnabled == false ? kLightTitleColor : kDarkTitleColor,
              strokeWidth: 5,
            ),
          ) : MaterialApp(
            initialRoute: isLoggedIn == false ? '/login_screen' : '/all_room_listings',
            routes: {
              '/login_screen': (context) => const LoginScreen(),
              '/registration_screen': (context) => const RegistrationScreen(),
              '/profile_page': (context) => const ProfilePage(),
              '/add_new_room': (context) => const AddNewRoom(),
              '/all_room_listings':(context) => const RoomListings(),
              '/room_booking':(context) => const RoomBooking(),
              '/booking_history':(context) => const BookingHistory(),
              '/guest_management_screen':(context) => const GuestManagement(),
            },
          );
        }
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Center(
            child: CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation<Color>(isDarkModeEnabled == false ? kDarkTitleColor : kLightTitleColor),
              backgroundColor: isDarkModeEnabled == false ? kLightTitleColor : kDarkTitleColor,
              strokeWidth: 5,
            ),
          ),
        );
      }
    );
  }
}

somethingWentWrong(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog.adaptive(
        title: Text('WARNING!', style: isDarkModeEnabled == false ? kDarkBoldTextSize20 : kLightBoldTextSize20),
        content: Text('Something Went Wrong!', style: isDarkModeEnabled == false ? kBoldDarkTextSize16 : kBoldLightTextSize16),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: Text('OK', style: isDarkModeEnabled == false ? kBoldDarkTextSize16 : kBoldLightTextSize16),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      );
    },
  );
}


//Firebase configuration file lib/firebase_options.dart generated successfully with the following Firebase apps:
//
// Platform  Firebase App Id
// web       1:300810315501:web:9b97bdde1a821b33630ee4
// android   1:300810315501:android:c02b221e9cb0fbfb630ee4
// ios       1:300810315501:ios:7da6448eb6b3c197630ee4
// macos     1:300810315501:ios:7da6448eb6b3c197630ee4
// windows   1:300810315501:web:21a0785c6035cf22630ee4