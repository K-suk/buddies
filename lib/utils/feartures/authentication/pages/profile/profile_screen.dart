import 'dart:typed_data';

import 'package:buddies_proto/utils/feartures/authentication/pages/other_pages/home_or_match_page.dart';
import 'package:buddies_proto/utils/feartures/authentication/pages/profile/update_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:buddies_proto/utils/constants/colors.dart';
import 'package:buddies_proto/utils/constants/image_strings.dart';
import 'package:buddies_proto/utils/constants/sizes.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection("Users");

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    var isDarkMode = brightness == Brightness.dark;
    return Scaffold(
        appBar: 
        isDarkMode ? 
        AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          leading: IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeOrMatchPage(),));
              }, icon: const Icon(LineAwesomeIcons.angle_left)),
          title: Text(
            "Profile",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ) :
        AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          leading: IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeOrMatchPage(),));
              }, icon: const Icon(LineAwesomeIcons.angle_left)),
          title: Text(
            "Profile",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection("Users").doc(currentUser.email!).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          userData['imageLink'] != "" ?
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(
                                  userData['imageLink'],
                                  errorBuilder: (BuildContext context, o, s) {
                                    return 
                                      Image(
                                        image: AssetImage("assets/logos/avator.png"),
                                      );
                                  },
                                ),
                            )
                          ) : 
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image(
                                  image: AssetImage("assets/logos/avator.png"),
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
                              child: const Icon(
                                LineAwesomeIcons.alternate_pencil,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        userData["username"],
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        currentUser.email!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileUpdatePage(),));
                          },
                          child: Text("Edit Profile"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: TColors.primary,
                              side: BorderSide.none,
                              shape: StadiumBorder()),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 10,
                      ),
                      Stack(children: [
                        ProfileMenuWidget(title: userData["sex"], icon: LineAwesomeIcons.genderless, onPress: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileUpdatePage(),));
                        },),
                        Positioned(
                          top: 0,
                          left: 65,
                          child: Text(
                            "Gender",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12),
                          )
                        )
                      ]),
                      Stack(children: [
                        ProfileMenuWidget(title: userData["preference"], icon: LineAwesomeIcons.beer, onPress: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileUpdatePage(),));
                        },),
                        Positioned(
                          top: 0,
                          left: 65,
                          child: Text(
                            "Hobby",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12),
                          )
                        )
                      ]),
                      Stack(children: [
                        ProfileMenuWidget(title: userData["bio"], icon: LineAwesomeIcons.file, onPress: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileUpdatePage(),));
                        },),
                        Positioned(
                          top: 0,
                          left: 65,
                          child: Text(
                            "Bio",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12),
                          )
                        )
                      ]),
                      const Divider(color: Colors.grey,),
                      const SizedBox(height: 10,),
                      Stack(children: [
                        ProfileMenuWidget(title: userData["instagram"], icon: LineAwesomeIcons.instagram, onPress: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileUpdatePage(),));
                        },),
                        Positioned(
                          top: 0,
                          left: 65,
                          child: Text(
                            "IG ID",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12),
                          )
                        )
                      ]),
                      Stack(children: [
                        ProfileMenuWidget(title: userData["facebook"], icon: LineAwesomeIcons.facebook, onPress: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileUpdatePage(),));
                        },),
                        Positioned(
                          top: 0,
                          left: 65,
                          child: Text(
                            "FB ID",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12),
                          )
                        )
                      ]),
                      Stack(children: [
                        ProfileMenuWidget(title: userData["phone"], icon: LineAwesomeIcons.phone, onPress: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileUpdatePage(),));
                        },),
                        Positioned(
                          top: 0,
                          left: 65,
                          child: Text(
                            "Phone Number",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12),
                          )
                        )
                      ]),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error${snapshot.error}'),);
            } else {
              return const Center(child: CircularProgressIndicator(),);
            }
          }
        ));
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: TColors.accent.withOpacity(0.1),
        ),
        child: Icon(
          icon,
          color: TColors.accent,
        ),
      ),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge?.apply(color: textColor)),
      trailing: endIcon? Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey.withOpacity(0.1),
        ),
        child: const Icon(
          LineAwesomeIcons.angle_right,
          size: 18.0,
          color: Colors.grey,
        ),
      ) : null,
    );
  }
}
