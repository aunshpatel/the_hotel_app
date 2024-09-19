import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_hotel_app/widgets/rounded_button.dart';
import 'package:the_hotel_app/widgets/side_drawer.dart';

import 'data_file.dart';
import 'widgets/consts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String fullname = '', pwd = '';
  DateTime? joiningDate, birthday;
  TextEditingController emailController = TextEditingController(text: currentUserEmailID);
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController roleController = TextEditingController(text: isGuestOrStaff);
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    getProfileData();
  }

  _logoutFunction() {
    setState(() {
      currentUserEmailID = '';
      password =  '';
      isGuestOrStaff = '';
      isLoggedIn = false;
    });
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('isLoggedIn', false);
      prefs.setString('currentUserEmailID', '');
      prefs.setString('emailID', '');
      prefs.setString('password', '');
      prefs.setString('joiningDate', '');
    },);
    commonAlertBoxWithNavigation(context, 'SUCCESS!', 'You have logged out successfully!', '/login_screen');
  }

  Future<void> _selectBirthday(BuildContext context) async {
    // Define the initial date, first date, and last date to show in the date picker
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        barrierDismissible: false,
        initialDate: birthday ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget? widget) => Theme(
          data: ThemeData(
              colorScheme: const ColorScheme.light(primary: kThemeBlueColor),
              datePickerTheme: const DatePickerThemeData(
                backgroundColor: Colors.white,
                dividerColor: kThemeBlueColor,
                headerBackgroundColor: kThemeBlueColor,
                headerForegroundColor: Colors.white,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
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
      print("birthday:$birthday");
    }
  }

  Future<void> _joiningDate(BuildContext context) async {
    // Define the initial date, first date, and last date to show in the date picker
    final DateTime? _selectedDate = await showDatePicker(
        context: context,
        barrierDismissible: false,
        initialDate: joiningDate ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget? widget) => Theme(
          data: ThemeData(
              colorScheme: const ColorScheme.light(primary: kThemeBlueColor),
              datePickerTheme: const DatePickerThemeData(
                backgroundColor: Colors.white,
                dividerColor: kThemeBlueColor,
                headerBackgroundColor: kThemeBlueColor,
                headerForegroundColor: Colors.white,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
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
      print('joiningDate:$joiningDate');
    }
  }

  getProfileData() async{
    final usrData = await getUserData();
    setState(() {
      currentUserJoiningDate = (usrData[0]['joiningDate']).toDate();
      currentUserBirthday = (usrData[0]['birthday']).toDate();
    });
    print("usrData:$usrData");
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        drawerEnableOpenDragGesture: true,
        drawer: SideDrawer(),
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text('My Profile', style:TextStyle(color: kThemeBlackColor),),
          backgroundColor: kThemeBlueColor,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 15.0,
              ),
              // Fullname
              TextField(
                readOnly: true,
                controller: nameController,
                keyboardType: TextInputType.name,
                onChanged: (value) {

                },
                decoration: textInputDecoration('Full Name',),
              ),
              const SizedBox(
                height: 20.0,
              ),
              // Role
              TextField(
                readOnly: true,
                controller: roleController,
                keyboardType: TextInputType.text,
                onChanged: null,
                decoration: textInputDecoration('Role',),
              ),
              const SizedBox(
                height: 20.0,
              ),
              // Email ID
              TextField(
                readOnly: true,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                onChanged: null,
                decoration: textInputDecoration('Email ID',),
              ),
              const SizedBox(
                height: 20.0,
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
              //Birthday
              ElevatedButton(
                style: ElevatedButton.styleFrom( textStyle: kBlackBoldTextSize20, alignment:Alignment.centerLeft, elevation: 0),
                onPressed: () => _selectBirthday(context),  // Show date picker when button is pressed
                child: currentUserBirthday == null ? const Text('Select your birthday') : Text(DateFormat('yMMMMd').format(currentUserBirthday!)),
              ),
              const SizedBox(
                height: 15.0,
              ),
              if(isGuestOrStaff == 'staff') ...[
                const SizedBox(
                  height: 15.0,
                ),
                //Joining Date
                ElevatedButton(
                  style: ElevatedButton.styleFrom( textStyle: kBlackBoldTextSize20, alignment:Alignment.centerLeft, elevation: 0),
                  onPressed: () => _joiningDate(context),
                  child: currentUserJoiningDate == null ? const Text('Select your joining date') : Text(DateFormat('yMMMMd').format(currentUserJoiningDate!)),
                ),
              ],
              const SizedBox(
                height: 15.0,
              ),
              RoundedButton(
                colour:kThemeBlueColor,
                title:'Logout',
                onPress: _logoutFunction,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
