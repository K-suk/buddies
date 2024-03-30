import 'package:buddies_proto/utils/feartures/authentication/models/model_on_boarding.dart';
import 'package:buddies_proto/utils/feartures/authentication/pages/on_boarding/on_boarding_page_widget.dart';
import 'package:buddies_proto/utils/feartures/authentication/pages/welcome/welcome_screen.dart';
import 'package:get/state_manager.dart';
import 'package:liquid_swipe/PageHelpers/LiquidController.dart';
import 'package:buddies_proto/utils/constants/colors.dart';
import 'package:buddies_proto/utils/constants/image_strings.dart';
import 'package:buddies_proto/utils/constants/text_strings.dart';

class OnBoardingController extends GetxController{
  final controller = LiquidController();
  RxInt currentPage = 0.obs;
  final pages = [
    OnBoardingPageWidget(model: OnBoardingModel(
      image: TImages.onBoardingImage1,
      title: "Make new Buddy!",
      subTitle: "If you are tired of current relationship, and wanna find new relationship, we got you!",
      bgColor: TColors.tOnBoardingPage1Color,
      color: TColors.black)),
    OnBoardingPageWidget(model: OnBoardingModel(
      image: TImages.onBoardingImage2,
      title: "Make your account!",
      subTitle: "You have to create account with ubc student email, then verify your account via email!",
      bgColor: TColors.tOnBoardingPage2Color,
      color: TColors.black)),
    OnBoardingPageWidget(model: OnBoardingModel(
      image: TImages.onBoardingImage3,
      title: "Your buddy will be there!",
      subTitle: "After signing up, change your profile, and wait for we find your new buddy.",
      bgColor: TColors.tOnBoardingPage3Color,
      color: TColors.black)),
    WelcomeScreen(),
  ];
  
  onPageChangedCallback(int activePageIndex) {
    currentPage.value = activePageIndex;
  }
}