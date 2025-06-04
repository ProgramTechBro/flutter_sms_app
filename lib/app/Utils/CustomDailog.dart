import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../AppColors/appColor.dart';

Widget smsSendingDialog({
  required double screenWidth,
  required double screenHeight,
}) {
  return Positioned.fill(
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        color: Colors.black.withOpacity(0.3),
        child: Center(
          child: Container(
            width: screenWidth * 0.85,
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.025,
              horizontal: screenWidth * 0.05,
            ),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(screenWidth * 0.05),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: screenHeight * 0.015),
                Text(
                  'SMS Service Started',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.015),
                Text(
                  'Please do not close the app until SMS service is completed.',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                Lottie.asset(
                  height: screenHeight * 0.25,
                  width: screenWidth * 0.4,
                  'assets/images/loading.json',
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
