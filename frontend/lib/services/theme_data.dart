import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

// Custom Theme: Custom colors and text 
final ThemeData customTheme = ThemeData(
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: HexColor('#FF7070'), // Red - main accent
    onPrimary: HexColor('#F8F9FA'), // Off-white background
    secondary: HexColor('#FFC2C2'), // Light red accent
    onSecondary: HexColor('#36454F'),  // Near Black Text
    surface: HexColor('#F8F9FA'), //Off white
    onSurface: HexColor('#808080'), // Neutral text (gray)
    error: HexColor('#E84957'), // Strong red for errors
    onError: Colors.white,
    tertiary: HexColor('#DBD7D2'), // Beige for cards, subtle accents
    inversePrimary: HexColor('#4A90E2'), // Optional deep blue accent
    onInverseSurface: HexColor('#AEACA9')//light gray
  ),

textTheme: TextTheme( //Can be inherited by body and appBar
  bodyLarge: GoogleFonts.merriweather(
    fontSize: 22,
    fontWeight: FontWeight.w700, // Bold
    letterSpacing: 1,
  ),
  bodyMedium: GoogleFonts.arimo(
    fontSize: 20,
    fontWeight: FontWeight.w400, // Regular
    height: 1.5,
  ),
),

bottomNavigationBarTheme: BottomNavigationBarThemeData(// BNB needs its own theming , both fonts and color (except background)
  selectedLabelStyle: GoogleFonts.arimo().copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    color: HexColor('#FF7070'),
    height: 1.2,
    textBaseline: TextBaseline.alphabetic,
  ),
  unselectedLabelStyle: GoogleFonts.arimo().copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: Colors.grey,
    height: 1.2,
    textBaseline: TextBaseline.alphabetic,
  ),
  selectedItemColor: HexColor('#FF7070'),
  unselectedItemColor: Colors.grey,
  backgroundColor: HexColor('#F2F3F4'),
  type: BottomNavigationBarType.fixed,
),


);


