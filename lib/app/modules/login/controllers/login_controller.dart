import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../Services/authServices.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  RxBool isUserLogging=false.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService authService = AuthService();

  ///Login
  void login() async {
    final success = await authService.loginUser(email: emailController.text, password: passwordController.text);
    if (success) {
      Get.offNamed(Routes.HOME);
    }
  }

}
