import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBackButton extends StatelessWidget {
  final Color? iconColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  const CustomBackButton({
    super.key,
    this.iconColor,
    this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: padding ?? EdgeInsets.only(left: screenWidth * 0.04, top: screenHeight*0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: backgroundColor ?? Colors.white,
              ),
              child: Icon(
                Icons.arrow_back,
                size: 24,
                color: iconColor ?? Color(0xFF161b1d),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
