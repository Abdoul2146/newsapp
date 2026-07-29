import 'package:flutter/material.dart';
import 'core/config/flavor_config.dart';
import 'main_common.dart';

void main() {
  FlavorConfig.initialize(
    FlavorConfig(
      flavor: AppFlavor.uk,
      appName: 'News UK',
      countryQuery: 'unitedkingdom',
      primaryColor: const Color(0xFF00247D), // Royal Blue
      secondaryColor: const Color(0xFFCF142B), // Crimson
      fontFamily: 'Merriweather',
      androidAdIds: const AdUnitIds(
        banner: 'ca-app-pub-2321249943983804/4061198388',
        interstitial: 'ca-app-pub-2321249943983804/1435035047',
        rewarded: 'ca-app-pub-2321249943983804/5900893666',
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
        'headerHome': 'UK-NEWS',
        'headerTrending': 'TRENDING',
        'headerSaved': 'SAVED',
        'headerSettings': 'SETTINGS',
      },
    ),
  );
  mainCommon();
}
