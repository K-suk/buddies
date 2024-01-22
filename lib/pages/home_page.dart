import 'package:buddies_proto/components/drawer.dart';
import 'package:buddies_proto/pages/login_or_register_page.dart';
import 'package:buddies_proto/pages/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final currentUser = FirebaseAuth.instance.currentUser!;

  void signUserOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginOrRegisterPage()));
  }
  void goToProfilePage(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage(),));
  }
  Future<void> editCondition() async{
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    final user = await users.doc(currentUser.email!).get();
    CollectionReference counts = FirebaseFirestore.instance.collection('Male_match_stack');
    final counter = await counts.doc('Counter').get();
    if (user.get('sex')=='male'){
      FirebaseFirestore.instance.collection('Male_match_stack').doc(counter.get('num').toString()).update({
        'stack': FieldValue.arrayUnion([currentUser.email!])
      });
    }else{
      FirebaseFirestore.instance.collection('Female_match_stack').doc(counter.get('num').toString()).update({
        'stack': FieldValue.arrayUnion([currentUser.email!])
      });
    }
    FirebaseFirestore.instance.collection('Users').doc(currentUser.email!).update({'wait?': true});
  }
  Future<void> makeMatch() async{
    CollectionReference counts = FirebaseFirestore.instance.collection('Male_match_stack');
    final counter = await counts.doc('Counter').get();
    final cur_cnt = counter.get('num');
    CollectionReference males = FirebaseFirestore.instance.collection('Male_match_stack');
    final male = await males.doc(cur_cnt.toString()).get();
    final maleStack = male.get('stack');
    int maleLeng = maleStack.length;
    CollectionReference females = FirebaseFirestore.instance.collection('Female_match_stack');
    final female = await females.doc(cur_cnt.toString()).get();
    final femaleStack = female.get('stack');
    int femaleLeng = femaleStack.length;
    final new_cnt = cur_cnt + 1;
    FirebaseFirestore.instance.collection('Male_match_stack').doc('Counter').update({
      'num': new_cnt
    });
    if (maleLeng.isOdd){
      maleLeng -= 1;
      FirebaseFirestore.instance.collection('Male_match_stack').doc(new_cnt.toString()).set({
        'stack': [maleStack.last]
      });
    } else {
      FirebaseFirestore.instance.collection('Male_match_stack').doc(new_cnt.toString()).set({
        'stack': []
      });
    }
    if (femaleLeng.isOdd){
      femaleLeng -= 1;
      FirebaseFirestore.instance.collection('Female_match_stack').doc(new_cnt.toString()).set({
        'stack': [femaleStack.last]
      });
    } else {
      FirebaseFirestore.instance.collection('Female_match_stack').doc(new_cnt.toString()).set({
        'stack': []
      });
    }
    if (maleLeng>1){
      for (int i = 0; i<(maleLeng/2); i++){
        FirebaseFirestore.instance.collection('Users').doc(maleStack.elementAt(i)).update({
          'cur_matching': maleStack.elementAt(maleLeng-1-i),
          'matching ppl': FieldValue.arrayUnion([maleStack.elementAt(maleLeng-1-i)]),
          'wait?': false,
          'done?': false
        });
        FirebaseFirestore.instance.collection('Users').doc(maleStack.elementAt(maleLeng-1-i)).update({
          'cur_matching': maleStack.elementAt(i),
          'matching ppl': FieldValue.arrayUnion([maleStack.elementAt(i)]),
          'wait?': false,
          'done?': false
        });
      }
    }
    if (femaleLeng>1){
      for (int i = 0; i<(femaleLeng/2); i++){
        FirebaseFirestore.instance.collection('Users').doc(femaleStack.elementAt(i)).update({
          'cur_matching': femaleStack.elementAt(femaleLeng-1-i),
          'matching ppl': FieldValue.arrayUnion([femaleStack.elementAt(femaleLeng-1-i)]),
          'wait?': false,
          'done?': false
        });
        FirebaseFirestore.instance.collection('Users').doc(femaleStack.elementAt(femaleLeng-1-i)).update({
          'cur_matching': femaleStack.elementAt(i),
          'matching ppl': FieldValue.arrayUnion([femaleStack.elementAt(i)]),
          'wait?': false,
          'done?': false
        });
      }
    }
    FirebaseFirestore.instance.collection('Male_match_stack').doc(cur_cnt.toString()).delete();
    FirebaseFirestore.instance.collection('Female_match_stack').doc(cur_cnt.toString()).delete();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: MyDrawer(
        onProfileTap: () => goToProfilePage(context),
        onSignOut: () => signUserOut(context),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection("Users").doc(currentUser.email!).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData){
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final flag = userData['wait?'];
            if (flag){
              return Column(
                children: [
                  Center(child: Text("Please wait for your buddy is found"),),
                  Center(child: 
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ElevatedButton( 
                        onPressed: () => makeMatch(), 
                        child: const Text('Matcing'),
                      )
                    )
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  Center(child: Text("Let's find your drinking buddies!")),
                  Center(child: 
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ElevatedButton( 
                        onPressed: () => editCondition(), 
                        child: const Text('Find Buddies'),
                      )
                    )
                  ),
                ],
              );
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