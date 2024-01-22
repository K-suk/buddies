import 'package:buddies_proto/pages/home_or_match_page.dart';
import 'package:buddies_proto/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileAdd extends StatefulWidget {
  const ProfileAdd({super.key});

  @override
  State<ProfileAdd> createState() => _ProfileAddState();
}

class _ProfileAddState extends State<ProfileAdd> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection("Users");
  var sexEditingController = TextEditingController();
  var preferenceEditingController = TextEditingController();
  var igEditingController = TextEditingController();
  var fbEditingController = TextEditingController();
  var pnEditingController = TextEditingController();
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          )
        );
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Edit Page"),
        backgroundColor: Colors.grey[900],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection("Users").doc(currentUser.email!).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
              return ListView(
                children: [
                  const SizedBox(height: 50,),
                  const Icon(Icons.person, size: 72,),
                  const SizedBox(height: 50,),
                  Text(
                    currentUser.email!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      'My Details',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          // The validator receives the text that the user has entered.
                          controller: sexEditingController,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: "Enter your sex (required)",
                          ),
                        ),
                        TextFormField(
                          // The validator receives the text that the user has entered.
                          controller: preferenceEditingController,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: "Enter your hobby (required)",
                          ),
                        ),
                        TextFormField(
                          // The validator receives the text that the user has entered.
                          controller: igEditingController,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: "Enter your IG account",
                          ),
                        ),
                        TextFormField(
                          // The validator receives the text that the user has entered.
                          controller: fbEditingController,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: "Enter your FB account",
                          ),
                        ),
                        TextFormField(
                          // The validator receives the text that the user has entered.
                          controller: pnEditingController,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: "Enter your Phone Number",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: ElevatedButton(
                            onPressed: () async {
                              // Validate returns true if the form is valid, or false otherwise.
                              if (sexEditingController == Null || sexEditingController.text.isEmpty){
                                showErrorMessage("Your Sex can't be blank");
                              } else if (preferenceEditingController == Null || preferenceEditingController.text.isEmpty){
                                showErrorMessage("Your Hobby can't be blank");
                              } else {
                                if (igEditingController == Null || igEditingController.text.isEmpty){
                                  await usersCollection.doc(currentUser.email).update({
                                    'instagram': 'Empty...'
                                  });
                                }
                                if (fbEditingController == Null || fbEditingController.text.isEmpty){
                                  await usersCollection.doc(currentUser.email).update({
                                    'facebook': 'Empty...'
                                  });
                                }
                                if (pnEditingController == Null || pnEditingController.text.isEmpty){
                                  await usersCollection.doc(currentUser.email).update({
                                    'phone': 'Empty...'
                                  });
                                }
                                await usersCollection.doc(currentUser.email).update({
                                  'sex': sexEditingController.text,
                                  'preference': preferenceEditingController.text,
                                });
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) => HomeOrMatchPage()),
                                  (Route<dynamic> route) => false,
                                );
                              }
                            },
                            child: const Text('Submit'),
                          ),
                        ),
                      ]
                    )
                  )
                ],
              );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error${snapshot.error}'),);
          } else {
            return const Center(child: CircularProgressIndicator(),);
          }
        },
      ),
    );
  }
}