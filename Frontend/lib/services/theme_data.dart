import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

// Custom Theme: Custom colors and text
final ThemeData customTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme(
    primary: HexColor('#F2F3F4'), // Off - White
    onPrimary: Colors.black,
    brightness: Brightness.light,
    secondary: HexColor('#00416A'), // Dark Blue
    onSecondary: HexColor('#DBD7D2'), // Biege
    tertiary: HexColor('#87CEEB'), // Sky Blue
    onTertiary: Colors.black,
    surface: Color(0xE6000000), 
    onSurface: Color(0xFFEFEFEF),
    surfaceContainerHighest: Color(0xFF1A1A1A), 
    onSurfaceVariant: Color(0xFFB0B0B0),
    error: HexColor('#CA324C'), // Cardinal
    onError: Colors.white,
    inversePrimary: HexColor('#FF7F7F'), // Light Red
  ),

textTheme: TextTheme(
  bodyLarge: GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w700, // Bold
    letterSpacing: 1.2,
  ),
  bodyMedium: GoogleFonts.notoSerif(
    fontSize: 24,
    fontWeight: FontWeight.w500, // Regular
    height: 1.4,
  ),
    bodySmall: GoogleFonts.arimo(
    fontSize: 20,
    fontWeight: FontWeight.w400, // Regular
    height: 1.4,
  ),
),
bottomNavigationBarTheme: BottomNavigationBarThemeData(
  selectedLabelStyle: GoogleFonts.arimo().copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    color: HexColor('#87CEEB'),
    height: 1.2,
    textBaseline: TextBaseline.alphabetic,
  ),
  unselectedLabelStyle: GoogleFonts.arimo().copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.4,
    color: HexColor('#DBD7D2'),
    height: 1.2,
    textBaseline: TextBaseline.alphabetic,
  ),
  selectedItemColor: HexColor('#87CEEB'),
  unselectedItemColor: HexColor('#DBD7D2'),
  backgroundColor: HexColor('#DBD7D2'),
  type: BottomNavigationBarType.fixed,
),


);