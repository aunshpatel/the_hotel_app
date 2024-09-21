import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_hotel_app/widgets/consts.dart';
import 'package:the_hotel_app/widgets/rounded_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data_file.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '', pwd = '';
  String loginEmailID = '', loginPassword = '';
  bool showSpinner = false;
  bool _passwordVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initStateFunction();
  }

  initStateFunction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkModeEnabled = prefs.getBool('isDarkModeEnabled') ?? false;
    });
  }

  triggerDarkMode() {
    setState(() {
      if(isDarkModeEnabled == false) {
        isDarkModeEnabled = true;
      } else {
        isDarkModeEnabled = false;
      }
    });
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('isDarkModeEnabled', isDarkModeEnabled);
    },);
  }

  _loginFunction() async {
    try{
      final user = await auth.signInWithEmailAndPassword(email: email, password: pwd);
      if(user != null){
        setState(() {
          currentUserEmailID = email;
        });

        final usrData = await getUserData();
        setState(() {
          isLoggedIn = true;
          isGuestOrStaff = usrData[0]['isGuestOrStaff'];
          currentUserJoiningDate = (usrData[0]['joiningDate']).toDate();
          currentUserBirthday = (usrData[0]['birthday']).toDate();
          print("currentUserJoiningDate at login:$currentUserJoiningDate, currentUserBirthday:$currentUserBirthday");
        });

        SharedPreferences.getInstance().then((prefs) {
          if(isLoggedIn == true) {
            prefs.setBool('isLoggedIn', true);
            prefs.setString('isGuestOrStaff', isGuestOrStaff);
            prefs.setString('currentUserEmailID', email);
            prefs.setString('emailID', email);
            prefs.setString('password', pwd);
            prefs.setString('joiningDate', usrData[0]['isGuestOrStaff']);
          } else {
            prefs.setBool('isLoggedIn', false);
            prefs.setString('currentUserEmailID', '');
            prefs.setString('emailID', '');
            prefs.setString('password', '');
            prefs.setString('isGuestOrStaff', '');
          }
        },);

        commonAlertBoxWithNavigation(context, 'SUCCESS!', 'You have logged in successfully!', '/all_room_listings');
      }
      else{
        commonAlertBox(context, 'WARNING!','Incorrect email or password. Please enter your email and password again.');
        SharedPreferences.getInstance().then((prefs) {
          prefs.setBool('isLoggedIn', false);
          prefs.setString('currentUserEmailID', '');
          prefs.setString('emailID', '');
          prefs.setString('password', '');
          prefs.setString('isGuestOrStaff', '');
        },);
        setState(() {
          showSpinner = false;
        });
      }
    } catch(e) {
      setState(() {
        showSpinner = false;
      });
      commonAlertBox(context, 'WARNING!', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: isDarkModeEnabled == false ? Colors.white : Colors.grey,
        drawerEnableOpenDragGesture: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text('Login Screen', style:TextStyle(color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor),),
          backgroundColor: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
        ),
        body: showSpinner == true ? const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kLightTitleColor),
            backgroundColor: Colors.transparent,
            strokeWidth: 5,
          ),
        ) : Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(
                    height: 15.0,
                  ),
                  Flexible(
                    child: HeroLogo(height:250,image:'images/the-hotel-app-high-resolution-logo.jpeg', tag:'photo'),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged:(value){
                      email = emailController.text;
                    },
                    decoration: textInputDecoration('Enter your email',),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: _passwordVisible == false ? true : false,
                    onChanged:(value){
                      pwd = passwordController.text;
                    },
                    decoration: passwordInputDecoration(
                        'Enter your password',
                        _passwordVisible,
                            (){
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        }
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  RoundedButton(
                    colour: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
                    title:'Login',
                    onPress: _loginFunction,
                    txtStyle: isDarkModeEnabled == false ? kButtonBlackTextSize24 : kButtonBlueTextSize24,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/registration_screen');
                        },
                        child: Text('New User? Register Here',  style:  isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        // width: 200,
                        decoration: BoxDecoration(
                          color:  isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: MaterialButton(
                            onPressed: () {
                              setState(() {
                                if(isDarkModeEnabled == false) {
                                  isDarkModeEnabled = true;
                                } else {
                                  isDarkModeEnabled = false;
                                }
                              });
                              SharedPreferences.getInstance().then((prefs) {
                                prefs.setBool('isDarkModeEnabled', isDarkModeEnabled);
                              },);
                            },
                            child: isDarkModeEnabled == false ? Text('Enable Dark Mode',  style: isDarkModeEnabled == false ? kButtonBlackTextSize18 : kButtonBlueTextSize18) : Text('Enable Light Mode',  style:  isDarkModeEnabled == false ? kButtonBlackTextSize18 : kButtonBlueTextSize18),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          )
        ),
      ),
    );
  }
}
