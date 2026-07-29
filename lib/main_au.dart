import 'package:flutter/material.dart';
import 'core/config/flavor_config.dart';
import 'main_common.dart';

void main() {
  FlavorConfig.initialize(
    FlavorConfig(
      flavor: AppFlavor.au,
      appName: 'News AU',
      countryQuery: 'australia',
      primaryColor: const Color(0xFF00843D), // Deep Green
      secondaryColor: const Color(0xFFFFCD00), // Gold
      fontFamily: 'Open Sans',
      androidAdIds: const AdUnitIds(
        banner: 'ca-app-pub-2321249943983804/1128068814',
        interstitial: 'ca-app-pub-2321249943983804/5454171101',
        rewarded: 'ca-app-pub-2321249943983804/8226390244',
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
        'headerHome': 'AU-NEWS',
        'headerTrending': 'TRENDING',
        'headerSaved': 'SAVED',
        'headerSettings': 'SETTINGS',
      },
    ),
  );
  mainCommon();
}
