import 'package:flutter/material.dart';
import 'core/config/flavor_config.dart';
import 'main_common.dart';

void main() {
  FlavorConfig.initialize(
    FlavorConfig(
      flavor: AppFlavor.de,
      appName: 'Nachrichten DE',
      countryQuery: 'germany',
      primaryColor: const Color(0xFF333333), // Anthracite
      secondaryColor: const Color(0xFFFFCC00), // Gold
      fontFamily: 'Roboto',
      androidAdIds: const AdUnitIds(
        banner: 'ca-app-pub-2321249943983804/1243463355',
        interstitial: 'ca-app-pub-2321249943983804/7617300012',
        rewarded: 'ca-app-pub-2321249943983804/4667703040',
      ),
      iosAdIds: const AdUnitIds(
        banner: 'ca-app-pub-3940256099942544/2934735716',
        interstitial: 'ca-app-pub-3940256099942544/4411468910',
        rewarded: 'ca-app-pub-3940256099942544/1712485313',
      ),
      labels: {
        'navHome': 'Aktuell',
        'navTrending': 'Trends',
        'navSaved': 'Gespeichert',
        'navSettings': 'Einstellungen',
        'headerHome': 'DE-NACHRICHTEN',
        'headerTrending': 'TRENDS',
        'headerSaved': 'GESPEICHERT',
        'headerSettings': 'EINSTELLUNGEN',
      },
    ),
  );
  mainCommon();
}
