import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kThemeBlueColor = Color(0XFF77D4FC);

const kThemeBlackColor = Color(0XFF000000);

const kThemeRedColor = Color(0XFF9E2121);

const kLightTitleColor = Color(0XFF697489);

const kDarkTitleColor = Color(0XFF3A4355);

const kBackgroundColor = Color(0XFF77D4FC);

bool isLoggedIn = false, isDarkModeEnabled = false;

String currentUserEmailID = '', isGuestOrStaff = '', password = '', currentUserFullName = '';

String? roomID;

DateTime? currentUserJoiningDate, currentUserBirthday;

final auth = FirebaseAuth.instance;

const kBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(32.0)),
);

var kEnabledBorder = OutlineInputBorder(
  borderSide: BorderSide(color: isDarkModeEnabled == false ? kLightTitleColor : kThemeBlueColor, width: 1.0),
  borderRadius: const BorderRadius.all(Radius.circular(32.0)),
);

var kFocusedBorder = OutlineInputBorder(
  borderSide: BorderSide(color:  isDarkModeEnabled == false ? kLightTitleColor : kThemeBlueColor, width: 2.0),
  borderRadius: const BorderRadius.all(Radius.circular(32.0)),
);

const kRedBoldRegTxtSize15 = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 15,
  color: kThemeRedColor,
);

const kWarningTextSize15 = TextStyle(
  color: kThemeRedColor,
  fontSize: 15,
  fontWeight:FontWeight.w500
);

const kBoldBlueTextSize16 = TextStyle(
    color: kThemeBlueColor,
    fontSize: 16,
    fontWeight:FontWeight.bold
);

const kBoldLightTextSize16 = TextStyle(
    color: kLightTitleColor,
    fontSize: 16,
    fontWeight:FontWeight.bold
);

const kBoldDarkTextSize16= TextStyle(
    color: kDarkTitleColor,
    fontSize: 16,
    fontWeight:FontWeight.bold
);

const kLightListingDecorationSize17 = TextStyle(
  color: kThemeBlueColor,
  fontSize: 17,
  fontWeight:FontWeight.w500
);

const kDarkListingDecorationSize17 = TextStyle(
  color: kThemeBlackColor,
  fontSize: 17,
  fontWeight:FontWeight.w500
);

const kBlueSemiBoldTextSize18 = TextStyle(
    color: kThemeBlueColor,
    fontSize: 18,
    fontWeight:FontWeight.w500
);

const kLightSemiBoldTextSize18 = TextStyle(
  color: kLightTitleColor,
  fontSize: 18,
  fontWeight:FontWeight.w500
);

const kDarkSemiBoldTextSize18 = TextStyle(
  color: kDarkTitleColor,
  fontSize: 18,
  fontWeight:FontWeight.w500
);

const kBlueBoldTextSize18 = TextStyle(
  color: kThemeBlueColor,
  fontSize: 18,
  fontWeight:FontWeight.bold
);

const kBlackBoldTextSize18 = TextStyle(
  color: kThemeBlackColor,
  fontSize: 18,
  fontWeight:FontWeight.bold
);

const kButtonBlueTextSize18 = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: kThemeBlueColor,
);

const kButtonBlackTextSize18 = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: kThemeBlackColor,
);

const kLightTextSize18 = TextStyle(
  color: kThemeBlueColor,
  fontSize: 18,
  fontWeight:FontWeight.w500
);

const kDarkTextSize18 = TextStyle(
  color: kDarkTitleColor,
  fontSize: 18,
  fontWeight:FontWeight.w500
);

const kDarkUnderlineTextSize18 = TextStyle(
  color: kDarkTitleColor,
  fontSize: 18,
  fontWeight:FontWeight.w500,
  decoration: TextDecoration.underline
);

const kWhiteBoldLightTextSize18 = TextStyle(
  color: Colors.white,
  fontSize: 18,
  fontWeight:FontWeight.bold
);

const kBoldBlueTextSize18 = TextStyle(
  color: kThemeBlueColor,
  fontSize: 18,
  fontWeight:FontWeight.bold
);

const kBoldLightTextSize18 = TextStyle(
    color: kLightTitleColor,
    fontSize: 18,
    fontWeight:FontWeight.bold
);

const kBoldDarkTextSize18 = TextStyle(
  color: kDarkTitleColor,
  fontSize: 18,
  fontWeight:FontWeight.bold
);

const kBlueBoldTextSize20 = TextStyle(
  color: kThemeBlueColor,
  fontSize: 20,
  fontWeight:FontWeight.bold
);

const kWhiteBoldTextSize20 = TextStyle(
  color: Colors.white,
  fontSize: 20,
  fontWeight:FontWeight.bold
);

const kLightBoldTextSize20 = TextStyle(
  color: kLightTitleColor,
  fontSize: 20,
  fontWeight:FontWeight.bold
);

const kDarkBoldTextSize20 = TextStyle(
  color: kDarkTitleColor,
  fontSize: 20,
  fontWeight:FontWeight.bold
);

const kButtonBlueTextSize24 = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: kThemeBlueColor,
);

const kButtonDarkTextSize24 = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: kDarkTitleColor,
);

const kButtonBlackTextSize24 = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: kThemeBlackColor,
);

InputDecoration passwordInputDecoration(String labelText, bool passwordVisible, void Function() toggle){
  return InputDecoration(
    labelText: labelText,
    labelStyle:  isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18,
    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: kBorder,
    enabledBorder: kEnabledBorder,
    focusedBorder: kFocusedBorder,
    suffixIcon: IconButton(
      icon: Icon(
        passwordVisible ? Icons.visibility : Icons.visibility_off,
        color: isDarkModeEnabled == false ? kThemeBlackColor : kThemeBlueColor,
      ),
      onPressed: toggle,
    ),
  );
}

InputDecoration textInputDecoration(String labelText) {
  return InputDecoration(
    // hintText: hintText,
    hintStyle: TextStyle(color: isDarkModeEnabled == false ? kDarkTitleColor : kThemeBlueColor),
    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: kBorder,
    enabledBorder: kEnabledBorder,
    focusedBorder: kFocusedBorder,
    labelText: labelText,
    labelStyle: isDarkModeEnabled == false ? kDarkTextSize18 : kLightTextSize18,
  );
}

class HeroLogo extends StatelessWidget {
  const HeroLogo({required this.height,required this.image, required this.tag});

  final double height;
  final String image, tag;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag:tag,
      child: SizedBox(
        height: height,
        child: Image.asset(image),
      ),
    );
  }
}

Future<void> commonAlertBox(BuildContext context, String title, String message) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog.adaptive(
        title: Text(title, style: isDarkModeEnabled == false ? kDarkBoldTextSize20 : kLightBoldTextSize20),
        content: Text(message, style: isDarkModeEnabled == false ? kBoldDarkTextSize16 : kBoldLightTextSize16),
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

Future<void> commonAlertBoxWithNavigation(BuildContext context, String title, String message, String navigationTo) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog.adaptive(
        title: Text(title, style:  isDarkModeEnabled == false ? kDarkBoldTextSize20 : kLightBoldTextSize20),
        content: Text(message, style:  isDarkModeEnabled == false ? kBoldDarkTextSize16 : kBoldLightTextSize16),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: Text('OK', style:  isDarkModeEnabled == false ? kBoldDarkTextSize16 : kBoldLightTextSize16),
                onPressed: () {
                  Navigator.pushNamed(context, navigationTo);
                },
              ),
            ],
          ),
        ],
      );
    },
  );
}