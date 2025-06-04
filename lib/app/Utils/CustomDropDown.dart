// import 'package:attendease/app/AppColors/appColor.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../modules/home/controllers/home_controller.dart';
//
// class SmsRecipientDropdown extends StatelessWidget {
//   final HomeController controller = Get.find<HomeController>();
//   final LayerLink _layerLink = LayerLink();
//   OverlayEntry? _overlayEntry;
//
//   static const Color backgroundColor = AppColors.backgroundColor;
//   static Color textColor = Colors.white;
//
//   final List<String> options = [
//     "Send SMS to All",
//     "Only Absents",
//     "Absents + Leave",
//   ];
//
//   SmsRecipientDropdown({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return Obx(() {
//       return CompositedTransformTarget(
//         link: _layerLink,
//         child: InkWell(
//           onTap: () {
//             if (controller.isDropdownOpen.value) {
//               _removeOverlay();
//             } else {
//               _showOverlay(context, screenWidth);
//             }
//             controller.isDropdownOpen.toggle();
//           },
//           child: Container(
//             width: screenWidth,
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//             decoration: BoxDecoration(
//               color: backgroundColor,
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Colors.white54),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Flexible(
//                   child: Text(
//                     controller.selectedOption.value,
//                     style: TextStyle(color: textColor, fontSize: 16),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 Icon(
//                   controller.isDropdownOpen.value
//                       ? Icons.keyboard_arrow_up
//                       : Icons.keyboard_arrow_down,
//                   color: textColor.withOpacity(0.7),
//                   size: 28,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }
//
//   void _showOverlay(BuildContext context, double screenWidth) {
//     final RenderBox renderBox = context.findRenderObject() as RenderBox;
//     final Offset dropdownOffset = renderBox.localToGlobal(Offset.zero);
//     final double dropdownHeight = renderBox.size.height;
//
//     _overlayEntry = OverlayEntry(
//       builder: (context) => GestureDetector(
//         behavior: HitTestBehavior.translucent,
//         onTap: () {
//           _removeOverlay();
//           controller.isDropdownOpen.value = false;
//         },
//         child: Stack(
//           children: [
//             Positioned(
//               left: 0,
//               top: dropdownOffset.dy + dropdownHeight,
//               width: screenWidth,
//               child: CompositedTransformFollower(
//                 link: _layerLink,
//                 showWhenUnlinked: false,
//                 offset: Offset(0, dropdownHeight + 4),
//                 child: Material(
//                   color: backgroundColor,
//                   elevation: 5,
//                   borderRadius: BorderRadius.circular(8),
//                   child: ListView.separated(
//                     padding: EdgeInsets.zero,
//                     shrinkWrap: true,
//                     itemCount: options.length,
//                     separatorBuilder: (_, __) => Divider(color: Colors.white24, height: 1),
//                     itemBuilder: (context, index) {
//                       final option = options[index];
//                       final bool isSelected = controller.selectedOption.value == option;
//
//                       return InkWell(
//                         onTap: () {
//                           controller.selectedOption.value = option;
//                           _removeOverlay();
//                           controller.isDropdownOpen.value = false;
//                         },
//                         child: Container(
//                           width: screenWidth,
//                           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//                           color: isSelected ? Colors.blueAccent.withOpacity(0.3) : Colors.transparent,
//                           child: Text(
//                             option,
//                             style: TextStyle(
//                               color: textColor,
//                               fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//
//     Overlay.of(context)!.insert(_overlayEntry!);
//   }
//
//   void _removeOverlay() {
//     _overlayEntry?.remove();
//     _overlayEntry = null;
//     controller.isDropdownOpen.value = false;
//   }
// }
// import 'package:attendease/app/AppColors/appColor.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../modules/home/controllers/home_controller.dart';
//
// class SmsRecipientDropdown extends StatelessWidget {
//   final HomeController controller = Get.find<HomeController>();
//   final LayerLink _layerLink = LayerLink();
//   OverlayEntry? _overlayEntry;
//
//   static const Color backgroundColor = AppColors.backgroundColor;
//   static Color textColor = Colors.white;
//
//   final List<String> options = [
//     "Send SMS to All",
//     "Only Absents",
//     "Absents + Leave",
//   ];
//
//   SmsRecipientDropdown({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return Obx(() {
//       return CompositedTransformTarget(
//         link: _layerLink,
//         child: InkWell(
//           onTap: () {
//             if (controller.isDropdownOpen.value) {
//               _removeOverlay();
//             } else {
//               _showOverlay(context, screenWidth);
//             }
//             controller.isDropdownOpen.toggle();
//           },
//           child: Container(
//             width: screenWidth, // full width when closed
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             decoration: BoxDecoration(
//               color: backgroundColor,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: Colors.white),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Flexible(
//                   child: Text(
//                     controller.selectedOption.value,
//                     style: GoogleFonts.poppins(
//                       color: textColor,
//                       fontSize: screenWidth * 0.037,
//                       fontWeight: FontWeight.normal,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 Icon(
//                   controller.isDropdownOpen.value
//                       ? Icons.keyboard_arrow_up
//                       : Icons.keyboard_arrow_down,
//                   color: textColor.withOpacity(0.7),
//                   size: 28,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }
//
//   void _showOverlay(BuildContext context, double screenWidth) {
//     final RenderBox renderBox = context.findRenderObject() as RenderBox;
//     final Offset dropdownOffset = renderBox.localToGlobal(Offset.zero);
//     final double dropdownHeight = renderBox.size.height;
//
//     _overlayEntry = OverlayEntry(
//       builder: (context) => GestureDetector(
//         behavior: HitTestBehavior.translucent,
//         onTap: () {
//           _removeOverlay();
//           controller.isDropdownOpen.value = false;
//         },
//         child: Stack(
//           children: [
//             Positioned(
//               left: 0,
//               top: dropdownOffset.dy + dropdownHeight,
//               width: screenWidth,
//               child: CompositedTransformFollower(
//                 link: _layerLink,
//                 showWhenUnlinked: false,
//                 offset: Offset(0, dropdownHeight + 4),
//                 child: Material(
//                   color: backgroundColor,
//                   elevation: 5,
//                   borderRadius: BorderRadius.circular(16),
//                   child: ListView.separated(
//                     padding: EdgeInsets.zero,
//                     shrinkWrap: true,
//                     itemCount: options.length,
//                     separatorBuilder: (_, __) => SizedBox(height: 4),
//                     itemBuilder: (context, index) {
//                       final option = options[index];
//                       // No bold for selected, just highlight bg color:
//                       final bool isSelected = controller.selectedOption.value == option;
//
//                       return InkWell(
//                         onTap: () {
//                           controller.selectedOption.value = option;
//                           _removeOverlay();
//                           controller.isDropdownOpen.value = false;
//                         },
//                         child: Container(
//                           //width: screenWidth,
//                           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//                           color: isSelected ? Colors.blueAccent.withOpacity(0.3) : Colors.transparent,
//                           child: Text(
//                             option,
//                             style: GoogleFonts.poppins(
//                               color: textColor,
//                               fontWeight: FontWeight.normal, // No bold here
//                               fontSize: screenWidth * 0.037,
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//
//     Overlay.of(context)!.insert(_overlayEntry!);
//   }
//
//   void _removeOverlay() {
//     _overlayEntry?.remove();
//     _overlayEntry = null;
//     controller.isDropdownOpen.value = false;
//   }
// }
// import 'package:attendease/app/AppColors/appColor.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../modules/home/controllers/home_controller.dart';
//
// class SmsRecipientDropdown extends StatelessWidget {
//   final HomeController controller = Get.find<HomeController>();
//   final LayerLink _layerLink = LayerLink();
//   OverlayEntry? _overlayEntry;
//
//   static const Color backgroundColor = AppColors.backgroundColor;
//   static Color textColor = Colors.white;
//
//   final List<String> options = [
//     "Send SMS to All",
//     "Only Absents",
//     "Absents + Leave",
//   ];
//
//   SmsRecipientDropdown({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return Obx(() {
//       return CompositedTransformTarget(
//         link: _layerLink,
//         child: GestureDetector(
//           onTap: () {
//             if (controller.isDropdownOpen.value) {
//               _removeOverlay();
//             } else {
//               _showOverlay(context);
//             }
//             controller.isDropdownOpen.toggle();
//           },
//           child: Container(
//             width: screenWidth,
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
//             decoration: BoxDecoration(
//               color: backgroundColor,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: Colors.white),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Flexible(
//                   child: Text(
//                     controller.selectedOption.value,
//                     style: GoogleFonts.poppins(
//                       color: textColor,
//                       fontSize: screenWidth * 0.037,
//                       fontWeight: FontWeight.normal,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 Icon(
//                   controller.isDropdownOpen.value
//                       ? Icons.keyboard_arrow_up
//                       : Icons.keyboard_arrow_down,
//                   color: textColor.withOpacity(0.7),
//                   size: 28,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }
//
//   void _showOverlay(BuildContext context) {
//     final RenderBox renderBox = context.findRenderObject() as RenderBox;
//     final Offset dropdownOffset = renderBox.localToGlobal(Offset.zero);
//     final Size dropdownSize = renderBox.size;
//
//     _overlayEntry = OverlayEntry(
//       builder: (context) => GestureDetector(
//         behavior: HitTestBehavior.translucent,
//         onTap: () {
//           _removeOverlay();
//           controller.isDropdownOpen.value = false;
//         },
//         child: Stack(
//           children: [
//             Positioned(
//               left: dropdownOffset.dx,
//               top: dropdownOffset.dy + dropdownSize.height,
//               width: dropdownSize.width,
//               child: CompositedTransformFollower(
//                 link: _layerLink,
//                 showWhenUnlinked: false,
//                 offset: Offset(0, dropdownSize.height + 4),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: backgroundColor,
//                     border: Border.all(color: Colors.white),
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Material(
//                     color: backgroundColor,
//                     borderRadius: BorderRadius.circular(16),
//                     elevation: 5,
//                     child: ListView.separated(
//                       padding: EdgeInsets.zero,
//                       shrinkWrap: true,
//                       physics: const ClampingScrollPhysics(),
//                       itemCount: options.length,
//                       separatorBuilder: (_, __) => const SizedBox(height: 1),
//                       itemBuilder: (context, index) {
//                         final option = options[index];
//
//                         return InkWell(
//                           onTap: () {
//                             controller.selectedOption.value = option;
//                             _removeOverlay();
//                             controller.isDropdownOpen.value = false;
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                             color: Colors.transparent,
//                             child: Text(
//                               option,
//                               style: GoogleFonts.poppins(
//                                 color: textColor,
//                                 fontWeight: FontWeight.normal,
//                                 fontSize: dropdownSize.width * 0.039,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//
//     Overlay.of(context)!.insert(_overlayEntry!);
//   }
//
//   void _removeOverlay() {
//     _overlayEntry?.remove();
//     _overlayEntry = null;
//     controller.isDropdownOpen.value = false;
//   }
// }

import 'package:attendease/app/AppColors/appColor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../modules/home/controllers/home_controller.dart';

class SmsRecipientDropdown extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  static const Color backgroundColor = AppColors.backgroundColor;
  static Color textColor = Colors.white;

  final List<String> options = [
    "Send SMS to All",
    "Only Absents",
    "Absents + Leave",
  ];

  SmsRecipientDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Obx(() {
      return CompositedTransformTarget(
        link: _layerLink,
        child: GestureDetector(
          onTap: () {
            if (controller.isDropdownOpen.value) {
              _removeOverlay();
            } else {
              _showOverlay(context);
            }
            controller.isDropdownOpen.toggle();
          },
          child: Container(
            width: screenWidth,
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.011,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(screenWidth * 0.04),
              border: Border.all(color: Colors.white),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    controller.selectedOption.value,
                    style: GoogleFonts.poppins(
                      color: textColor,
                      fontSize: screenWidth * 0.037,
                      fontWeight: FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  controller.isDropdownOpen.value
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: textColor.withOpacity(0.7),
                  size: screenWidth * 0.07,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _showOverlay(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset dropdownOffset = renderBox.localToGlobal(Offset.zero);
    final Size dropdownSize = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _removeOverlay();
          controller.isDropdownOpen.value = false;
        },
        child: Stack(
          children: [
            Positioned(
              left: dropdownOffset.dx,
              top: dropdownOffset.dy + dropdownSize.height,
              width: dropdownSize.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, dropdownSize.height + screenHeight * 0.005),
                child: Container(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(screenWidth * 0.04),
                  ),
                  child: Material(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(screenWidth * 0.04),
                    elevation: 5,
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: options.length,
                      separatorBuilder: (_, __) => SizedBox(height: screenHeight * 0.0012),
                      itemBuilder: (context, index) {
                        final option = options[index];
                        return InkWell(
                          onTap: () {
                            controller.selectedOption.value = option;
                            _removeOverlay();
                            controller.isDropdownOpen.value = false;
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05,
                              vertical: screenHeight * 0.015,
                            ),
                            color: Colors.transparent,
                            child: Text(
                              option,
                              style: GoogleFonts.poppins(
                                color: textColor,
                                fontWeight: FontWeight.normal,
                                fontSize: screenWidth * 0.037,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context)!.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    controller.isDropdownOpen.value = false;
  }
}
