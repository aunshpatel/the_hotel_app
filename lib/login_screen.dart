import 'package:flutter/material.dart';
import 'package:the_hotel_app/widgets/consts.dart';
import 'package:the_hotel_app/widgets/rounded_button.dart';

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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        drawerEnableOpenDragGesture: true,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Login Screen', style:TextStyle(color: kThemeBlackColor),),
          backgroundColor: kThemeBlueColor,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
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
                height: 24.0,
              ),
              RoundedButton(
                colour:kThemeBlueColor,
                title:'Login',
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
                      Navigator.pushNamed(context, '/registration_screen');
                    },
                    child: const Text('New User? Register Here',  style: kDarkListingInputDecorationStyle),
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
