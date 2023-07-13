import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData light = ThemeData(useMaterial3: true).copyWith(
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff1c211e)),
  brightness: Brightness.light,
  textTheme: GoogleFonts.rubikTextTheme(),
);

ThemeData dark = ThemeData(useMaterial3: true).copyWith(
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff1c211e)),
  brightness: Brightness.dark,
  textTheme: GoogleFonts.rubikTextTheme().apply(
    bodyColor: const Color(0xFFd1d1d1),
    displayColor: const Color(0xFF000000),
    decorationColor: const Color(0xFFd1d1d1),
  ),
);
