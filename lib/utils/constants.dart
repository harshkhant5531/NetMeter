import 'package:flutter/material.dart';

class AppConstants {
  // Colors
  static const Color primaryColor = Color(0xFF3EADCF);
  static const Color secondaryColor = Color(0xFFABE9CD);
  static const Color darkBackground = Color(0xFF1A1A2E);
  static const Color darkBackgroundSecondary = Color(0xFF16213E);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient darkGradient = LinearGradient(
    colors: [darkBackground, darkBackgroundSecondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Dimensions
  static const double defaultPadding = 20.0;
  static const double defaultRadius = 20.0;
  static const double cardRadius = 16.0;
  
  // Animation Durations
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 500);
  static const Duration slowAnimation = Duration(milliseconds: 1000);
  
  // Speed Test URLs
  static const String downloadUrl = 'https://speed.cloudflare.com/__down?bytes=25000000';
  static const String uploadUrl = 'https://speed.cloudflare.com/__up';
  static const String pingTarget = '8.8.8.8';
  
  // Speed Categories
  static const Map<String, double> speedCategories = {
    'Very Slow': 10.0,
    'Slow': 25.0,
    'Moderate': 50.0,
    'Fast': 100.0,
    'Very Fast': 500.0,
  };
  
  // Speed Colors
  static const Map<String, Color> speedColors = {
    'Very Slow': Colors.red,
    'Slow': Colors.orange,
    'Moderate': Colors.yellow,
    'Fast': Colors.green,
    'Very Fast': Colors.blue,
    'Ultra Fast': Colors.purple,
  };
} 