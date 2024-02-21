import 'package:buddies_proto/utils/feartures/authentication/pages/profile/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:buddies_proto/utils/constants/colors.dart';
import 'package:buddies_proto/utils/constants/image_strings.dart';
import 'package:buddies_proto/utils/constants/sizes.dart';
import 'package:buddies_proto/utils/constants/text_strings.dart';

class ProfileUpdatePage extends StatelessWidget {
  const ProfileUpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final usersCollection = FirebaseFirestore.instance.collection("Users");
    final usernameController = TextEditingController();
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
      if (preferenceEditingController.text.isEmpty) {
        showErrorMessage("Your Hobby can't be blank");
        return;
      }
      if (preferenceEditingController.text.isEmpty) {
        showErrorMessage("Your UserName can't be blank");
        return;
      }
      await usersCollection.doc(currentUser!.email).update({
        'preference': preferenceEditingController.text,
        'username': usernameController.text,
        'instagram': igEditingController.text.isEmpty ? 'Empty...' : igEditingController.text,
        'facebook': fbEditingController.text.isEmpty ? 'Empty...' : fbEditingController.text,
        'phone': pnEditingController.text.isEmpty ? 'Empty...' : pnEditingController.text,
      });

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => ProfilePage()),
        (Route<dynamic> route) => false,
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(),));
              }, icon: const Icon(LineAwesomeIcons.angle_left)),
          title: Text(
            "Edit Profile",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image(
                            image: AssetImage(TImages.google),
                          )),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: TColors.primary,
                        ),
                        child: Icon(
                          LineAwesomeIcons.camera,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 50,),
                Form(child: Column(
                  children: [
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
                        prefixIcon: Icon(Icons.person_outline_outlined),
                        labelText: TTexts.fullName,
                        hintText: "Your Name",
                      ),
                    ),
                    const SizedBox(height: TSizes.formHeight,),
                    TextFormField(
                      controller: preferenceEditingController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
                        prefixIcon: Icon(Icons.email_outlined),
                        labelText: "Hobby",
                        hintText: "Your hobby",
                      ),
                    ),
                    const SizedBox(height: TSizes.formHeight,),
                    TextFormField(
                      controller: igEditingController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
                        prefixIcon: Icon(Icons.key_outlined),
                        labelText: "IG ID",
                        hintText: "Your Instagram ID",
                      ),
                    ),
                    const SizedBox(height: TSizes.formHeight,),
                    TextFormField(
                      controller: fbEditingController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
                        prefixIcon: Icon(Icons.key_outlined),
                        labelText: "FB ID",
                        hintText: "Your Facebook ID",
                      ),
                    ),
                    const SizedBox(height: TSizes.formHeight,),
                    TextFormField(
                      controller: pnEditingController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
                        prefixIcon: Icon(Icons.key_outlined),
                        labelText: "Phone Number",
                        hintText: "Your Phone Number",
                      ),
                    ),
                  ],
                ),),
                const SizedBox(height: 30,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      updateProfile();
                    },
                    child: Text("Edit Profile"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.primary,
                        side: BorderSide.none,
                        shape: StadiumBorder()),
                  ),
                ),
              ]
            )
        ),
      ),
    );
  }
}