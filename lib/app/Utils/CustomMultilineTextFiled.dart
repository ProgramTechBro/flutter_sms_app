import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomMultilineTextField extends StatelessWidget {
  final String hint;
  final String? Function(String?)? validator;
  final TextEditingController controller;

  const CustomMultilineTextField({super.key, required this.hint,required this.controller,this.validator});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return TextFormField(
      minLines: 5,
      maxLines: null,
      validator: validator,
      style: GoogleFonts.montserrat(color: Colors.white),
      keyboardType: TextInputType.multiline,
      controller: controller,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.montserrat(color: Colors.white),
        contentPadding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.017,
          horizontal: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.white),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
