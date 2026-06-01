import 'package:flutter/material.dart';

class MyColors {
  // Primary & Action Colors
  static const Color primaryBlue = Color(0xFF0056B3); // From screenauth.png
  static const Color actionBlue = Color(0xFF1A3D7C);  // Deep branding blue
  static const Color backgroundBlue = Color(0xFFE1E9FF);
  static const Color navHighlight = Color(0xFFD9E4FF);

  // Health & Status Indicators
  static const Color successGreen = Color(0xFF26D07C);
  static const Color mintBackground = Color(0xFF9FFFCB); // From screenarr.png
  static const Color trendGreen = Color(0xFF00A86B);
  
  // Risk & Alert Indicators
  static const Color alertRed = Color(0xFFD9534F);
  static const Color alertBackground = Color(0xFFFED7D7);
  static const Color warningYellow = Color(0xFFFFC107); // Added for "Medium" status
  static const Color warningBlue = Color(0xFF0047AB);
  
  // Risk Scale (Matching your logic)
  static const Color riskHigh = Color(0xFFD9534F);
  static const Color riskMedium = Color(0xFFFFC107);
  static const Color riskLow = Color(0xFF5CB85C);

  // Grayscale & UI Elements
  static const Color textPrimary = Color(0xFF1A202C);
  static const Color textSecondary = Color(0xFF4A5568);
  static const Color inputField = Color(0xFFF1F4F9); // Exact from screenauth fields
  static const Color borderGray = Color(0xFFE2E8F0);

  static const Color scaffoldBackground = Color(0xFFF8FAFC); 
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Chart Gradient (For the Circular Risk Gauge)
  static const List<Color> chartGradient = [
    Color(0xFFB2D1F0),
    Color(0xFF639CD9),
    Color(0xFF004282),
  ];
}
