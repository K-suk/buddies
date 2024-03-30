import 'dart:async';

import 'package:buddies_proto/components/drawer.dart';
import 'package:buddies_proto/utils/constants/image_strings.dart';
import 'package:buddies_proto/utils/constants/sizes.dart';
import 'package:buddies_proto/utils/feartures/authentication/pages/other_pages/login_or_register_page.dart';
import 'package:buddies_proto/utils/feartures/authentication/pages/profile/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Timer? _timer;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signUserOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginOrRegisterPage()),
      (Route<dynamic> route) => false,
    );
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _timer = Timer.periodic(Duration(minutes: 5), (Timer t) => makeMatch());
  // }

  void goToProfilePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
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
    await _firestore.collection('Users').doc(currentUser.email).update({'wait': true});
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
    FirebaseFirestore.instance.collection('Female_match_stack').doc('Counter').update({
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
          'matchings': FieldValue.arrayUnion([maleStack.elementAt(maleLeng-1-i)]),
          'wait': false,
          'done': false
        });
        FirebaseFirestore.instance.collection('Users').doc(maleStack.elementAt(maleLeng-1-i)).update({
          'cur_matching': maleStack.elementAt(i),
          'matchings': FieldValue.arrayUnion([maleStack.elementAt(i)]),
          'wait': false,
          'done': false
        });
      }
    }
    if (femaleLeng>1){
      for (int i = 0; i<(femaleLeng/2); i++){
        FirebaseFirestore.instance.collection('Users').doc(femaleStack.elementAt(i)).update({
          'cur_matching': femaleStack.elementAt(femaleLeng-1-i),
          'matchings': FieldValue.arrayUnion([femaleStack.elementAt(femaleLeng-1-i)]),
          'wait': false,
          'done': false
        });
        FirebaseFirestore.instance.collection('Users').doc(femaleStack.elementAt(femaleLeng-1-i)).update({
          'cur_matching': femaleStack.elementAt(i),
          'matchings': FieldValue.arrayUnion([femaleStack.elementAt(i)]),
          'wait': false,
          'done': false
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;
    if (currentUser == null || currentUser.email == null) {
      return const Scaffold(
        body: Center(child: Text("No user logged in")),
      );
    }
    final brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    
    return Scaffold(
      appBar: 
      isDarkMode ? AppBar(
        iconTheme: IconThemeData(color: Colors.white),
      ) : AppBar(
        iconTheme: IconThemeData(color: Colors.black),
      ),
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
        final bool isWaiting = userData['wait'] ?? false;

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
    var size = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                Image(image: const AssetImage(TImages.onBoardingImage3), height: size * 0.5,),
                Text("Please wait for your buddy to be found.", style: Theme.of(context).textTheme.headlineMedium,),
                // Text("To find your buddy, please click the button below! You'll connect to your buddy soon!", textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge,),
                const SizedBox(height: TSizes.formHeight,),
                const SizedBox(height: 24,),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                  ),
                  icon: Icon(LineAwesomeIcons.beer, size: 32),
                  label: Text(
                    'Find new buddy',
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: () {
                    makeMatch();
                  },
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}

class ReadyToMatchWidget extends StatelessWidget {
  final Future<void> Function() editCondition;

  const ReadyToMatchWidget({Key? key, required this.editCondition}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                Image(image: const AssetImage(TImages.onBoardingImage1), height: size * 0.5,),
                Text("Let's find your buddies!", style: Theme.of(context).textTheme.headlineLarge,),
                Text("To find your buddy, please click the button below! You'll connect to your buddy soon!", textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge,),
                const SizedBox(height: TSizes.formHeight,),
                const SizedBox(height: 24,),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                  ),
                  icon: Icon(LineAwesomeIcons.beer, size: 32),
                  label: Text(
                    'Find new buddy',
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: () {
                    editCondition();
                  },
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}
