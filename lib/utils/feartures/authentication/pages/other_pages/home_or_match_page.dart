import 'package:buddies_proto/utils/feartures/authentication/pages/home_page/home_page.dart';
import 'package:buddies_proto/utils/feartures/authentication/pages/match_page/match_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeOrMatchPage extends StatelessWidget {
  const HomeOrMatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || currentUser.email == null) {
      // Handle the case when there is no current user or the user has no email
      return const Center(child: Text('No user found'));
    }

    return Scaffold(
      body: UserStreamBuilder(email: currentUser.email!),
    );
  }
}

class UserStreamBuilder extends StatelessWidget {
  final String email;

  const UserStreamBuilder({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection("Users").doc(email).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('No data found'));
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final match = userData['cur_matching'];
        if (match.isEmpty) {
          return HomePage();
        } else {
          return MatchPage();
        }
      },
    );
  }
}
