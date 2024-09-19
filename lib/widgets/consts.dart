import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kThemeBlueColor = Color(0XFF77D4FC);

const kThemeBlackColor = Color(0XFF000000);

const kLightTitleColor = Color(0XFF697489);

const kDarkTitleColor = Color(0XFF3A4355);

const kBackgroundColor = Color(0XFF77D4FC);

bool isLoggedIn = false;

String currentUserEmailID = '', isGuestOrStaff = '', password = '';

// late SharedPreferences prefs;

final auth = FirebaseAuth.instance;

const kListingInputDecorationStyle = TextStyle(
  color: kThemeBlueColor,
  fontSize: 17,
  fontWeight:FontWeight.w500
);

const kBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(32.0)),
);

var kEnabledBorder = const OutlineInputBorder(
  borderSide: BorderSide(color: kLightTitleColor, width: 1.0),
  borderRadius: BorderRadius.all(Radius.circular(32.0)),
);

var kFocusedBorder = const OutlineInputBorder(
  borderSide: BorderSide(color: kThemeBlackColor, width: 2.0),
  borderRadius: BorderRadius.all(Radius.circular(32.0)),
);

const kLightSemiBoldTextStyle = TextStyle(
    color: kLightTitleColor,
    fontSize: 18,
    fontWeight:FontWeight.w500
);

const kBlackBoldTextSize20 = TextStyle(
    color: kThemeBlackColor,
    fontSize: 18,
    fontWeight:FontWeight.bold
);

const kDarkTextSize18 = TextStyle(
    color: kDarkTitleColor,
    fontSize: 18,
    fontWeight:FontWeight.w500
);

const kLightBoldTextSize20 = TextStyle(
  color: kLightTitleColor,
  fontSize: 20,
  fontWeight:FontWeight.w500
);

const kDarkBoldTextSize20 = TextStyle(
  color: kDarkTitleColor,
  fontSize: 20,
  fontWeight:FontWeight.w500
);

const kBlackTextSize17 = TextStyle(
  color: kThemeBlackColor,
  fontSize: 17,
  fontWeight:FontWeight.w500
);

InputDecoration passwordInputDecoration(String labelText, bool passwordVisible, void Function() toggle){
  return InputDecoration(
    labelText: labelText,
    labelStyle: kDarkTextSize18,
    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: kBorder,
    enabledBorder: kEnabledBorder,
    focusedBorder: kFocusedBorder,
    suffixIcon: IconButton(
      icon: Icon(
        passwordVisible ? Icons.visibility : Icons.visibility_off,
        color: kThemeBlackColor,
      ),
      onPressed: toggle,
    ),
  );
}

InputDecoration textInputDecoration(String labelText) {
  return InputDecoration(
    // hintText: hintText,
    hintStyle: const TextStyle(color: kDarkTitleColor),
    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: kBorder,
    enabledBorder: kEnabledBorder,
    focusedBorder: kFocusedBorder,
    labelText: labelText,
    labelStyle: kDarkTextSize18,
  );
}

class HeroLogo extends StatelessWidget {
  HeroLogo({required this.height,required this.image, required this.tag});

  final double height;
  final String image, tag;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag:tag,
      child: Container(
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
        title: Text(title, style: kDarkBoldTextSize20),
        content: Text(message, style: kLightSemiBoldTextStyle),
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

Future<void> commonAlertBoxWithNavigation(BuildContext context, String title, String message, String navigationTo) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog.adaptive(
        title: Text(title, style: kDarkBoldTextSize20),
        content: Text(message, style: kLightSemiBoldTextStyle),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: const Text('OK', style: kLightSemiBoldTextStyle),
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