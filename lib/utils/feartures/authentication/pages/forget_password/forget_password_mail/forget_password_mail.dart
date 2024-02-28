import 'package:buddies_proto/utils/feartures/authentication/pages/login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:buddies_proto/utils/constants/image_strings.dart';
import 'package:buddies_proto/utils/constants/sizes.dart';
import 'package:buddies_proto/utils/constants/text_strings.dart';

class ForgetPasswordMailPage extends StatelessWidget {
  const ForgetPasswordMailPage({super.key});

  Future resetPassword(String email, BuildContext context) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Column(
              children: [
                Text(
                  "Password Reset Email sent",
                  style: const TextStyle(color: Colors.white),
                ),
                ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(onTap: () {  },),));
                  }, 
                  child: Text("Login".toUpperCase())
                )
              ]
            )
          )
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.height;
    final emailController = TextEditingController();
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                const SizedBox(height: TSizes.defaultSpace * 4,),
                Image(image: const AssetImage(TImages.onBoardingImage2), height: size * 0.3,),
                Text(TTexts.forgetPassword, style: Theme.of(context).textTheme.headlineLarge,),
                Text(TTexts.loginSubTitle, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge,),
                const SizedBox(height: TSizes.formHeight,),
                Form(child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        label: Text(TTexts.email),
                        hintText: "Your UBC Student Email",
                        prefixIcon: Icon(Icons.mail_outline_rounded),
                      ),
                    ),
                    const SizedBox(height: 20.0,),
                    SizedBox(width: double.infinity , child: ElevatedButton(onPressed: () {
                      resetPassword(emailController.text.trim(), context);
                    }, child: const Text("Next"))),
                  ],
                ))
              ],
            ),
          ),
        )
      ),
    );
  }
}