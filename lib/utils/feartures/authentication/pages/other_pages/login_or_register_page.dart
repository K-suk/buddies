import 'package:buddies_proto/utils/feartures/authentication/pages/login/login_page.dart';
import 'package:buddies_proto/utils/feartures/authentication/pages/signup/signup_page.dart';
import 'package:flutter/material.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  bool showLoginPage = true;
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (showLoginPage){
      return LoginPage(onTap: togglePages,);
    }else{
      return SignUpPage(onTap: togglePages,);
    }
  }
}