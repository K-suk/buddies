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
      title: TTexts.onBoardingTitle1,
      subTitle: TTexts.onBoardingSubTitle1,
      bgColor: TColors.tOnBoardingPage1Color,
      color: TColors.black)),
    OnBoardingPageWidget(model: OnBoardingModel(
      image: TImages.onBoardingImage2,
      title: TTexts.onBoardingTitle2,
      subTitle: TTexts.onBoardingSubTitle2,
      bgColor: TColors.tOnBoardingPage2Color,
      color: TColors.black)),
    OnBoardingPageWidget(model: OnBoardingModel(
      image: TImages.onBoardingImage3,
      title: TTexts.onBoardingTitle3,
      subTitle: TTexts.onBoardingSubTitle3,
      bgColor: TColors.tOnBoardingPage3Color,
      color: TColors.black)),
    WelcomeScreen(),
  ];
  
  onPageChangedCallback(int activePageIndex) {
    currentPage.value = activePageIndex;
  }
}