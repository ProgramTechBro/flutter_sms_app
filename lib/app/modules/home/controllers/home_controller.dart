import 'package:attendease/app/Services/attendanceService.dart';
import 'package:attendease/app/Services/backgroundFetchService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Services/authServices.dart';

class HomeController extends GetxController {
  RxString attendanceDate = ''.obs;
  var isDropdownOpen = false.obs;
  var selectedOption = "Send SMS to All".obs;
  var isSmsSending=false.obs;
  final TextEditingController schoolIdController=TextEditingController();
  final AuthService authService = AuthService();
  final AttendanceService service=AttendanceService();
  Future<void> pickDate({
    required BuildContext context,
  }) async {
    var datePicked = await DatePicker.showSimpleDatePicker(
      context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2090),
      dateFormat: "dd-MMMM-yyyy",
      locale: DateTimePickerLocale.en_us,
      looping: true,
    );

    if (datePicked != null) {
      String formatted = DateFormat('dd/MM/yyyy').format(datePicked);
        attendanceDate.value = formatted;
    }
  }
  ///Fetch Attendance
  Future<void> fetchAttendance() async {
    // if (attendanceDate.value.isEmpty) {
    //   Get.snackbar("Error", "Please select attendance date");
    //   return;
    // }
    // try {
    //   DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(attendanceDate.value);
    //   String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
    //   service.fetchAttendance(formattedDate);
    // } catch (e) {
    //   Get.snackbar("Error", "Invalid date format");
    // }
    final attendance=await service.fetchAttendance('');
    if(attendance.isNotEmpty){
      isSmsSending.value=true;
      await scheduleSmsTask(attendanceMap: attendance, selectedOption: selectedOption.value);
      await waitForSmsCompletion();
    }

  }
  ///SmsTaskCompletion
  // Future<void> waitForSmsCompletion() async {
  //   final prefs = await SharedPreferences.getInstance();
  //
  //   while (true) {
  //     final isDone = prefs.getBool('sms_task_completed') ?? false;
  //     if (isDone) {
  //       isSmsSending.value = false;
  //       print("✅ SMS sending completed.");
  //       await prefs.setBool('sms_task_completed', false);
  //       break;
  //     }
  //     await Future.delayed(const Duration(seconds: 2));
  //   }
  // }
  Future<void> waitForSmsCompletion() async {
    final prefs = await SharedPreferences.getInstance();

    while (true) {
      final isDone = prefs.getBool('sms_task_completed') ?? false;
      if (isDone) {
        isSmsSending.value = false;
        print("✅ SMS sending completed.");

        final failureReason = prefs.getString('sms_task_failure_reason');
        if (failureReason != null) {
          Get.snackbar("SMS Service Failed", failureReason);
          await prefs.remove('sms_task_failure_reason');
        } else {
          Get.snackbar("Success", "SMS sending completed.");
        }

        await prefs.setBool('sms_task_completed', false);
        break;
      }
      await Future.delayed(const Duration(seconds: 2));
    }
  }
  ///Logout
  void logout(){
    authService.logoutUser();
  }
}
