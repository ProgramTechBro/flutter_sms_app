import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Network/dioServices.dart';

class ComposeMessageServices{
  Future<Map<String, Map<String, String>>> fetchContacts(String endpoint) async {
    final Dio dio = DioService().dio;
    BotToast.showLoading();

    final Map<String, Map<String, String>> contactMap = {};

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      print('The access token is $token');

      if (token == null) {
        Get.snackbar(
          "Error",
          "Authentication token missing.",
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
        return {};
      }

      final response = await dio.get(
        endpoint,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        for (var item in data) {
          final name = item['name'] ?? item['student_name'] ?? item['full_name'];
          final phone = item['phone'] ?? item['guardian_contact'];

          if (name != null && phone != null) {
            contactMap[name.toString()] = {
              'phone': phone.toString(),
            };
            debugPrint("Name: $name");
            debugPrint("Phone: $phone");
            debugPrint("---------------------------");
          }
        }
      } else {
        Get.snackbar(
          "Failure",
          "Failed to load contact data.",
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      }
    } on TimeoutException catch (e) {
      debugPrint(e.toString());
      Get.snackbar(
        "Timeout",
        "The request timed out. Please try again.",
        colorText: Colors.white,
        backgroundColor: Colors.black87,
      );
    } on SocketException catch (e) {
      debugPrint(e.toString());
      Get.snackbar("Failure", "No internet connection.");
    } on DioException catch (e) {
      debugPrint(e.toString());
      Get.snackbar(
        "Error",
        e.response?.data['message'] ?? "Something went wrong.",
      );
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar("Error", e.toString());
    } finally {
      BotToast.closeAllLoading();
    }

    return contactMap;
  }

}