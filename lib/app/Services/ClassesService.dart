import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:attendease/app/AppColors/AppConstants.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Network/dioServices.dart';

class ClassesService{
  Future<List<Map<String, dynamic>>> fetchClasses() async {
    String url = AppConstants.fetchClassesUrl;

    final Dio dio = DioService().dio;
    BotToast.showLoading();

    final List<Map<String, dynamic>> classList = [];

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
        return [];
      }

      final response = await dio.get(
        url,
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
          classList.add({
            'id': item['id'],
            'name': item['name'],
          });
          debugPrint("ID: ${item['id']} | Name: ${item['name']}");
        }
      } else {
        Get.snackbar(
          "Failure",
          "Failed to load classes.",
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

    return classList;
  }

}