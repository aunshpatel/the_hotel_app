import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_hotel_app/widgets/consts.dart';
import 'package:the_hotel_app/widgets/rounded_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data_file.dart';

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

        if(usrData[0]['isGuestOrStaff'] == 'staff') {
          commonAlertBoxWithNavigation(context, 'SUCCESS!', 'LOGIN SUCCESSFUL', '/staff_dashboard');
          // Navigator.pushNamed(context, '/staff_dashboard');
        } else {
          commonAlertBoxWithNavigation(context, 'SUCCESS!', 'LOGIN SUCCESSFUL', '/guest_dashboard');
          // Navigator.pushNamed(context, '/guest_dashboard');
        }
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
        drawerEnableOpenDragGesture: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text('Login Screen', style:TextStyle(color: kThemeBlackColor),),
          backgroundColor: kThemeBlueColor,
        ),
        body: showSpinner == true ? const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kLightTitleColor),
            backgroundColor: Colors.transparent,
            strokeWidth: 5,
          ),
        ) : Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
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
                colour:kThemeBlueColor,
                title:'Login',
                onPress: _loginFunction,
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
                    child: const Text('New User? Register Here',  style: kDarkTextSize18),
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
                    width: 200,
                    decoration: BoxDecoration(
                      color: kThemeBlueColor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: MaterialButton(
                        onPressed: null,
                        child: Text('Enable Dark Mode',  style: kButtonBlackTextSize18),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
