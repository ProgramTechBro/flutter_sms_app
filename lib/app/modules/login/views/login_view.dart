import 'package:attendease/app/AppColors/appColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/CustomTextField.dart';
import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double horizontalPadding = screenWidth * 0.05;
    final double verticalPadding = screenHeight * 0.025;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: controller.formKey,
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.015),
                  SvgPicture.asset(
                    'assets/images/logo.svg',
                    height: screenHeight * 0.23,
                    width: screenWidth * 0.5,
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  CustomTextField(
                    controller: controller.emailController,
                    hint: 'Email',
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Email is required";
                      } else if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(val)) {
                        return 'Enter a valid email address';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  CustomTextField(
                    controller: controller.passwordController,
                    hint: 'Password',
                    validator: (val) {
                      if (val == null || (val.isEmpty)) {
                        return "Password is required";
                      } else if (val.length < 6) {
                        return "Enter at least 6 characters";
                      } else {
                        return null;
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Center(
              child: Obx(() {
                final isLoading = controller.isUserLogging.value;

                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.17,
                      vertical: screenHeight * 0.015,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: isLoading
                      ? null
                      : () {
                    FocusManager.instance.primaryFocus?.unfocus();
                   if (controller.formKey.currentState!.validate()) {
                     controller.login();
                   }
                  },
                  child: isLoading
                      ? CircularProgressIndicator(
                    color: Colors.white,
                    //strokeWidth: 2.5,
                  )
                      : Text(
                    'Login',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.042,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
