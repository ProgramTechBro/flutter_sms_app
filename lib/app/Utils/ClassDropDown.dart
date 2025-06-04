import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ClassDropdown extends StatelessWidget {
  final RxString selectedOption;
  final RxBool isDropdownOpen;
  final List<String> options;
  final Color backgroundColor;
  final Color textColor;
  final double? width;
  final double? height;

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  ClassDropdown({
    Key? key,
    required this.selectedOption,
    required this.isDropdownOpen,
    required this.options,
    this.backgroundColor = const Color(0xFF161b1d),
    this.textColor = Colors.white,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = width ?? MediaQuery.of(context).size.width;
    final screenHeight = height ?? MediaQuery.of(context).size.height;

    return Obx(() {
      return CompositedTransformTarget(
        link: _layerLink,
        child: GestureDetector(
          onTap: () {
            if (isDropdownOpen.value) {
              _removeOverlay();
            } else {
              _showOverlay(context);
            }
            isDropdownOpen.toggle();
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
                    selectedOption.value,
                    style: GoogleFonts.poppins(
                      color: textColor,
                      fontSize: screenWidth * 0.037,
                      fontWeight: FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  isDropdownOpen.value
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
    final screenWidth = width ?? MediaQuery.of(context).size.width;
    final screenHeight = height ?? MediaQuery.of(context).size.height;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset dropdownOffset = renderBox.localToGlobal(Offset.zero);
    final Size dropdownSize = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _removeOverlay();
          isDropdownOpen.value = false;
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
                    child: SizedBox(
                      height: screenHeight * 0.3, // fixed height: 30% of screen
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: options.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: screenHeight * 0.0012),
                        itemBuilder: (context, index) {
                          final option = options[index];
                          return InkWell(
                            onTap: () {
                              selectedOption.value = option;
                              _removeOverlay();
                              isDropdownOpen.value = false;
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
    isDropdownOpen.value = false;
  }
}
