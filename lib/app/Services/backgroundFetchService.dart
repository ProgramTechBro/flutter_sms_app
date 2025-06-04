import 'dart:async';
import 'dart:convert';
import 'package:background_fetch/background_fetch.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_advanced/sms_advanced.dart';
/// Register background fetch
Future<void> initializeBackgroundFetch() async {
  await _requestSmsPermission();

  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);

  await BackgroundFetch.configure(
    BackgroundFetchConfig(
      minimumFetchInterval: 15,
      stopOnTerminate: false,
      enableHeadless: true,
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresStorageNotLow: false,
      requiresDeviceIdle: false,
      requiredNetworkType: NetworkType.NONE,
      startOnBoot: true,
      forceAlarmManager: true,
    ),
        (String taskId) async {
      print("[BackgroundFetch] Event received: $taskId");

      // if (taskId == 'send_sms_task') {
      //   await sendTestSms();
      // }
      if (taskId == 'send_sms_task') {
        await sendTestSms();
      } else if (taskId == 'compose_sms_task') {
        await sendContactSms();
      }


      BackgroundFetch.finish(taskId);
    },
        (String taskId) async {
      print("[BackgroundFetch] Timeout: $taskId");
      BackgroundFetch.finish(taskId);
    },
  );
}

/// Ask for SMS permissions
Future<void> _requestSmsPermission() async {
  var status = await Permission.sms.status;
  if (!status.isGranted) {
    status = await Permission.sms.request();
    if (!status.isGranted) {
      print("❌ SMS permission denied.");
    } else {
      print("✅ SMS permission granted.");
    }
  }
}
/// Background task entry point
@pragma('vm:entry-point')
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool timeout = task.timeout;

  if (timeout) {
    print('[BackgroundFetch] ⏰ Headless task timeout: $taskId');
    BackgroundFetch.finish(taskId);
    return;
  }

  print('[BackgroundFetch] 🟢 Headless task received: $taskId');

  // if (taskId == 'send_sms_task') {
  //   await sendTestSms();
  // }
  if (taskId == 'send_sms_task') {
    await sendTestSms();
  } else if (taskId == 'compose_sms_task') {
    await sendContactSms();
  }


  BackgroundFetch.finish(taskId);
}
/// Schedule background task
@pragma('vm:entry-point')
Future<void> scheduleSmsTask({
  required Map<String, Map<String, String>> attendanceMap,
  required String selectedOption,
}) async {
  await saveAttendanceDataToPrefs(
    attendanceMap: attendanceMap,
    selectedOption: selectedOption,
  );
  bool scheduled = await BackgroundFetch.scheduleTask(
    TaskConfig(
      taskId: "send_sms_task",
      delay: 1000,
      periodic: false,
      enableHeadless: true,
      stopOnTerminate: true,
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresStorageNotLow: false,
      requiresDeviceIdle: false,
      requiredNetworkType: NetworkType.NONE,
      startOnBoot: true,
      forceAlarmManager: true,
    ),
  );

  print("📅 SMS sending task scheduled: $scheduled");
}


// @pragma('vm:entry-point')
// Future<void> sendTestSms() async {
//   final prefs = await SharedPreferences.getInstance();
//   SmsSender sender = SmsSender();
//
//   var status = await Permission.sms.status;
//   if (!status.isGranted) {
//     status = await Permission.sms.request();
//     if (!status.isGranted) {
//       print("❌ SMS permission denied during send.");
//       return;
//     }
//   }
//
//   final attendanceMap = await loadAttendanceDataFromPrefs();
//   final selectedOption = prefs.getString('selected_option') ?? 'Send SMS to All';
//
//   for (var entry in attendanceMap.entries) {
//     String phoneNumber = entry.key;
//     Map<String, String> studentData = entry.value;
//     String studentName = studentData['student_name'] ?? 'Student';
//     String attendanceStatus = studentData['status'] ?? 'present';
//     bool shouldSend = false;
//
//     if (selectedOption == 'Send SMS to All') {
//       shouldSend = true;
//     } else if (selectedOption == 'Only Absents' && attendanceStatus == 'absent') {
//       shouldSend = true;
//     } else if (selectedOption == 'Absents + Leave' &&
//         (attendanceStatus == 'absent' || attendanceStatus == 'leave')) {
//       shouldSend = true;
//     }
//
//     if (!shouldSend) continue;
//
//     String message = getSmsMessage(
//       name: studentName,
//       status: attendanceStatus,
//     );
//     print('The phone no is $phoneNumber');
//     SmsMessage sms = SmsMessage(phoneNumber, message);
//     sms.onStateChanged.listen((state) {
//       if (state == SmsMessageState.Sent) {
//         print("✅ SMS sent to $phoneNumber.");
//       } else if (state == SmsMessageState.Fail) {
//         print("❌ SMS failed to send to $phoneNumber.");
//       }
//     });
//
//     sender.sendSms(sms);
//     print("📤 Sending SMS to $phoneNumber. Waiting 10 seconds...");
//     await Future.delayed(const Duration(seconds: 10));
//   }
//   await clearAttendanceDataFromPrefs();
//   await prefs.setBool('sms_task_completed', true);
// }
//
// /// Save Attendance Map
// Future<void> saveAttendanceDataToPrefs({
//   required Map<String, Map<String, String>> attendanceMap,
//   required String selectedOption,
// }) async {
//   final prefs = await SharedPreferences.getInstance();
//   final attendanceJson = attendanceMap.map(
//         (key, value) => MapEntry(key, jsonEncode(value)),
//   );
//   await prefs.setStringList('attendance_keys', attendanceJson.keys.toList());
//   await prefs.setStringList(
//     'attendance_values',
//     attendanceJson.values.toList(),
//   );
//   await prefs.setString('selected_option', selectedOption);
//
//   print("Attendance data saved to SharedPreferences.");
// }
//
// /// Load Attendance Map
// Future<Map<String, Map<String, String>>> loadAttendanceDataFromPrefs() async {
//   final prefs = await SharedPreferences.getInstance();
//   final keys = prefs.getStringList('attendance_keys') ?? [];
//   final values = prefs.getStringList('attendance_values') ?? [];
//
//   Map<String, Map<String, String>> map = {};
//   for (int i = 0; i < keys.length; i++) {
//     map[keys[i]] = Map<String, String>.from(
//       jsonDecode(values[i]) as Map<String, dynamic>,
//     );
//   }
//   return map;
// }
//
// /// Clear Attendance MAP
// Future<void> clearAttendanceDataFromPrefs() async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.remove('attendance_keys');
//   await prefs.remove('attendance_values');
//   await prefs.remove('selected_option');
//   print("🧹 Cleared attendance data from SharedPreferences.");
// }
/// Function to send SMS
@pragma('vm:entry-point')
Future<void> sendTestSms() async {
  final prefs = await SharedPreferences.getInstance();
  SmsSender sender = SmsSender();

  var status = await Permission.sms.status;
  if (!status.isGranted) {
    status = await Permission.sms.request();
    if (!status.isGranted) {
      print("❌ SMS permission denied during send.");
      await prefs.setBool('sms_task_completed', true);
      await prefs.setString('sms_task_failure_reason', 'Service failed due to Permission denied');
      return;
    }
  }

  final attendanceMap = await loadAttendanceDataFromPrefs();
  final selectedOption = prefs.getString('selected_option') ?? 'Send SMS to All';

  for (var entry in attendanceMap.entries) {
    String studentName = entry.key;
    Map<String, String> studentData = entry.value;
    String phoneNumber = studentData['guardian_contact'] ?? '';
    if (phoneNumber.isEmpty) {
      print("⚠️ Missing phone number for $studentName, skipping SMS.");
      continue;
    }

    String attendanceStatus = studentData['status'] ?? 'present';
    bool shouldSend = false;

    if (selectedOption == 'Send SMS to All') {
      shouldSend = true;
    } else if (selectedOption == 'Only Absents' && attendanceStatus == 'absent') {
      shouldSend = true;
    } else if (selectedOption == 'Absents + Leave' &&
        (attendanceStatus == 'absent' || attendanceStatus == 'leave')) {
      shouldSend = true;
    }

    if (!shouldSend) continue;

    String message = getSmsMessage(
      name: studentName,
      status: attendanceStatus,
    );

    print('The phone no is $phoneNumber');
    SmsMessage sms = SmsMessage(phoneNumber, message);
    sms.onStateChanged.listen((state) {
      if (state == SmsMessageState.Sent) {
        print("✅ SMS sent to $phoneNumber.");
      } else if (state == SmsMessageState.Fail) {
        print("❌ SMS failed to send to $phoneNumber.");
      }
    });

    sender.sendSms(sms);
    print("📤 Sending SMS to $phoneNumber. Waiting 10 seconds...");
    await Future.delayed(const Duration(seconds: 10));
  }

  await clearAttendanceDataFromPrefs();
  await prefs.setBool('sms_task_completed', true);
}
//////////////////////////////Attendance Functionality//////////////////////////////////////
/// Save Attendance Map
Future<void> saveAttendanceDataToPrefs({
  required Map<String, Map<String, String>> attendanceMap,
  required String selectedOption,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final attendanceJson = attendanceMap.map(
        (studentName, dataMap) => MapEntry(studentName, jsonEncode(dataMap)),
  );

  await prefs.setStringList('attendance_keys', attendanceJson.keys.toList());
  await prefs.setStringList('attendance_values', attendanceJson.values.toList());
  await prefs.setString('selected_option', selectedOption);

  print("Attendance data saved to SharedPreferences.");
}

/// Load Attendance Map
Future<Map<String, Map<String, String>>> loadAttendanceDataFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final keys = prefs.getStringList('attendance_keys') ?? [];
  final values = prefs.getStringList('attendance_values') ?? [];

  Map<String, Map<String, String>> map = {};
  for (int i = 0; i < keys.length; i++) {
    map[keys[i]] = Map<String, String>.from(
      jsonDecode(values[i]) as Map<String, dynamic>,
    );
  }
  return map;
}

/// Clear Attendance
Future<void> clearAttendanceDataFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('attendance_keys');
  await prefs.remove('attendance_values');
  await prefs.remove('selected_option');
  print("🧹 Cleared attendance data from SharedPreferences.");
}


/// Get SMS message based on status
String getSmsMessage({required String name, required String status}) {
  if (status == 'absent') {
    return "Dear Guardian, your child $name is marked Absent today. Please contact school for any queries.";
  } else if (status == 'half_day') {
    return "Dear Guardian, your child $name attended Half Day today. Please follow up if needed.";
  } else if (status == 'leave') {
    return "Dear Guardian, your child $name is marked as Leave today. Please follow up if needed.";
  } else {
    return "Dear Guardian, your child $name is marked Present today.";
  }
}
//////////////////////////////Compose Message Functionality//////////////////////////////////////
@pragma('vm:entry-point')
Future<void> scheduleContactSmsTask({
  required Map<String, Map<String, String>> contactMap,
  required String message,
  required String selectedOption,
}) async {
  await saveContactDataToPrefs(contactMap: contactMap, message: message,selectedOption: selectedOption);

  bool scheduled = await BackgroundFetch.scheduleTask(
    TaskConfig(
      taskId: "compose_sms_task",
      delay: 1000,
      periodic: false,
      enableHeadless: true,
      stopOnTerminate: true,
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresStorageNotLow: false,
      requiresDeviceIdle: false,
      requiredNetworkType: NetworkType.NONE,
      startOnBoot: true,
      forceAlarmManager: true,
    ),
  );

  print("📅 Contact SMS task scheduled: $scheduled");
}
/// Function to send composed SMS
@pragma('vm:entry-point')
@pragma('vm:entry-point')
Future<void> sendContactSms() async {
  final prefs = await SharedPreferences.getInstance();
  SmsSender sender = SmsSender();

  var status = await Permission.sms.status;
  if (!status.isGranted) {
    status = await Permission.sms.request();
    if (!status.isGranted) {
      print("❌ SMS permission denied during sendContactSms.");
      await prefs.setBool('contact_sms_task_completed', true);
      await prefs.setString('contact_sms_task_failure_reason', 'Service failed due to Permission denied');
      return;
    }
  }

  final contactMap = await loadContactDataFromPrefs();
  final messageTemplate = prefs.getString('contact_message') ?? '';
  final option = prefs.getString('selected_option') ?? '';

  if (contactMap.isEmpty) {
    print("⚠️ No contacts found in SharedPreferences.");
    return;
  }
  if (messageTemplate.isEmpty) {
    print("⚠️ No message template found in SharedPreferences.");
    return;
  }

  for (var entry in contactMap.entries) {
    String name = entry.key;
    Map<String, String> dataMap = entry.value;
    String phoneNumber = dataMap['phone'] ?? '';
    if (phoneNumber.isEmpty) {
      print("⚠️ Missing phone number for $name, skipping SMS.");
      continue;
    }

    String personalizedMessage = getGeneralSmsMessage(name: name, selectedOption: option, customMessage: messageTemplate);

    SmsMessage sms = SmsMessage(phoneNumber, personalizedMessage);
    sms.onStateChanged.listen((state) {
      if (state == SmsMessageState.Sent) {
        print("✅ SMS sent to $phoneNumber.");
      } else if (state == SmsMessageState.Fail) {
        print("❌ SMS failed to send to $phoneNumber.");
      }
    });

    sender.sendSms(sms);
    print("📤 Sending SMS to $phoneNumber. Waiting 10 seconds...");
    await Future.delayed(const Duration(seconds: 10));
  }

  await clearContactDataFromPrefs();
  await prefs.setBool('contact_sms_task_completed', true);
  print("✅ Completed sending all contact SMS.");
}





///Save Contact Map
Future<void> saveContactDataToPrefs({
  required Map<String, Map<String, String>> contactMap,
  required String message,
  required String selectedOption,
}) async {
  final prefs = await SharedPreferences.getInstance();

  final contactJson = contactMap.map(
        (name, dataMap) => MapEntry(name, jsonEncode(dataMap)),
  );
  await prefs.setStringList('contact_keys', contactJson.keys.toList());
  await prefs.setStringList('contact_values', contactJson.values.toList());
  await prefs.setString('contact_message', message);
  await prefs.setString('selected_option', selectedOption);
  print("Contact data and message saved to SharedPreferences.");
}

///Load Contact Map
Future<Map<String, Map<String, String>>> loadContactDataFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final keys = prefs.getStringList('contact_keys') ?? [];
  final values = prefs.getStringList('contact_values') ?? [];

  Map<String, Map<String, String>> contactMap = {};
  for (int i = 0; i < keys.length; i++) {
    contactMap[keys[i]] = Map<String, String>.from(
      jsonDecode(values[i]) as Map<String, dynamic>,
    );
  }

  return contactMap;
}

///Clear Contact Map
Future<void> clearContactDataFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('contact_keys');
  await prefs.remove('contact_values');
  await prefs.remove('contact_message');
  await prefs.remove('selected_option');
  print(" Cleared contact data and message from SharedPreferences.");
}

///Get Sms Based on selection
String getGeneralSmsMessage({
  required String name,
  required String selectedOption,
  required String customMessage,
}) {
  String greeting;

  if (selectedOption == 'Only Staff') {
    greeting = "Dear Staff $name,";
  } else if (selectedOption == 'Any Class') {
    greeting = "Dear Student $name,";
  } else if (selectedOption == 'All School') {
    greeting = "Dear $name,";
  } else {
    greeting = "Dear $name,";
  }
  return "$greeting $customMessage";
}

