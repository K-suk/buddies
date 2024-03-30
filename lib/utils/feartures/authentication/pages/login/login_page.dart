import 'package:buddies_proto/utils/constants/colors.dart';
import 'package:buddies_proto/utils/feartures/authentication/pages/other_pages/home_or_match_page.dart';
import 'package:buddies_proto/utils/feartures/authentication/pages/forget_password/forget_password_mail/forget_password_mail.dart';
import 'package:buddies_proto/utils/feartures/authentication/pages/signup/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:buddies_proto/utils/constants/image_strings.dart';
import 'package:buddies_proto/utils/constants/sizes.dart';
import 'package:buddies_proto/utils/constants/text_strings.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  void signUserIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator(),);
      }
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeOrMatchPage(),));
    } on FirebaseAuthException catch (e) {

      Navigator.pop(context);
      
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
      });
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
                Image(image: const AssetImage("assets/logos/BUDDIES.png"), height: size * 0.3,),
                Text(TTexts.loginTitle, style: Theme.of(context).textTheme.headlineLarge,),
                Text(TTexts.loginSubTitle, style: Theme.of(context).textTheme.bodyLarge,),
                Form(child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person_outline_outlined),
                          labelText: TTexts.email,
                          hintText: "Email",
                        ),
                      ),
                      const SizedBox(height: TSizes.formHeight,),
                      TextFormField(
                        obscureText: _isObscure,
                        controller: passwordController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person_outline_outlined),
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
                      Align(alignment: Alignment.centerRight ,child: TextButton(onPressed: (){
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                          builder: (context) => Container(
                            padding: EdgeInsets.all(TSizes.defaultSpace),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(TTexts.forgetPasswordTitle, style: Theme.of(context).textTheme.headlineMedium,),
                                Text(TTexts.forgetPasswordSubTitle, style: Theme.of(context).textTheme.bodyMedium,),
                                const SizedBox(height: 30.0,),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPasswordMailPage(),));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(20.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.grey.shade200,
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.mail_outline, size: 60.0, color: Colors.black,),
                                        SizedBox(width: 10.0,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(TTexts.email, style: TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w600, color: TColors.dark),),
                                            Text("Reset via Email Verification.", style: TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.normal, color: TColors.dark),)
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }, child: Text(TTexts.forgetPassword))),
                      SizedBox(height: 30,),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(onPressed: (){
                          signUserIn();
                        }, child: Text("Login".toUpperCase()))
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage(onTap: () {},),));
                          },
                          child: Text.rich(TextSpan(
                            text: "Don't have an Account?",
                            style: Theme.of(context).textTheme.bodyLarge,
                            children: [
                              TextSpan(
                                text: "Signup", style: TextStyle(color: Colors.blue),
                              ),
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