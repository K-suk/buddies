import 'package:buddies_proto/components/drawer.dart';
import 'package:buddies_proto/pages/login_or_register_page.dart';
import 'package:buddies_proto/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MatchPage extends StatelessWidget {
  MatchPage({super.key});
  final currentUser = FirebaseAuth.instance.currentUser!;
  void signUserOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginOrRegisterPage()));
  }
  void goToProfilePage(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage(),));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: MyDrawer(
        onProfileTap: () => goToProfilePage(context),
        onSignOut: () => signUserOut(context),
      ),
      body: Center(child: Text("Match")),
    );
  }
}