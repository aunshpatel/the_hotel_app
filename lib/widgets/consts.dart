import 'package:flutter/material.dart';

const kThemeBlueColor = Color(0XFF77D4FC);

const kThemeBlackColor = Color(0XFF000000);

const kLightTitleColor = Color(0XFF697489);

const kDarkTitleColor = Color(0XFF3A4355);

const kBackgroundColor = Color(0XFF77D4FC);

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
    fontSize: 16,
    fontWeight:FontWeight.w500
);

const kDarkListingInputDecorationStyle = TextStyle(
    color: kDarkTitleColor,
    fontSize: 17,
    fontWeight:FontWeight.w500
);

const kBlackListingInputDecorationStyle = TextStyle(
    color: kThemeBlackColor,
    fontSize: 17,
    fontWeight:FontWeight.w500
);

InputDecoration passwordInputDecoration(String labelText, bool passwordVisible, void Function() toggle){
  return InputDecoration(
    labelText: labelText,
    labelStyle: kDarkListingInputDecorationStyle,
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
    labelStyle: kDarkListingInputDecorationStyle,
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