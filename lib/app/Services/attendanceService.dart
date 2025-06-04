import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Network/dioServices.dart';

class AttendanceService {
  // Future<void> fetchAttendance(String date) async {
  //   const String testDate = '2025-05-29';
  //   print('Testing with fixed date: $testDate');
  //
  //   print('The pass date is $date');
  //   final Dio dio = DioService().dio;
  //   BotToast.showLoading();
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final token = prefs.getString('access_token');
  //     print('The access token is $token');
  //
  //     if (token == null) {
  //       BotToast.closeAllLoading();
  //       Get.snackbar(
  //         "Error",
  //         "Authentication token missing.",
  //         colorText: Colors.white,
  //         backgroundColor: Colors.red,
  //       );
  //       return;
  //     }
  //
  //     final response = await dio.get(
  //       'attendance/today',
  //       queryParameters: {'date': testDate},
  //       options: Options(headers: {'Authorization': 'Bearer $token'},receiveTimeout: const Duration(minutes: 2)),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = response.data is String
  //           ? jsonDecode(response.data)
  //           : response.data;
  //
  //       for (var entry in data) {
  //         debugPrint("Student Name: ${entry['student_name']}");
  //         debugPrint("Status: ${entry['status']}");
  //         debugPrint("Guardian Name: ${entry['guardian_name']}");
  //         debugPrint("Guardian Contact: ${entry['guardian_contact']}");
  //         debugPrint("---------------------------");
  //       }
  //     } else {
  //       Get.snackbar(
  //         "Failure",
  //         "Failed to load attendance data.",
  //         colorText: Colors.white,
  //         backgroundColor: Colors.red,
  //       );
  //     }
  //   } on TimeoutException catch (e) {
  //     debugPrint(e.toString());
  //     Get.snackbar(
  //       "Timeout",
  //       "The request timed out. Please try again.",
  //       colorText: Colors.white,
  //       backgroundColor: Colors.black87,
  //     );
  //   } on SocketException catch (e) {
  //     debugPrint(e.toString());
  //     Get.snackbar(
  //       "Failure",
  //       "No internet connection.",
  //     );
  //   } on DioException catch (e) {
  //     debugPrint(e.toString());
  //     Get.snackbar(
  //       "Error",
  //       e.response?.data['message'] ?? "Something went wrong.",
  //     );
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     Get.snackbar(
  //       "Error",
  //       e.toString(),
  //     );
  //   } finally {
  //     BotToast.closeAllLoading();
  //   }
  // }
  Future<Map<String, Map<String, String>>> fetchAttendance(String date) async {
    const String testDate = '2025-05-29';
    print('Testing with fixed date: $testDate');

    final Dio dio = DioService().dio;
    BotToast.showLoading();

    final Map<String, Map<String, String>> attendanceMap = {};

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
        'attendance/today',
        queryParameters: {'date': testDate},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          receiveTimeout: const Duration(minutes: 2),
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        for (var entry in data) {
          attendanceMap[entry['student_name']] = {
            'status': entry['status'],
            'guardian_contact': entry['guardian_contact'],
          };
          debugPrint("Student Name: ${entry['student_name']}");
          debugPrint("Status: ${entry['status']}");
          debugPrint("Guardian Contact: ${entry['guardian_contact']}");
          debugPrint("---------------------------");
        }
      } else {
        Get.snackbar(
          "Failure",
          "Failed to load attendance data.",
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

    return attendanceMap;
  }
}
