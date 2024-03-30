import 'package:buddies_proto/components/drawer.dart';
import 'package:buddies_proto/utils/constants/image_strings.dart';
import 'package:buddies_proto/utils/constants/sizes.dart';
import 'package:buddies_proto/utils/feartures/authentication/pages/other_pages/login_or_register_page.dart';
import 'package:buddies_proto/utils/feartures/authentication/pages/profile/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DonePage extends StatelessWidget {
  const DonePage({super.key});

  @override
  Widget build(BuildContext context) {
    void signUserOut(BuildContext context) {
      FirebaseAuth.instance.signOut();
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginOrRegisterPage()));
    }
    void goToProfilePage(BuildContext context) {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(),));
    }
    var size = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                Image(image: const AssetImage(TImages.onBoardingImage2), height: size * 0.5,),
                Text("Please wait for your buddy press done...", style: Theme.of(context).textTheme.headlineLarge,),
                // Text("To find your buddy, please click the button below! You'll connect to your buddy soon!", textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge,),
                const SizedBox(height: TSizes.formHeight,),
              ],
            ),
          ),
        )
    );
  }
}