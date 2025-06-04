import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../AppColors/appColor.dart';
import '../controllers/splash_controller.dart';
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Get.put(SplashController());
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: SvgPicture.asset(
          'assets/images/splash_logo.svg',
          height: screenHeight * 0.2,
          width: screenWidth * 0.6,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
