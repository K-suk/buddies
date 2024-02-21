import 'package:flutter/material.dart';
import 'package:buddies_proto/utils/constants/image_strings.dart';
import 'package:buddies_proto/utils/constants/sizes.dart';
import 'package:buddies_proto/utils/constants/text_strings.dart';

class ForgetPasswordMailPage extends StatelessWidget {
  const ForgetPasswordMailPage({super.key});

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
                const SizedBox(height: TSizes.defaultSpace * 4,),
                Image(image: const AssetImage(TImages.onBoardingImage2), height: size * 0.3,),
                Text(TTexts.forgetPassword, style: Theme.of(context).textTheme.headlineLarge,),
                Text(TTexts.loginSubTitle, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge,),
                const SizedBox(height: TSizes.formHeight,),
                Form(child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text(TTexts.email),
                        hintText: "Your UBC Student Email",
                        prefixIcon: Icon(Icons.mail_outline_rounded),
                      ),
                    ),
                    const SizedBox(height: 20.0,),
                    SizedBox(width: double.infinity , child: ElevatedButton(onPressed: () {}, child: const Text("Next"))),
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