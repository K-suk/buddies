import 'package:buddies_proto/utils/feartures/authentication/pages/other_pages/home_or_match_page.dart';
import 'package:buddies_proto/utils/feartures/authentication/pages/profile/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:buddies_proto/utils/constants/colors.dart';
import 'package:buddies_proto/utils/constants/image_strings.dart';
import 'package:buddies_proto/utils/constants/sizes.dart';

class ProfileAddPage extends StatefulWidget {
  const ProfileAddPage({super.key});

  @override
  State<ProfileAddPage> createState() => _ProfileAddPageState();
}

class _ProfileAddPageState extends State<ProfileAddPage> {
  var sexEditingController = "";
  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final usersCollection = FirebaseFirestore.instance.collection("Users");
    final preferenceEditingController = TextEditingController();
    final igEditingController = TextEditingController();
    final fbEditingController = TextEditingController();
    final pnEditingController = TextEditingController();
    var size = MediaQuery.of(context).size.width;
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
      if (sexEditingController == "") {
        showErrorMessage("Your Sex can't be blank");
        return;
      }
      if (preferenceEditingController.text.isEmpty) {
        showErrorMessage("Your Hobby can't be blank");
        return;
      }

      await usersCollection.doc(currentUser!.email).update({
        'sex': sexEditingController,
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
    return Scaffold(
      appBar: AppBar(
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
                    Container(
                      width: size*0.8,
                      child: DropdownButtonFormField<String>(
                        value: sexEditingController.isEmpty ? null : sexEditingController,
                        items: <String>['male', 'female'].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            sexEditingController = newValue!; // 必要に応じて更新
                          });
                        },
                        hint: Text("Select Gender"), // Provide a hint for null value if appropriate
                      ),
                    ),
                    const SizedBox(height: TSizes.formHeight,),
                    Container(
                      width: size*0.8,
                      child: TextFormField(
                        controller: preferenceEditingController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
                          prefixIcon: Icon(Icons.email_outlined),
                          labelText: "Hobby",
                          hintText: "Your hobby",
                        ),
                      ),
                    ),
                    const SizedBox(height: TSizes.formHeight,),
                    Container(
                      width: size*0.8,
                      child: TextFormField(
                        controller: igEditingController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
                          prefixIcon: Icon(Icons.key_outlined),
                          labelText: "IG ID",
                          hintText: "Your Instagram ID",
                        ),
                      ),
                    ),
                    const SizedBox(height: TSizes.formHeight,),
                    Container(
                      width: size*0.8,
                      child: TextFormField(
                        controller: fbEditingController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
                          prefixIcon: Icon(Icons.key_outlined),
                          labelText: "FB ID",
                          hintText: "Your Facebook ID",
                        ),
                      ),
                    ),
                    const SizedBox(height: TSizes.formHeight,),
                    Container(
                      width: size*0.8,
                      child: TextFormField(
                        controller: pnEditingController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
                          prefixIcon: Icon(Icons.key_outlined),
                          labelText: "Phone Number",
                          hintText: "Your Phone Number",
                        ),
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
                    child: Text("submit"),
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