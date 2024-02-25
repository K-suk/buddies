import 'dart:typed_data';
import 'package:buddies_proto/utils/feartures/authentication/pages/other_pages/home_or_match_page.dart';
import 'package:buddies_proto/utils/feartures/authentication/pages/other_pages/random_string.dart';
import 'package:buddies_proto/utils/feartures/authentication/pages/other_pages/utils.dart';
import 'package:buddies_proto/utils/feartures/authentication/pages/profile/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:buddies_proto/utils/constants/colors.dart';
import 'package:buddies_proto/utils/constants/image_strings.dart';
import 'package:buddies_proto/utils/constants/sizes.dart';
import 'package:buddies_proto/utils/constants/text_strings.dart';
import 'package:buddies_proto/resources/add_data.dart';

class ProfileUpdatePage extends StatefulWidget {
  const ProfileUpdatePage({super.key});

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}
// Future<List<String>> getUserdatas() async{
//     final User? currentUser = FirebaseAuth.instance.currentUser;
//     CollectionReference ppl = FirebaseFirestore.instance.collection('Users');
//     final user = await ppl.doc(currentUser!.email).get();
//     final userdatas = <String>[user.get('username'), user.get('preference'), user.get('instagram'), user.get('facebook'), user.get('phone')];
//     return userdatas;
// }
class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  Uint8List? image;
  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final usersCollection = FirebaseFirestore.instance.collection("Users");
    // final userdatas = getUserdatas();
    
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
    Future<String> uploadImageToStorage(String childName, Uint8List file) async {
      Reference ref = storage.ref().child(childName).child(getRandomString(15));
      UploadTask uploadTask = ref.putData(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    }
    Future<void> updateProfile(String username, String preference, String ig, String fb, String pn) async {
      if (currentUser?.email == null) return;
      if (preference.isEmpty) {
        showErrorMessage("Your Hobby can't be blank");
        return;
      }
      if (username.isEmpty) {
        showErrorMessage("Your UserName can't be blank");
        return;
      }

      String imageUrl = await uploadImageToStorage('profileImage', image!);
      await usersCollection.doc(currentUser!.email).update({
        'preference': preference,
        'username': username,
        'instagram': ig.isEmpty ? 'Empty...' : ig,
        'facebook': fb.isEmpty ? 'Empty...' : fb,
        'phone': pn.isEmpty ? 'Empty...' : pn,
        'imageLink': imageUrl,
      });

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => ProfilePage()),
        (Route<dynamic> route) => false,
      );
    }

    void selectImage() async {
      Uint8List img = await pickImage(ImageSource.gallery);
      setState(() {
        image = img;
      });
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
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection("Users").doc(currentUser!.email).snapshots(),
        builder: (context, snapshot) {
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final usernameController = TextEditingController(text: userData['username']);
          final preferenceEditingController = TextEditingController(text: userData['preference']);
          final igEditingController = TextEditingController(text: userData['instagram']);
          final fbEditingController = TextEditingController(text: userData['facebook']);
          final pnEditingController = TextEditingController(text: userData['phone']);
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            selectImage();
                          },
                          child: Stack(
                            children: [
                              if (image != null) 
                                SizedBox(
                                  width: 120,
                                  height: 120,
                                  child: CircleAvatar(
                                    radius: 64,
                                    backgroundImage: MemoryImage(image!),
                                  ),
                                )
                              else if (userData['imageLink'] != "")
                                SizedBox(
                                  width: 120,
                                  height: 120,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.network(
                                      userData['imageLink'],
                                      errorBuilder: (BuildContext context, o, s) => Image.asset(TImages.google),
                                    ),
                                  ),
                                )
                              else
                                SizedBox(
                                  width: 120,
                                  height: 120,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.asset(TImages.google),
                                  ),
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
                              ),
                            ],
                          ),
                        ),
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
                          updateProfile(
                            usernameController.text,
                            preferenceEditingController.text,
                            igEditingController.text,
                            fbEditingController.text,
                            pnEditingController.text
                          );
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
          );
        }
      ),
    );
  }
}