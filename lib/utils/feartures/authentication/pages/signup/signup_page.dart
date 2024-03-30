import 'package:buddies_proto/utils/feartures/authentication/pages/verify_email/verify_email_page.dart';
import 'package:buddies_proto/utils/feartures/authentication/pages/login/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:buddies_proto/utils/constants/image_strings.dart';
import 'package:buddies_proto/utils/constants/sizes.dart';
import 'package:buddies_proto/utils/constants/text_strings.dart';

class SignUpPage extends StatefulWidget {
  final Function()? onTap;
  const SignUpPage({super.key,  required this.onTap});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  // sign user in method
  void signUserUp() async {
    try {
      if (emailController.text.contains("@")){
        //if (emailController.text.split("@")[1] == "student.ubc.ca"){
          if (passwordController.text == confirmPasswordController.text){
            UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            );
            FirebaseFirestore.instance.collection("Users").doc(userCredential.user!.email).set({
              'username': emailController.text.split('@')[0],
              'bio': 'Empty bio...',
              'preference': '',
              'sex': '',
              'matchings': [],
              'instagram': '',
              'facebook': '',
              'phone': '000-000-0000',
              'cur_matching': '',
              'wait': false,
              'done': true,
              'imageLink': '',
            });
            try {
              await FirebaseAuth.instance.currentUser!.sendEmailVerification();
              Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyEmailPage(),));
            } on FirebaseException catch (e) {
              showErrorMessage(e.code);
            }
          //} else {
            //showErrorMessage("Password don't match!");
          //}
        } else {
          showErrorMessage("Sorry, but please go back to Saimon Fraser University L");
        }
      } else {
        showErrorMessage("@ must be included");
      }
    } on FirebaseAuthException catch (e) {
      
      showErrorMessage(e.code);
    }
  }
  //error message
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
  
  var _isObscure = true;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(image: const AssetImage("assets/logos/BUDDIES.png"), height: size * 0.2,),
                Text(TTexts.signupTitle, style: Theme.of(context).textTheme.headlineLarge,),
                Text(TTexts.signUpSubTitle, style: Theme.of(context).textTheme.bodyLarge,),
                Form(child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined),
                          labelText: TTexts.email,
                          hintText: "Email",
                        ),
                      ),
                      const SizedBox(height: TSizes.formHeight,),
                      TextFormField(
                        obscureText: _isObscure,
                        controller: passwordController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.key_outlined),
                          labelText: TTexts.password,
                          hintText: "Password",
                          suffixIcon: IconButton(
                            icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: TSizes.formHeight,),
                      TextFormField(
                        obscureText: _isObscure,
                        controller: confirmPasswordController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.key_outlined),
                          labelText: "Password(confirm)",
                          hintText: "Password (confirm)",
                          suffixIcon: IconButton(
                            icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 30,),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(onPressed: (){
                          signUserUp();
                        }, child: Text("Signup".toUpperCase()))
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(onTap: () {},),));
                          },
                          child: Text.rich(TextSpan(
                            text: "Already have an Account?",
                            style: Theme.of(context).textTheme.bodyLarge,
                            children: [
                              TextSpan(text: "Login", style: TextStyle(color: Colors.blue)),
                            ]
                          ))
                        ),
                      )
                    ],
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}