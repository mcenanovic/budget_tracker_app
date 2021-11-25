import 'package:flutter/material.dart';

abstract class Styles {
  static const Color kPrimaryColor = Color(0xFF8F659A);
  static const Color kSecondaryColor = Color(0xFFEF8767);
  static const Color kLightGreyColor = Color(0xFFF7F4F7);
  static const Color kLightColor = Color(0xFFFFFFFF);
  static const Color kDarkColor = Color(0xFF120216);
  static const Color kDarkPrimaryColor = Color(0xFF42224A);
  static const Color kDarkThemeColor = Color(0xFF1A0122);

  static const TextStyle kLoginFormTextStyle =
      TextStyle(color: Styles.kSecondaryColor);

  static InputDecoration kLoginFormInputDecoration = InputDecoration(
    contentPadding: const EdgeInsets.symmetric(
      vertical: 20,
      horizontal: 10,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: kLightColor,
        width: 0.5,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: kLightColor,
        width: 0.5,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: kSecondaryColor,
        width: 1,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: kSecondaryColor,
        width: 1,
      ),
    ),
    hintStyle: const TextStyle(color: kLightColor),
    errorStyle: const TextStyle(color: Colors.red),
  );
}
