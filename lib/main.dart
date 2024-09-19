import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_hotel_app/guest_dashboard.dart';
import 'package:the_hotel_app/registration_screen.dart';
import 'package:the_hotel_app/staff_dashboard.dart';
import 'package:the_hotel_app/widgets/consts.dart';
import 'package:the_hotel_app/profile_page.dart';
import 'data_file.dart';
import 'firebase_options.dart';
import 'login_screen.dart';

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
          print("currentUserJoiningDate:$currentUserJoiningDate, currentUserBirthday:$currentUserBirthday");
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
          return showSpinner == true ? const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(kLightTitleColor),
              backgroundColor: Colors.transparent,
              strokeWidth: 5,
            ),
          ) : MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: kThemeBlueColor),
              useMaterial3: true,
            ),
            initialRoute: isLoggedIn == false ? '/login_screen' : (isGuestOrStaff == 'staff' ? '/staff_dashboard' : '/guest_dashboard'),
            routes: {
              '/login_screen':(context) => const LoginScreen(),
              '/registration_screen':(context) => const RegistrationScreen(),
              '/staff_dashboard':(context) => const StaffDashboard(),
              '/guest_dashboard':(context) => const GuestDashboard(),
              '/profile_page':(context) => ProfilePage(),
            },
          );
        }
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Center(
            child: CircularProgressIndicator(
              backgroundColor: kThemeBlueColor,
              strokeWidth: 4.0,
              color: Colors.white,
              valueColor: animationController.drive(ColorTween(begin: Colors.blueAccent, end: kThemeBlueColor)),
              //backgroundColor: Colors.white,
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
        title: Text('WARNING'),
        content: Text('Something Went Wrong!', style: kLightSemiBoldTextStyle),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: const Text('OK', style: kLightSemiBoldTextStyle),
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