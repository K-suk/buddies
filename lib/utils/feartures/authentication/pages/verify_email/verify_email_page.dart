import 'dart:async';
import 'package:buddies_proto/utils/feartures/authentication/pages/home_page/home_page.dart';
import 'package:buddies_proto/utils/constants/image_strings.dart';
import 'package:buddies_proto/utils/constants/sizes.dart';
import 'package:buddies_proto/utils/feartures/authentication/pages/profile/add_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;
  String? sex;
  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    timer = Timer.periodic(
      Duration(seconds: 3),
      (_) => checkEmailVerified(),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future sendVerificationEmail() async {
    try{
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() => canResendEmail = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.deepPurple,
            title: Center(
              child: Text(
                e.code,
                style: const TextStyle(color: Colors.white),
              ),
            )
          );
        }
      );
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    final currentUser = FirebaseAuth.instance.currentUser!;
    if (currentUser.emailVerified) {
      // Fetch Firestore data asynchronously
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection("Users").doc(currentUser.email).get();
      Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;
      setState(() {
        isEmailVerified = currentUser.emailVerified;
        // Use userData here as needed, or pass it to another function/state
        sex = userData!['sex'];
      });
      if (sex!.isEmpty){
        timer?.cancel();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ProfileAddPage()), // Redirect to ProfileAddPage
        );
      } else {
        timer?.cancel();
      }
    } else {
      setState(() {
        isEmailVerified = currentUser.emailVerified;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.height;
    return
    isEmailVerified
      ? HomePage()
      : SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Column(
                  children: [
                    const SizedBox(height: TSizes.defaultSpace * 4,),
                    Image(image: const AssetImage(TImages.onBoardingImage2), height: size * 0.3,),
                    Text("Verify Email", style: Theme.of(context).textTheme.headlineLarge,),
                    Text('A verification email has been sent to your student email', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge,),
                    const SizedBox(height: TSizes.formHeight,),
                    const SizedBox(height: 24,),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(50),
                      ),
                      icon: Icon(Icons.email, size: 32),
                      label: Text(
                        'Resent Email',
                        style: TextStyle(fontSize: 24),
                      ),
                      onPressed: () {
                        canResendEmail ? sendVerificationEmail() : null;
                      },
                    ),
                    SizedBox(height: 8,),
                    TextButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(50),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(fontSize: 24),
                      ),
                      onPressed: () => FirebaseAuth.instance.signOut(),
                      //ここでユーザー情報そのものも消せるようにしたい、データを溜め込みすぎると重くなってしまうんご
                    ),
                  ],
                ),
              ),
            )
          ),
        );
  }
}