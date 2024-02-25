import 'package:buddies_proto/utils/constants/colors.dart';
import 'package:buddies_proto/utils/constants/image_strings.dart';
import 'package:buddies_proto/utils/constants/sizes.dart';
import 'package:buddies_proto/utils/feartures/authentication/pages/other_pages/login_or_register_page.dart';
import 'package:buddies_proto/utils/feartures/authentication/pages/other_pages/report_page.dart';
import 'package:buddies_proto/utils/feartures/authentication/pages/profile/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:nil/nil.dart';

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
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(),));
  }
  Future<void> doneCondition() async{
    CollectionReference ppl = FirebaseFirestore.instance.collection('Users');
    final user = await ppl.doc(currentUser.email).get();
    final match = user.get('cur_matching');
    final buddy = await ppl.doc(match).get();
    if (buddy.get('done?')){
      FirebaseFirestore.instance.collection('Users').doc(currentUser.email).update({
        'done?': true,
        'cur_matching': "",
      });
      FirebaseFirestore.instance.collection('Users').doc(match).update({
        'cur_matching': "",
        'followed': false
      });
    } else {
      FirebaseFirestore.instance.collection('Users').doc(currentUser.email).update({
        'done?': true,
      });
      FirebaseFirestore.instance.collection('Users').doc(match).update({
        'followed': false
      });
    }
  }
  Future<void> followBuddy() async{
    CollectionReference ppl = FirebaseFirestore.instance.collection('Users');
    final user = await ppl.doc(currentUser.email).get();
    final match = user.get('cur_matching');
    FirebaseFirestore.instance.collection('Users').doc(match).update({
      'followed': true
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Match Page"),
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection("Users").doc(currentUser.email!).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              if (userData['done?']){
                return Column(
                  children: [
                    Center(child: Text("Please wait for your buddy press done"),),
                  ],
                );
              } else {
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection("Users").doc(userData['cur_matching']).get(),
                  builder: (context, buddySnapshot) {
                    if (buddySnapshot.hasData) {
                      final buddyData = buddySnapshot.data!.data() as Map<String, dynamic>;
                      return SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(TSizes.defaultSpace),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Your Buddy's info", style: Theme.of(context).textTheme.headlineSmall,)
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Stack(
                                children: [
                                  SizedBox(
                                    width: 120,
                                    height: 120,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child: const Image(
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
                                height: 10,
                              ),
                              const Divider(),
                              const SizedBox(
                                height: 10,
                              ),
                              Stack(children: [
                                ProfileMenuWidget(title: userData["sex"], icon: LineAwesomeIcons.genderless),
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
                                ProfileMenuWidget(title: userData["preference"], icon: LineAwesomeIcons.beer),
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
                                ProfileMenuWidget(title: userData["bio"], icon: LineAwesomeIcons.file),
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
                                ProfileMenuWidget(title: userData["instagram"], icon: LineAwesomeIcons.instagram),
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
                                ProfileMenuWidget(title: userData["facebook"], icon: LineAwesomeIcons.facebook),
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
                                ProfileMenuWidget(title: userData["phone"], icon: LineAwesomeIcons.phone),
                                Positioned(
                                  top: 0,
                                  left: 65,
                                  child: Text(
                                    "Phone Number",
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12),
                                  )
                                )
                              ]),
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width*0.4,
                                    child: ElevatedButton(onPressed: (){
                                      doneCondition();
                                    }, child: Text("Done"))
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width*0.4,
                                    child: ElevatedButton(onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ReportPage(),));
                                    }, child: Text("Report user"))
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (buddySnapshot.hasError) {
                      return Center(child: Text('Error: ${buddySnapshot.error}'));
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                );
              }
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    super.key,
    required this.title,
    required this.icon,
    this.endIcon = true,
    this.textColor,
  });

  final String title;
  final IconData icon;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
