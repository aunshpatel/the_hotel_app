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
  bool _isRememberMe = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  actionRememberMe(bool value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isRememberMe = value;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("remember_me", _isRememberMe);
    },);
    setState(() {
      _isRememberMe = value;
    });
  }

  autoLogin(bool autoLogin) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(autoLogin == true){
      actionRememberMe(true);
      SharedPreferences.getInstance().then((prefs) {
        setState(() {
          isRememberMe = true;
        });
        prefs.setBool('autoLogin', autoLogin);
        prefs.setBool('isRememberMe', isRememberMe);
      },);
    }
    else{
      actionRememberMe(true);
      SharedPreferences.getInstance().then((prefs) {
        setState(() {
          isRememberMe = false;
        });
        prefs.setBool('autoLogin', autoLogin);
        prefs.setBool('isRememberMe', isRememberMe);
      },);
    }
  }

  _loginFunction() async {
    try{
      final user = await auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      if(user != null){
        // Navigator.pushNamed(context, '/task_screen');
        commonAlertBox(context, 'WARNING!', 'LOGIN SUCCESSFUL');
        currentUser = email;


        final usrData = await getUserData();
        print("usrData:$usrData");
        if(usrData[0]['isGuestOrStaff'] == 'staff') {
          Navigator.pushNamed(context, '/staff_dashboard');
        } else {
          Navigator.pushNamed(context, '/guest_dashboard');
        }

        setState(() {
          isLoggedIn = true;
          currentUser = email;
          isGuestOrStaff = usrData[0]['isGuestOrStaff'];
        });

        SharedPreferences.getInstance().then((prefs) {
          prefs.setBool('isLoggedIn', true);
          if(isRememberMe == true && isLoggedIn == true) {
            prefs.setString('currentUser', currentUser);
            prefs.setString('emailID', email);
            prefs.setString('password', pwd);
            prefs.setString('isGuestOrStaff', usrData[0]['isGuestOrStaff']);
          }
        },);
      }
      else{
        commonAlertBox(context, 'WARNING!','Incorrect email or password. Please enter your email and password again.');
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        checkColor: kThemeBlueColor,
                        side: WidgetStateBorderSide.resolveWith(
                              (states) => const BorderSide(width: 1.5, color: kThemeBlackColor),
                        ),
                        fillColor: WidgetStateProperty.all(Colors.transparent),
                        value: _isRememberMe,
                        onChanged: isRememberMe == false ? (value){
                          setState(() {
                            _isRememberMe = value!;
                          });
                          actionRememberMe(_isRememberMe);
                        } : null,
                      ),
                      const Text(
                        'Remember Me',
                        style: kDarkListingInputStyle,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        checkColor: kThemeBlueColor,
                        side: WidgetStateBorderSide.resolveWith(
                              (states) => const BorderSide(width: 1.5, color: kThemeBlackColor),
                        ),
                        fillColor: WidgetStateProperty.all(Colors.transparent),
                        value: automaticLogin,
                        onChanged: (value){
                          setState(() {
                            automaticLogin = value!;
                          });
                          autoLogin(automaticLogin);
                        },
                      ),
                      const Text(
                        'Auto Login',
                        style: kDarkListingInputStyle,
                      )
                    ],
                  )
                ],
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
                    child: const Text('New User? Register Here',  style: kExistingUserOrNewUser),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
