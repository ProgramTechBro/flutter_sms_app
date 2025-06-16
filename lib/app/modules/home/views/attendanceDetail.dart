// import 'package:attendease/app/AppColors/appColor.dart';
// import 'package:attendease/app/Utils/ClassDropDown.dart';
// import 'package:attendease/app/Utils/CustomMultilineTextFiled.dart';
// import 'package:attendease/app/Utils/CustomTextField.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../../AppColors/AppConstants.dart';
// import '../../../Utils/BackButton.dart';
// import '../../../Utils/CustomDailog.dart';
// import '../../../Utils/CustomDropDown.dart';
// import '../controllers/home_controller.dart';
//
// class AttendanceDetail extends StatefulWidget {
//   const AttendanceDetail({super.key});
//
//   @override
//   State<AttendanceDetail> createState() => _AttendanceDetailState();
// }
//
// class _AttendanceDetailState extends State<AttendanceDetail> {
//   final HomeController controller = Get.put(HomeController());
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//         controller.fetchClasses();
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final double horizontalPadding = screenWidth * 0.05;
//     final double verticalPadding = screenHeight * 0.025;
//
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       body: Obx((){
//         return Stack(
//           children: [
//             SingleChildScrollView(
//               padding: EdgeInsets.symmetric(
//                 vertical: verticalPadding,
//                 horizontal: horizontalPadding,
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: screenHeight * 0.015),
//                   Center(
//                     child: SvgPicture.asset(
//                       'assets/images/logo.svg',
//                       height: screenHeight * 0.2,
//                       width: screenWidth * 0.5,
//                     ),
//                   ),
//                   SizedBox(height: screenHeight * 0.02),
//                   Text('Select Recipients :',style: GoogleFonts.montserrat(color: Colors.white,fontSize: screenWidth*0.037),),
//                   SizedBox(height: screenHeight * 0.01),
//                   ReusableDropdown(selectedOption: controller.composeSelectedOption,isDropdownOpen: controller.isComposeDropdownOpen,options: AppConstants.composeMessageOptions,),
//                   if (controller.composeSelectedOption.value == 'Any Class') ...[
//                     SizedBox(height: screenHeight * 0.02),
//                     ClassDropdown(
//                       selectedOption: controller.classSelectedOption,
//                       isDropdownOpen: controller.isClassDropdownOpen,
//                       options: controller.classOptions,
//                     ),
//                   ],
//                   // SizedBox(height: screenHeight * 0.02),
//                   // CustomTextField(hint: 'Subject', controller: controller.subjectController),
//                   SizedBox(height: screenHeight * 0.02),
//                   CustomMultilineTextField(hint: 'Message', controller: controller.messageController,),
//                   SizedBox(height: screenHeight * 0.04),
//                   Center(
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.primaryColor,
//                         padding: EdgeInsets.symmetric(
//                           horizontal: screenWidth * 0.17,
//                           vertical: screenHeight * 0.015,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                       onPressed: () async {
//                         controller.composeMessage();
//                         // Get.to(AttendanceDetail());
//                         // await scheduleSmsTask();
//                       },
//                       child: Text(
//                         'Send Message',
//                         style: GoogleFonts.montserrat(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: screenWidth * 0.042,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             if (controller.isComposeSmsSending.value)
//               smsSendingDialog(
//                 screenWidth: screenWidth,
//                 screenHeight: screenHeight,
//               ),
//           ],
//         );
//       }),
//     );
//   }
// }
import 'package:attendease/app/AppColors/appColor.dart';
import 'package:attendease/app/Utils/ClassDropDown.dart';
import 'package:attendease/app/Utils/CustomMultilineTextFiled.dart';
import 'package:attendease/app/Utils/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../AppColors/AppConstants.dart';
import '../../../Utils/BackButton.dart';
import '../../../Utils/CustomDailog.dart';
import '../../../Utils/CustomDropDown.dart';
import '../controllers/home_controller.dart';

class AttendanceDetail extends StatefulWidget {
  const AttendanceDetail({super.key});

  @override
  State<AttendanceDetail> createState() => _AttendanceDetailState();
}

class _AttendanceDetailState extends State<AttendanceDetail> {
  final HomeController controller = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchClasses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double horizontalPadding = screenWidth * 0.05;
    final double verticalPadding = screenHeight * 0.025;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() {
        return Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                vertical: verticalPadding,
                horizontal: horizontalPadding,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.015),
                      Center(
                        child: SvgPicture.asset(
                          'assets/images/logo.svg',
                          height: screenHeight * 0.2,
                          width: screenWidth * 0.5,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        'Select Recipients :',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: screenWidth * 0.037,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      ReusableDropdown(
                        selectedOption: controller.composeSelectedOption,
                        isDropdownOpen: controller.isComposeDropdownOpen,
                        options: AppConstants.composeMessageOptions,
                          controller: controller,
                          dropDownType: 'Compose'
                      ),
                      if (controller.composeSelectedOption.value == 'Any Class') ...[
                        SizedBox(height: screenHeight * 0.02),
                        ClassDropdown(
                          selectedOption: controller.classSelectedOption,
                          isDropdownOpen: controller.isClassDropdownOpen,
                          options: controller.classOptions,
                        ),
                      ],
                      SizedBox(height: screenHeight * 0.02),
                      CustomMultilineTextField(
                        hint: 'Message',
                        controller: controller.messageController,
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      Center(
                        child: ElevatedButton(
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
                          onPressed: () async {
                            controller.composeMessage();
                          },
                          child: Text(
                            'Send Message',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.042,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (controller.isComposeSmsSending.value)
              smsSendingDialog(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
          ],
        );
      }),
    );
  }
}
