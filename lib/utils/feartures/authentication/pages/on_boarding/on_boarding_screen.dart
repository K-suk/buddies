import 'package:buddies_proto/utils/feartures/authentication/controller/on_boarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class OnBoardingScreen extends StatelessWidget {
  OnBoardingScreen({super.key});
  // final controller = LiquidController();
  // int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final obcontroller = OnBoardingController();
    return Scaffold(
      body: Stack(
        children: [
          LiquidSwipe(
            pages: obcontroller.pages,
            liquidController: obcontroller.controller,
            slideIconWidget: const Icon(Icons.arrow_back_ios),
            onPageChangeCallback: obcontroller.onPageChangedCallback,
            enableSideReveal: true,
          ),
          Obx(
            () => Positioned(
              top: 30,
              right: 170,
              child: AnimatedSmoothIndicator(
                activeIndex: obcontroller.currentPage.value,
                count: 4,
                effect: const WormEffect(
                  activeDotColor: Color(0xff272727),
                  dotHeight: 5.0,
                ),
              )
            ),
          )
        ],
      ),
    );
  }
}