import 'package:attendease/app/AppColors/AppConstants.dart';
import 'package:attendease/app/AppColors/appColor.dart';
import 'package:attendease/app/Utils/CustomDropDown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Utils/CustomDailog.dart';
import '../controllers/home_controller.dart';
import 'attendanceDetail.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double horizontalPadding = screenWidth * 0.05;
    final double verticalPadding = screenHeight * 0.025;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Obx((){
        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: verticalPadding,
                horizontal: horizontalPadding,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.015),
                  Center(
                    child: SvgPicture.asset(
                      'assets/images/logo.svg',
                      height: screenHeight * 0.21,
                      width: screenWidth * 0.05,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  // CustomTextField(
                  //   controller: controller.schoolIdController,
                  //   hint: 'School ID',
                  // ),
                  // SizedBox(height: screenHeight * 0.015),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Attendance Date :",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: screenWidth * 0.037,
                          ),
                        ),
                        Obx(
                              () => InkWell(
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              controller.pickDate(context: context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                controller.attendanceDate.value.isEmpty
                                    ? "Select Date"
                                    : controller.attendanceDate.value,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  ReusableDropdown(selectedOption: controller.selectedOption,isDropdownOpen: controller.isDropdownOpen,options: AppConstants.messageOptions, dropDownType: 'Sms',),
                  SizedBox(height: screenHeight * 0.05),
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
                        controller.fetchAttendance();
                        // Get.to(AttendanceDetail());
                        // await scheduleSmsTask();
                      },
                      child: Text(
                        'Fetch Attendance',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.042,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.015,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          Get.to(AttendanceDetail());
                        },
                        child: Text(
                          'Compose Message',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.042,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.015,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          controller.logout();
                        },
                        child: Text(
                          'Logout',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.042,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                ],
              ),
            ),
            if (controller.isSmsSending.value)
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
