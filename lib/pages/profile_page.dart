import 'package:buddies_proto/components/text_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection("Users");
  Future<void> editField(String field) async{
    String newValue = "";
    await showDialog(context: context, builder: (context) => AlertDialog(
      title: Text("Edit " + field),
      content: TextField(
        autofocus: true,
        decoration: InputDecoration(
          hintText: "Enter new $field",
        ),
        onChanged: (value) {
          newValue = value;
        },
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
        TextButton(onPressed: () => Navigator.of(context).pop(newValue), child: Text('Save')),
      ],
    ),);
    if (newValue.trim().length > 0) {
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Page"),
        backgroundColor: Colors.grey[900],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection("Users").doc(currentUser.email!).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
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
                  MyTextBox(text: userData['username'], sectionName: 'username', onPressed: () => editField('username'),),
                  MyTextBox(text: userData['bio'], sectionName: 'bio', onPressed: () => editField('bio'),),
                  MyTextBox(text: userData['sex'], sectionName: 'sex', onPressed: () => editField('sex'),),
                  MyTextBox(text: userData['preference'], sectionName: 'preference', onPressed: () => editField('preference'),),
                  MyTextBox(text: userData['facebook'], sectionName: 'facebook', onPressed: () => editField('facebook'),),
                  MyTextBox(text: userData['instagram'], sectionName: 'instagram', onPressed: () => editField('instagram'),),
                  MyTextBox(text: userData['phone'], sectionName: 'phone', onPressed: () => editField('phone'),),
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