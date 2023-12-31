import 'package:buddies_proto/pages/home_page.dart';
import 'package:buddies_proto/pages/match_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeOrMatchPage extends StatelessWidget {
  const HomeOrMatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData){
            return MatchPage();
          }
          else {
            return HomePage();
          }
        },
      )
    );
  }
}