import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Warna tema gelap
const Color darkPrimary = Color(0xFF008CDB);
const Color darkSecondary = Color(0xFFFCBC38);
const Color darkTertiary = Color(0xFF54B948);
const Color darkNeutralBlack = Color(0xFF000814);
const Color darkNeutralGrey = Color(0xFF979FA3);
const Color darkNeutralSlateGrey = Color(0xFF0D1717);
const Color darkBackground = Color(0xFF0B1215);
const Color darkSurface = Color(0xFF0B1215);

final ThemeData darkTheme = ThemeData(
  colorScheme: const ColorScheme(
    primary: darkPrimary,
    primaryContainer: darkPrimary,
    secondary: darkSecondary,
    tertiary: darkTertiary,
    secondaryContainer: darkNeutralSlateGrey,
    surface: darkSurface,
    error: Colors.red,
    onPrimary: darkNeutralBlack,
    onSecondary: darkNeutralGrey,
    onSurface: Colors.white,
    onError: Colors.white,
    brightness: Brightness.dark,
  ),
  textTheme: TextTheme(
    headlineSmall: GoogleFonts.poppins(
      fontSize: 23,
      fontWeight: FontWeight.w400,
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: 19,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
    ),
    titleMedium: GoogleFonts.poppins(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
  ),
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(color: Colors.white),
    backgroundColor: darkBackground,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      textStyle: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      foregroundColor: Colors.white,
      backgroundColor: darkPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      minimumSize: const Size.fromHeight(50),
      padding: const EdgeInsets.symmetric(horizontal: 16),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      textStyle: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      foregroundColor: darkPrimary,
      minimumSize: const Size.fromHeight(50),
      padding: const EdgeInsets.symmetric(horizontal: 16),
    ),
  ),
  dropdownMenuTheme: const DropdownMenuThemeData(
    textStyle: TextStyle(
      color: darkNeutralBlack,
    ),
    menuStyle: MenuStyle(
      backgroundColor: WidgetStatePropertyAll(Colors.white),
    ),
  ),
  iconTheme: const IconThemeData(
    color: darkPrimary,
  ),
  inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(
          color: darkPrimary,
          width: 1,
        ),
      ),
      filled: true,
      fillColor: darkNeutralGrey.withOpacity(0.2),
      hintStyle: const TextStyle(color: darkNeutralGrey),
      suffixIconColor: Color(
        darkNeutralGrey.value,
      )),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: darkPrimary,
    foregroundColor: darkBackground,
  ),
  scaffoldBackgroundColor: darkBackground,
  cardColor: darkSurface,
  snackBarTheme: SnackBarThemeData(
    backgroundColor: darkSurface,
    contentTextStyle: GoogleFonts.poppins(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: darkPrimary,
    ),
  ),
);

// Warna tema terang
const Color lightPrimary = Color(0xFF008CDB);
const Color lightSecondary = Color(0xFFFCBC38);
const Color lightTertiary = Color(0xFF54B948);
const Color lightNeutralBlack = Color(0xFF000814);
const Color lightNeutralGrey = Color(0xFF979FA3);
const Color lightNeutralSlateGrey = Color(0xFF0D1717);
const Color lightBackground = Color(0xFFFFFFFF);
const Color lightSurface = Color(0xFFF5F5F5);

final ThemeData lightTheme = ThemeData(
  colorScheme: const ColorScheme(
    primary: lightPrimary,
    primaryContainer: lightPrimary,
    secondary: lightSecondary,
    tertiary: lightTertiary,
    secondaryContainer: lightNeutralSlateGrey,
    surface: lightSurface,
    error: Colors.red,
    onPrimary: lightNeutralBlack,
    onSecondary: lightNeutralGrey,
    onSurface: lightNeutralSlateGrey,
    onError: Colors.white,
    brightness: Brightness.light,
  ),
  textTheme: TextTheme(
    headlineSmall: GoogleFonts.poppins(
      fontSize: 23,
      fontWeight: FontWeight.w400,
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: 19,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
    ),
    titleMedium: GoogleFonts.poppins(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
  ),
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(color: Colors.white),
    backgroundColor: lightBackground,
    foregroundColor: lightNeutralBlack,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      textStyle: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      foregroundColor: Colors.white,
      backgroundColor: lightPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      minimumSize: const Size.fromHeight(50),
      padding: const EdgeInsets.symmetric(horizontal: 16),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      textStyle: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      foregroundColor: lightPrimary,
      minimumSize: const Size.fromHeight(50),
      padding: const EdgeInsets.symmetric(horizontal: 16),
    ),
  ),
  dropdownMenuTheme: const DropdownMenuThemeData(
    textStyle: TextStyle(
      color: lightNeutralBlack,
    ),
    menuStyle: MenuStyle(
      backgroundColor: WidgetStatePropertyAll(Colors.white),
    ),
  ),
  iconTheme: const IconThemeData(
    color: lightPrimary,
  ),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(
        color: lightPrimary,
        width: 1,
      ),
    ),
    filled: true,
    fillColor: lightNeutralGrey.withOpacity(0.2),
    hintStyle: const TextStyle(color: lightNeutralGrey),
    suffixIconColor: Color(
      lightNeutralGrey.value,
    ),
    helperStyle: GoogleFonts.poppins(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: lightNeutralGrey,
    ),
    helperMaxLines: 2,
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: lightPrimary,
    selectionColor: lightPrimary,
    selectionHandleColor: lightPrimary,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: lightPrimary,
    foregroundColor: lightBackground,
  ),
  scaffoldBackgroundColor: lightBackground,
  cardColor: lightSurface,
  snackBarTheme: SnackBarThemeData(
    backgroundColor: lightSurface,
    contentTextStyle: GoogleFonts.poppins(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: lightPrimary,
    ),
  ),
);
