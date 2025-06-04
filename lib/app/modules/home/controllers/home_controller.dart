import 'dart:ffi';

import 'package:attendease/app/AppColors/AppConstants.dart';
import 'package:attendease/app/Services/attendanceService.dart';
import 'package:attendease/app/Services/backgroundFetchService.dart';
import 'package:attendease/app/Services/composeMessageServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Services/ClassesService.dart';
import '../../../Services/authServices.dart';

class HomeController extends GetxController {
  RxString attendanceDate = ''.obs;
  var isDropdownOpen = false.obs;
  var selectedOption = "Send SMS to All".obs;
  var classSelectedOption = "Nursery".obs;
  final RxList<String> classOptions = <String>[].obs;
  List<Map<String, dynamic>> globalClassList = [];
  var composeSelectedOption = "All School".obs;
  var isComposeDropdownOpen = false.obs;
  var isClassDropdownOpen = false.obs;
  var isSmsSending=false.obs;
  var isComposeSmsSending=false.obs;
  final TextEditingController subjectController=TextEditingController();
  final TextEditingController messageController=TextEditingController();
  final AuthService authService = AuthService();
  final AttendanceService service=AttendanceService();
  final ClassesService classService=ClassesService();
  final ComposeMessageServices composeService=ComposeMessageServices();
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
  ///////////////////////Fetch Attendance Functionality//////////////////////////
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
    else{
      Get.snackbar("Error", "Fetched Student List is Empty.");
    }

  }
  ///SmsTaskCompletion
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
          Get.snackbar("Success", "SMS Sending Service completed.");
        }

        await prefs.setBool('sms_task_completed', false);
        break;
      }
      await Future.delayed(const Duration(seconds: 2));
    }
  }
  ///////////////////////Fetch Class Functionality//////////////////////////
  ///Fetch Classes
  Future<void> fetchClasses() async {
    globalClassList = await classService.fetchClasses();
    List<String> classNames = extractClassNames(globalClassList);
    if (classNames.isNotEmpty) {
      classOptions.value = classNames;
      classSelectedOption.value = classNames.first;
    }
  }
  /// Helper Function
  List<String> extractClassNames(List<Map<String, dynamic>> classList) {
    return classList
        .where((item) => item.containsKey('name') && item['name'] != null)
        .map((item) => item['name'] as String)
        .toList();
  }
  int? getClassIdByName(String className) {
    for (var classItem in globalClassList) {
      if (classItem['name'] == className) {
        return classItem['id'] as int;
      }
    }
    print(" Class name '$className' not found.");
    return null;
  }

  ///////////////////////Compose Message Functionality//////////////////////////
  ///Compose Message
  Future<void> composeMessage() async {
    Map<String, Map<String, String>> recipients = {};
    if (composeSelectedOption.value == 'All School') {
      recipients = await composeService.fetchContacts(AppConstants.fetchAllSchoolUrl);
    } else if (composeSelectedOption.value == 'Only Staff') {
      recipients = await composeService.fetchContacts(AppConstants.fetchStaffUrl);
    } else if (composeSelectedOption.value == 'Any Class') {
      final selectedClass = getClassIdByName(classSelectedOption.value);

      if (selectedClass!=null) {
        final url = AppConstants.fetchClassStudent + selectedClass.toString();
        print('the url is $url');
        recipients = await composeService.fetchContacts(url);
      } else {
        Get.snackbar("Error", "Please select a class first.");
        return;
      }
    }
    if(recipients.isNotEmpty){
      isComposeSmsSending.value=true;
      await scheduleContactSmsTask(contactMap: recipients,message: messageController.text,selectedOption: composeSelectedOption.value);
      await waitForContactSmsCompletion();

    }
    else{
      Get.snackbar("Error", "Fetched Recipients List is Empty.");
    }
    debugPrint("Recipients fetched: ${recipients.length}");
  }
  ///ContactSmsTaskCompletion
  Future<void> waitForContactSmsCompletion() async {
    final prefs = await SharedPreferences.getInstance();

    while (true) {
      final isDone = prefs.getBool('contact_sms_task_completed') ?? false;
      if (isDone) {
        isComposeSmsSending.value = false;
        print("✅ SMS sending completed.");

        final failureReason = prefs.getString('contact_sms_task_failure_reason');
        if (failureReason != null) {
          Get.snackbar("SMS Service Failed", failureReason);
          await prefs.remove('contact_sms_task_failure_reason');
        } else {
          Get.snackbar("Success", "SMS Sending Service completed.");
        }

        await prefs.setBool('contact_sms_task_completed', false);
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
