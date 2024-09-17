import 'package:flutter/material.dart';
import 'package:the_hotel_app/widgets/consts.dart';
import 'package:the_hotel_app/widgets/rounded_button.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email = '', fullname = '', confirmPwd = '', pwd = '';
  String loginEmailID = '', loginPassword = '';
  bool showSpinner = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        drawerEnableOpenDragGesture: true,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Registration Screen', style:TextStyle(color: kThemeBlackColor),),
          backgroundColor: kThemeBlueColor,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
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
                    decoration: textInputDecoration('Enter your email id',),
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
                    colour:kThemeBlueColor,
                    title:'Register',
                    onPress: () {},
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
                        child: const Text('Existing User? Login Here',  style: kDarkListingInputDecorationStyle),
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
