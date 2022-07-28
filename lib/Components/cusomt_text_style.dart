import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextStyle {
  static TextStyle RubiktextStyle(Color color, double? fontSize,
      {FontWeight? fontWeight}) {
    return GoogleFonts.rubik(
        color: color,
        fontSize: fontSize,
        fontWeight: (fontWeight != null) ? fontWeight : FontWeight.normal);
  }
}
