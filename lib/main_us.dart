import 'package:flutter/material.dart';
import 'core/config/flavor_config.dart';
import 'main_common.dart';

void main() {
  FlavorConfig.initialize(
    FlavorConfig(
      flavor: AppFlavor.us,
      appName: 'News US',
      countryQuery: 'unitedstates',
      primaryColor: const Color(0xFF1A237E), // Original Indigo
      secondaryColor: const Color(0xFFFF6F00), // Original Amber
      fontFamily: 'Poppins',
      androidAdIds: const AdUnitIds(
        banner: 'ca-app-pub-2321249943983804/2066739219',
        interstitial: 'ca-app-pub-2321249943983804/7200930256',
        rewarded: 'ca-app-pub-2321249943983804/1402798344',
      ),
      iosAdIds: const AdUnitIds(
        banner: 'ca-app-pub-3940256099942544/2934735716',
        interstitial: 'ca-app-pub-3940256099942544/4411468910',
        rewarded: 'ca-app-pub-3940256099942544/1712485313',
      ),
      labels: {
        'navHome': 'Home',
        'navTrending': 'Trending',
        'navSaved': 'Saved',
        'navSettings': 'Settings',
        'headerHome': 'US-NEWS',
        'headerTrending': 'TRENDING',
        'headerSaved': 'SAVED',
        'headerSettings': 'SETTINGS',
      },
    ),
  );
  mainCommon();
}
