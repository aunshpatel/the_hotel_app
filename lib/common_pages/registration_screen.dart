import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_hotel_app/widgets/consts.dart';
import 'package:the_hotel_app/widgets/rounded_button.dart';
import 'package:intl/intl.dart';
import 'package:the_hotel_app/data_center.dart';

final _registrationScreenFirestore = FirebaseFirestore.instance;

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email = '', fullname = '', confirmPwd = '', pwd = '';
  String loginEmailID = '', loginPassword = '';
  DateTime? joiningDate, birthday;
  int isGuestOrStaff = 1;
  bool showSpinner = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<void> _selectBirthday(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      barrierDismissible: false,
      initialDate: birthday ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? widget) => Theme(
        data: ThemeData(
          colorScheme: ColorScheme.light(primary: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor),
          datePickerTheme: DatePickerThemeData(
            backgroundColor: isDarkModeEnabled == false ? Colors.white : Colors.grey,
            dividerColor: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
            headerBackgroundColor: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
            headerForegroundColor: isDarkModeEnabled == false ? Colors.white : Colors.grey,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
              ),
            ),
          )
        ),
        child: widget!,
      )
    );


    if (pickedDate != null && pickedDate != birthday) {
      setState(() {
        birthday = pickedDate;
      });
    }
  }

  Future<void> _joiningDate(BuildContext context) async {
    final DateTime? _selectedDate = await showDatePicker(
      context: context,
      barrierDismissible: false,
      initialDate: joiningDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? widget) => Theme(
        data: ThemeData(
          colorScheme: ColorScheme.light(primary: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor),
          datePickerTheme: DatePickerThemeData(
            backgroundColor: isDarkModeEnabled == false ? Colors.white : Colors.grey,
            dividerColor: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
            headerBackgroundColor: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
            headerForegroundColor: isDarkModeEnabled == false ? Colors.white : Colors.grey,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
              ),
            ),
          )
        ),
        child: widget!,
      )
    );
    if (_selectedDate != null && _selectedDate != joiningDate) {
      setState(() {
        joiningDate = _selectedDate;
      });
    }
  }

  userRegistration() async{
    try {
      bool emailExists = await isEmailAlreadyRegistered(email);
      if (emailExists) {
        commonAlertBox(context, 'WARNING!', 'This email is already registered. Please login with that email id.');
      }
      final user = await _auth.createUserWithEmailAndPassword(email: email, password: pwd);
      user.user?.updateDisplayName(fullname);
      if(isGuestOrStaff == 1) {
        _registrationScreenFirestore.collection('registered_user').add({'fullname':fullname, 'email':email, 'birthday':birthday, 'joiningDate':birthday, 'isGuestOrStaff': isGuestOrStaff == 1 ? 'guest' : 'staff'});
      } else {
        _registrationScreenFirestore.collection('registered_user').add({'fullname':fullname, 'email':email, 'birthday':birthday, 'joiningDate':joiningDate, 'isGuestOrStaff': isGuestOrStaff == 1 ? 'guest' : 'staff'});
      }

      commonAlertBoxWithNavigation(context, 'SUCCESS!', 'Your registtration was successful! You will now be navigated to login screen.', '/login_screen');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        commonAlertBox(context, 'WARNING!', 'This email is already registered. Please login with that email id.');
      } else {
        commonAlertBox(context, 'WARNING!', '${e.message}');
      }
    } catch (e) {
      commonAlertBox(context, 'WARNING!', '$e');
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
          title: Text('Registration Screen', style:TextStyle(color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor),),
          backgroundColor: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Flexible(
                    child: HeroLogo(height:250,image:'images/the-hotel-app-high-resolution-logo.jpeg', tag:'photo'),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  // Full name
                  TextField(
                    controller: fullnameController,
                    keyboardType: TextInputType.name,
                    onChanged:(value){
                      fullname = fullnameController.text;
                    },
                    decoration: textInputDecoration('Enter your full name',),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Text('Select your role:', style: isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(vertical: 2.0),
                          title: Text('Guest', style:  isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18,),
                          leading: Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Radio(
                              value: 1,
                              activeColor: kThemeBlueColor,
                              groupValue: isGuestOrStaff,
                              onChanged: (int? value) {
                                setState(() {
                                  isGuestOrStaff = value!;
                                });
                              },
                            ),
                          )
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(vertical: 2.0),
                          title: Text('Staff',style:  isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18,),
                          leading: Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Radio(
                              value: 2,
                              activeColor: kThemeBlueColor,
                              groupValue: isGuestOrStaff,
                              onChanged: (int? value) {
                                setState(() {
                                  isGuestOrStaff = value!;
                                });
                              },
                            ),
                          )
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  //Birthday
                  ElevatedButton(
                    style: ElevatedButton.styleFrom( textStyle: isDarkModeEnabled == false ? kBlackBoldTextSize18 : kBlueBoldTextSize18, alignment:Alignment.centerLeft, elevation: 0),
                    onPressed: () => _selectBirthday(context),
                    child: birthday == null ? Text('Select your birthday', style:TextStyle(color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor)) : Text(DateFormat('yMMMMd').format(birthday!), style:TextStyle(color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor)),
                  ),

                  if(isGuestOrStaff == 2) ...[
                    const SizedBox(
                      height: 15.0,
                    ),
                    //Joining Date
                    ElevatedButton(
                      style: ElevatedButton.styleFrom( textStyle: kBlackBoldTextSize18, alignment:Alignment.centerLeft, elevation: 0),
                      onPressed: () => _joiningDate(context),
                      child: joiningDate == null ? Text('Select your joining date', style:TextStyle(color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor),) : Text(DateFormat('yMMMMd').format(joiningDate!), style:TextStyle(color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor),),
                    ),
                  ],
                  const SizedBox(
                    height: 15.0,
                  ),
                  // Email ID
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged:(value){
                      email = emailController.text;
                    },
                    decoration: textInputDecoration('Enter your email id',),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  // Password
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
                  //Confirm Password
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: _confirmPasswordVisible == false ? true : false,
                    onChanged:(value){
                      confirmPwd = confirmPasswordController.text;
                    },
                    decoration: passwordInputDecoration(
                      'Confirm your password',
                      _confirmPasswordVisible,
                          (){
                        setState(() {
                          _confirmPasswordVisible = !_confirmPasswordVisible;
                        });
                      }
                    ),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  RoundedButton(
                    colour: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
                    title:'Register',
                    onPress: (email != '' && fullname != '' && confirmPwd != '' && pwd != '') ? () {
                      if(confirmPwd == pwd) {
                        userRegistration();
                      } else {
                        commonAlertBox(context, 'WARNING!', 'Please check your password fields, the do not match.');
                      }
                    } : null,
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
                          Navigator.pop(context);
                        },
                        child: Text('Existing User? Login Here',  style: isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
