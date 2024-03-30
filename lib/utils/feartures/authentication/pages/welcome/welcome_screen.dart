import 'package:buddies_proto/utils/feartures/authentication/pages/login/login_page.dart';
import 'package:buddies_proto/utils/feartures/authentication/pages/signup/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:buddies_proto/utils/constants/image_strings.dart';
import 'package:buddies_proto/utils/constants/sizes.dart';
import 'package:buddies_proto/utils/constants/text_strings.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image(
            image: AssetImage(TImages.welcomeScreenImage),
            height: height * 0.5,
          ),
          Column(
            children: [
              Text(
                "Let's get started!",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                TTexts.welcomeSubTitle,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(onTap: () {},),));
                    },
                    child: Text("Login".toUpperCase()
                  )
                )
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage(onTap: (){}),));
                    },
                    child: Text("Signup".toUpperCase()
                  )
                )
              ),
            ],
          )
        ],
      ),
    ));
  }
}
