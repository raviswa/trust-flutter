// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────────────────────────────
// COLOURS  (matched pixel-for-pixel to the HTML design)
// ─────────────────────────────────────────────────────────────────────────────
class C {
  C._();

  // Brand
  static const navy        = Color(0xFF1B4F8A);
  static const navyDark    = Color(0xFF143D6E);
  static const navyBg      = Color(0xFFEFF6FF);
  static const navyBorder  = Color(0xFFDBEAFE);
  static const navyMuted   = Color(0xFF2563A8);

  // Feedback
  static const green       = Color(0xFF22C55E);
  static const greenBg     = Color(0xFFDCFCE7);
  static const greenDark   = Color(0xFF16A34A);
  static const red         = Color(0xFFEF4444);
  static const redBg       = Color(0xFFFEF2F2);

  // Surfaces
  static const bg          = Color(0xFFF7F8FA);
  static const white       = Color(0xFFFFFFFF);
  static const inputBg     = Color(0xFFF9FAFB);
  static const border      = Color(0xFFE5E7EB);
  static const cardShadow  = Color(0x0D000000);

  // Text
  static const text        = Color(0xFF111827);
  static const muted       = Color(0xFF6B7280);
  static const hint        = Color(0xFF9CA3AF);

  // Clinical intake header icon bg
  static const intakeBg    = Color(0xFFEEF2FF);

  // Welcome banner
  static const bannerBg    = Color(0xFFFFF7ED);
  static const bannerBorder= Color(0xFFFED7AA);
  static const bannerText  = Color(0xFF92400E);
  static const bannerLabel = Color(0xFFD97706);
}

// ─────────────────────────────────────────────────────────────────────────────
// TEXT STYLES
// ─────────────────────────────────────────────────────────────────────────────
class T {
  T._();

  static TextStyle h1 = GoogleFonts.inter(
      fontSize: 26, fontWeight: FontWeight.w800, color: C.text, height: 1.25);

  static TextStyle h2 = GoogleFonts.inter(
      fontSize: 22, fontWeight: FontWeight.w800, color: C.text, height: 1.3);

  static TextStyle h3 = GoogleFonts.inter(
      fontSize: 18, fontWeight: FontWeight.w700, color: C.text, height: 1.35);

  static TextStyle body = GoogleFonts.inter(
      fontSize: 15, fontWeight: FontWeight.w400, color: C.text, height: 1.5);

  static TextStyle bodySmall = GoogleFonts.inter(
      fontSize: 13, fontWeight: FontWeight.w400, color: C.muted, height: 1.5);

  static TextStyle label = GoogleFonts.inter(
      fontSize: 13, fontWeight: FontWeight.w600, color: C.text);

  static TextStyle btn = GoogleFonts.inter(
      fontSize: 16, fontWeight: FontWeight.w600, color: C.white);

  static TextStyle caption = GoogleFonts.inter(
      fontSize: 12, fontWeight: FontWeight.w500, color: C.muted);
}

// ─────────────────────────────────────────────────────────────────────────────
// MATERIAL THEME
// ─────────────────────────────────────────────────────────────────────────────
ThemeData buildTheme() => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
          seedColor: C.navy, brightness: Brightness.light),
      scaffoldBackgroundColor: C.white,
      textTheme: GoogleFonts.interTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: C.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
            fontSize: 17, fontWeight: FontWeight.w700, color: C.text),
        iconTheme: const IconThemeData(color: C.text),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: C.navy,
          foregroundColor: C.white,
          disabledBackgroundColor: C.navy.withOpacity(0.45),
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          elevation: 0,
          textStyle: T.btn,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: C.text,
          side: const BorderSide(color: C.border, width: 1.5),
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: C.inputBg,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 44, vertical: 15),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: C.border, width: 1.5)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: C.border, width: 1.5)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: C.navy, width: 1.5)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: C.red, width: 1.5)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: C.red, width: 1.5)),
        hintStyle:
            GoogleFonts.inter(fontSize: 15, color: C.hint),
        errorStyle:
            GoogleFonts.inter(fontSize: 12, color: C.red),
        prefixIconColor: C.navy,
      ),
    );
