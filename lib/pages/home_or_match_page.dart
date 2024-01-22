import 'package:buddies_proto/pages/home_page.dart';
import 'package:buddies_proto/pages/match_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeOrMatchPage extends StatelessWidget {
  const HomeOrMatchPage({super.key});
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection("Users").doc(currentUser.email!).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData){
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final match = userData['cur_matching'];
            if (match.isEmpty){
              return HomePage();
            } else {
              return MatchPage();
            }
          }
          else if (snapshot.hasError) {
            return Center(child: Text('Error${snapshot.error}'),);
          } else {
            return const Center(child: CircularProgressIndicator(),);
          }
        },
      )
    );
  }
}