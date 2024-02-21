import 'package:buddies_proto/utils/feartures/authentication/pages/other_pages/login_or_register_page.dart';
import 'package:buddies_proto/utils/feartures/authentication/pages/other_pages/report_page.dart';
import 'package:buddies_proto/utils/feartures/authentication/pages/profile/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Match Page"),
        backgroundColor: Colors.grey[900],
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
                    return ListView(
                      children: [
                        const SizedBox(height: 50,),
                        const Icon(Icons.person, size: 72,),
                        const SizedBox(height: 50,),
                        Text(
                          userData['cur_matching'],
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Text(
                            "Your Buddy's detail",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                        Text(buddyData['username']),
                        Text(buddyData['bio']),
                        Text(buddyData['sex']),
                        Text(buddyData['preference'],),
                        Text(buddyData['facebook'],),
                        Text(buddyData['instagram'],),
                        Text(buddyData['phone'],),
                        (userData['followed'])?Center(child: Text('you are followed by your buddy'),):nil,
                        Center(child: 
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: ElevatedButton( 
                              onPressed: () => doneCondition(), 
                              child: const Text('Meet up done!'),
                            )
                          )
                        ),
                        (buddyData['followed'] == false)?Center(child: 
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: ElevatedButton( 
                              onPressed: () => followBuddy(), 
                              child: const Text("Notify your buddy that you follow one of your buddy's account"),
                            )
                          )
                        ): nil,
                        Center(child: 
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: ElevatedButton( 
                              onPressed: () => {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ReportPage(),))
                              }, 
                              child: const Text('Report User or Partner never replies'),
                            )
                          )
                        ),
                      ],
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
    );
  }
}