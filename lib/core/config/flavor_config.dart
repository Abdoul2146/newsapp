import 'package:flutter/material.dart';

enum AppFlavor { us, uk, de, au, fr }

class AdUnitIds {
  final String banner;
  final String interstitial;
  final String rewarded;

  const AdUnitIds({
    required this.banner,
    required this.interstitial,
    required this.rewarded,
  });
}

class FlavorConfig {
  final AppFlavor flavor;
  final String appName;
  final String countryQuery;
  final Color primaryColor;
  final Color secondaryColor;
  final String fontFamily;
  final AdUnitIds androidAdIds;
  final AdUnitIds iosAdIds;
  final Map<String, String> labels;

  static FlavorConfig? _instance;

  FlavorConfig({
    required this.flavor,
    required this.appName,
    required this.countryQuery,
    required this.primaryColor,
    required this.secondaryColor,
    required this.fontFamily,
    required this.androidAdIds,
    required this.iosAdIds,
    required this.labels,
  });

  static void initialize(FlavorConfig config) {
    _instance = config;
  }

  static FlavorConfig get instance {
    if (_instance == null) {
      throw Exception('FlavorConfig not initialized. Call initialize() in main.');
    }
    return _instance!;
  }

  // Helper to check if it's US (for preserving legacy logic if needed)
  bool get isUS => flavor == AppFlavor.us;
}
