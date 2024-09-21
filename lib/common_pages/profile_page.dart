import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_hotel_app/widgets/rounded_button.dart';
import 'package:the_hotel_app/widgets/side_drawer.dart';

import '../data_file.dart';
import '../widgets/consts.dart';

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
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    getProfileData();
  }

  getProfileData() async{
    final usrData = await getUserData();
    nameController.text = usrData[0]['fullname'];
    setState(() {
      currentUserJoiningDate = (usrData[0]['joiningDate']).toDate();
      joiningDate = currentUserJoiningDate;
      currentUserBirthday = (usrData[0]['birthday']).toDate();
      birthday = currentUserBirthday;
      fullname = usrData[0]['fullname'];
    });
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

  updateProfile() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('registered_user').where('email', isEqualTo: currentUserEmailID).get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          await doc.reference.update({
            'fullname': fullname.isNotEmpty ? fullname : doc['fullname'],
            'birthday': birthday != null ? birthday : doc['birthday'],
            'joiningDate': joiningDate != null ? joiningDate: doc['joiningDate']
          });
        }

        commonAlertBox(context, 'SUCCESS!', 'Profile updated successfully!');
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Profile updated successfully!')),
        // );
      }
    } catch (e) {
      commonAlertBox(context, 'WARNING!', 'Failed to update profile: $e!');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Failed to update profile: $e')),
      // );
    }
  }


  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

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
        birthday = DateTime.utc(pickedDate!.year, pickedDate!.month, pickedDate!.day);
        currentUserBirthday = pickedDate;
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
          datePickerTheme:  DatePickerThemeData(
            backgroundColor: isDarkModeEnabled == false ? Colors.white : Colors.grey,
            dividerColor: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
            headerBackgroundColor: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
            headerForegroundColor: isDarkModeEnabled == false ? Colors.white : Colors.grey,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor
              ),
            ),
          )
        ),
        child: widget!,
      )
    );
    if (_selectedDate != null && _selectedDate != joiningDate) {
      setState(() {
        joiningDate = DateTime.utc(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day);
        currentUserJoiningDate = _selectedDate;
      });
    }
  }

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
          title: Text('My Profile', style:TextStyle(color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor),),
          backgroundColor: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
          iconTheme: IconThemeData(color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 15.0,
                ),
                // Fullname
                TextField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  onChanged: (value) {
                    fullname = value;
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
                  style: ElevatedButton.styleFrom( textStyle: isDarkModeEnabled == false ? kBlackBoldTextSize18 : kBlueBoldTextSize18, alignment:Alignment.centerLeft, elevation: 0),
                  onPressed: () => _selectBirthday(context),
                  child: currentUserBirthday == null ? Text('Select your birthday', style:TextStyle(color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor)) : Text(DateFormat('yMMMMd').format(currentUserBirthday!), style:TextStyle(color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor)),
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
                    style: ElevatedButton.styleFrom( textStyle: isDarkModeEnabled == false ? kBlackBoldTextSize18 : kBlueBoldTextSize18, alignment:Alignment.centerLeft, elevation: 0),
                    onPressed: () => _joiningDate(context),
                    child: currentUserJoiningDate == null ? Text('Select your joining date', style:TextStyle(color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor),) : Text(DateFormat('yMMMMd').format(currentUserJoiningDate!), style:TextStyle(color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor),),
                  ),
                ],
                const SizedBox(
                  height: 30.0,
                ),
                // Update Profile
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      decoration: BoxDecoration(
                        color: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: MaterialButton(
                          onPressed: updateProfile,
                          child: Center(
                            child: Text('Update Profile',  style:  isDarkModeEnabled == false ? kButtonBlackTextSize18 : kButtonBlueTextSize18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30.0,
                ),
                // Dark/Light Mode toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color:  isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
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
                          child: Center(
                            child: isDarkModeEnabled == false ? const Text('Enable Dark Mode',  style: kButtonBlackTextSize18) : Text('Enable Light Mode',  style:  isDarkModeEnabled == false ? kButtonBlackTextSize18 : kButtonBlueTextSize18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15.0,
                ),
                RoundedButton(
                  colour: isDarkModeEnabled == false ? kThemeBlueColor : kThemeBlackColor,
                  title:'Logout',
                  onPress: _logoutFunction,
                  txtStyle: isDarkModeEnabled == false ? kButtonBlackTextSize24 : kButtonBlueTextSize24,
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}
