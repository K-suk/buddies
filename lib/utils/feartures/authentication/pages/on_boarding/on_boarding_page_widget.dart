import 'package:buddies_proto/utils/constants/colors.dart';
import 'package:buddies_proto/utils/feartures/authentication/models/model_on_boarding.dart';
import 'package:flutter/material.dart';
import 'package:buddies_proto/utils/constants/sizes.dart';

class OnBoardingPageWidget extends StatelessWidget {
  const OnBoardingPageWidget({
    super.key,
    required this.model,
  });

  final OnBoardingModel model;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      color: model.bgColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // mainAxisSize: MainAxisSize.max,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(image: AssetImage(model.image), height: size.height * 0.5,),
          Column(
            children: [
              Text(model.title, style: TextStyle().copyWith(fontSize: 24.0, fontWeight: FontWeight.w600, color: TColors.dark),),
              Text(model.subTitle, textAlign: TextAlign.center, style: TextStyle().copyWith(fontSize: 14.0, color: TColors.dark),),
            ],
          ),
          SizedBox(height: 50.0,)
        ],
      ),
    );
  }
}