import 'package:buddies_proto/pages/home_or_match_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileAdd extends StatefulWidget {
  const ProfileAdd({super.key});

  @override
  State<ProfileAdd> createState() => _ProfileAddState();
}

class _ProfileAddState extends State<ProfileAdd> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final usersCollection = FirebaseFirestore.instance.collection("Users");
  final sexEditingController = TextEditingController();
  final preferenceEditingController = TextEditingController();
  final igEditingController = TextEditingController();
  final fbEditingController = TextEditingController();
  final pnEditingController = TextEditingController();

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

  Future<void> updateProfile() async {
    if (currentUser?.email == null) return;
    if (sexEditingController.text.isEmpty) {
      showErrorMessage("Your Sex can't be blank");
      return;
    }
    if (preferenceEditingController.text.isEmpty) {
      showErrorMessage("Your Hobby can't be blank");
      return;
    }

    await usersCollection.doc(currentUser!.email).update({
      'sex': sexEditingController.text,
      'preference': preferenceEditingController.text,
      'instagram': igEditingController.text.isEmpty ? 'Empty...' : igEditingController.text,
      'facebook': fbEditingController.text.isEmpty ? 'Empty...' : fbEditingController.text,
      'phone': pnEditingController.text.isEmpty ? 'Empty...' : pnEditingController.text,
    });

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomeOrMatchPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null || currentUser!.email == null) {
      return const Scaffold(
        body: Center(child: Text("No user logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Edit Page"),
        backgroundColor: Colors.grey[900],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: usersCollection.doc(currentUser!.email).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return buildProfileForm();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget buildProfileForm() {
    return ListView(
      padding: const EdgeInsets.all(25.0),
      children: <Widget>[
        const Icon(Icons.person, size: 72),
        Text(
          currentUser!.email!,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[700]),
        ),
        const Text(
          'My Details',
          style: TextStyle(color: Colors.grey),
        ),
        buildTextField(sexEditingController, "Enter your sex (required)"),
        buildTextField(preferenceEditingController, "Enter your hobby (required)"),
        buildTextField(igEditingController, "Enter your IG account"),
        buildTextField(fbEditingController, "Enter your FB account"),
        buildTextField(pnEditingController, "Enter your Phone Number"),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ElevatedButton(
            onPressed: updateProfile,
            child: const Text('Submit'),
          ),
        ),
      ],
    );
  }

  Widget buildTextField(TextEditingController controller, String hintText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(hintText: hintText),
    );
  }
}
