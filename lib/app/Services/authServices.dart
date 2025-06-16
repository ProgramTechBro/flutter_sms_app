import 'dart:async';
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Network/UrlHelper.dart';
import '../../Network/dioServices.dart';
import '../routes/app_pages.dart';

class AuthService {

  ///Login User
  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    BotToast.showLoading();
    final baseUrl = UrlHelper.getBaseUrlFromEmail(email);
    if (!Uri.tryParse(baseUrl)!.isAbsolute) {
      BotToast.closeAllLoading();
      Get.snackbar("Invalid Domain", "The domain derived from the email is not valid.");
      return false;
    }
    DioService.instance.initialize(baseUrl);
    final dio = DioService.instance.dio;
    try {
      final response = await dio.post(
        'login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        final accessToken = data['access_token'];
        final tokenType = data['token_type'];
        final expiresIn = data['expires_in'];
        final expiryDateTime = DateTime.now().add(Duration(seconds: expiresIn));
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', accessToken);
        await prefs.setBool('is_user_logged_in', true);
        await prefs.setString('base_url', baseUrl);
        await prefs.setString('token_expiry', expiryDateTime.toIso8601String());
        BotToast.closeAllLoading();
        Get.snackbar(
          "Success",
          "Logged in successfully",
        );
        return true;
      } else {
        BotToast.closeAllLoading();
        Get.snackbar(
          "Failure",
          "Something went wrong. Please try again.",
        );
        return false;
      }
    } on TimeoutException catch (e) {
      BotToast.closeAllLoading();
      debugPrint(e.toString());
      Get.snackbar(
        "Timeout",
        "The request timed out. Please try again.",
      );
      return false;
    } on SocketException catch (e) {
      BotToast.closeAllLoading();
      debugPrint(e.toString());
      Get.snackbar(
        "Failure",
        "No internet connection.",
      );
      return false;
    } on DioException catch (e) {
      BotToast.closeAllLoading();
      debugPrint(e.toString());

      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.unknown ||
          e.error is SocketException) {
        Get.snackbar(
          "Network Error",
          "Could not connect to the server. Please check the email or try again later.",
        );
        return false;
      }

      // final statusCode = e.response?.statusCode;
      // final errorMessage = e.response?.data['message']?.toString() ?? "Something went wrong.";
      final statusCode = e.response?.statusCode;
      final dynamic data = e.response?.data;
      String errorMessage;

      if (data is Map && data['message'] != null) {
        errorMessage = data['message'].toString();
      } else if (data is String) {
        errorMessage = data;
      } else {
        errorMessage = "Something went wrong.";
      }


      if (statusCode == 400) {
        Get.snackbar("Login Failed", errorMessage);
        return false;
      } else if (statusCode == 401) {
        Get.snackbar("Invalid Credentials", "Email or password is incorrect.");
        return false;
      } else if (statusCode == 403) {
        Get.snackbar("Access Denied", "You are not allowed to access this account.");
        return false;
      } else if (statusCode == 404) {
        Get.snackbar("Account Not Found", "No user found with this email.");
        return false;
      } else if (statusCode == 500) {
        Get.snackbar("Server Error", "Please try again later.");
        return false;
      }
      Get.snackbar("Error", errorMessage);
      return false;
    } catch (e) {
      BotToast.closeAllLoading();
      debugPrint(e.toString());
      Get.snackbar(
        "Error",
        e.toString(),
      );
      return false;
    }
  }
  ///Logout User
  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('token_expiry');
    await prefs.setBool('is_user_logged_in', false);
    await prefs.remove('base_url');
    Get.offAllNamed(Routes.LOGIN);
  }
}
