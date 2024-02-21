import 'package:buddies_proto/utils/feartures/authentication/pages/verify_email/verify_email_page.dart';
import 'package:buddies_proto/utils/feartures/authentication/pages/on_boarding/on_boarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData){
            return VerifyEmailPage();
          }
          else {
            return OnBoardingScreen();
          }
        },
      )
    );
  }
}