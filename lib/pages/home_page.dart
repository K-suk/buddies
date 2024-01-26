import 'package:buddies_proto/components/drawer.dart';
import 'package:buddies_proto/pages/login_or_register_page.dart';
import 'package:buddies_proto/pages/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signUserOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginOrRegisterPage()),
      (Route<dynamic> route) => false,
    );
  }

  void goToProfilePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  }

  Future<void> editCondition() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null || currentUser.email == null) {
      return;
    }
    DocumentSnapshot userDoc = await _firestore.collection('Users').doc(currentUser.email).get();
    DocumentSnapshot counterDoc = await _firestore.collection('Male_match_stack').doc('Counter').get();

    String gender = userDoc['sex'];
    String collectionName = gender == 'male' ? 'Male_match_stack' : 'Female_match_stack';

    await _firestore.collection(collectionName).doc(counterDoc['num'].toString()).update({
      'stack': FieldValue.arrayUnion([currentUser.email])
    });
    await _firestore.collection('Users').doc(currentUser.email).update({'wait?': true});
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
    User? currentUser = _auth.currentUser;
    if (currentUser == null || currentUser.email == null) {
      return const Scaffold(
        body: Center(child: Text("No user logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(),
      drawer: MyDrawer(
        onProfileTap: () => goToProfilePage(context),
        onSignOut: () => signUserOut(context),
      ),
      body: UserHomePageStreamBuilder(
        email: currentUser.email!,
        makeMatch: makeMatch,
        editCondition: editCondition,
      ),
    );
  }
}

class UserHomePageStreamBuilder extends StatelessWidget {
  final String email;
  final Future<void> Function() makeMatch;
  final Future<void> Function() editCondition;

  const UserHomePageStreamBuilder({
    Key? key,
    required this.email,
    required this.makeMatch,
    required this.editCondition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection("Users").doc(email).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('No data found'));
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final bool isWaiting = userData['wait?'] ?? false;

        return isWaiting 
          ? WaitingForMatchWidget(makeMatch: makeMatch)
          : ReadyToMatchWidget(editCondition: editCondition);
      },
    );
  }
}

class WaitingForMatchWidget extends StatelessWidget {
  final Future<void> Function() makeMatch;

  const WaitingForMatchWidget({Key? key, required this.makeMatch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Please wait for your buddy to be found"),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ElevatedButton(
            onPressed: () => makeMatch(), // Implement makeMatch
            child: const Text('Matching'),
          ),
        ),
      ],
    );
  }
}

class ReadyToMatchWidget extends StatelessWidget {
  final Future<void> Function() editCondition;

  const ReadyToMatchWidget({Key? key, required this.editCondition}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Let's find your drinking buddies!"),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ElevatedButton(
            onPressed: () => editCondition(), // Implement editCondition
            child: const Text('Find Buddies'),
          ),
        ),
      ],
    );
  }
}
