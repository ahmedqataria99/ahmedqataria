import 'package:flutter/material.dart';

// Centralized color palette and text styles for a professional black/gold/white theme
class ThemeColors {
  static const Color gold = Color(0xFFB8860B);
  static const Color background = Colors.black;
  static const Color surface = Color(0xFF121212); // dark surface
  static const Color accent = gold;
  static const Color text = Colors.white;
}

class AppButtonStyles {
  static final ButtonStyle goldElevated = ElevatedButton.styleFrom(
    backgroundColor: ThemeColors.gold,
    foregroundColor: Colors.white,
    textStyle: const TextStyle(fontWeight: FontWeight.w600),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
  );
  static final ButtonStyle goldText = TextButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: ThemeColors.gold,
  );
}

class AppTextStyles {
  static const header = TextStyle(
    fontSize: 20,
    color: ThemeColors.gold,
    fontWeight: FontWeight.w700,
  );
  static const title = TextStyle(fontSize: 16, color: ThemeColors.text);
  static const subtitle = TextStyle(fontSize: 13, color: Colors.white70);
}
