import 'package:flutter/material.dart';
import 'core/config/flavor_config.dart';
import 'main_common.dart';

void main() {
  FlavorConfig.initialize(
    FlavorConfig(
      flavor: AppFlavor.fr,
      appName: 'Nouvelles FR',
      countryQuery: 'france',
      primaryColor: const Color(0xFF0055A4), // French Blue
      secondaryColor: const Color(0xFFEF4135), // Bright Red
      fontFamily: 'Montserrat',
      androidAdIds: const AdUnitIds(
        banner: 'ca-app-pub-2321249943983804/7022403647',
        interstitial: 'ca-app-pub-2321249943983804/2173401641',
        rewarded: 'ca-app-pub-2321249943983804/5067313826',
      ),
      iosAdIds: const AdUnitIds(
        banner: 'ca-app-pub-3940256099942544/2934735716',
        interstitial: 'ca-app-pub-3940256099942544/4411468910',
        rewarded: 'ca-app-pub-3940256099942544/1712485313',
      ),
      labels: {
        'navHome': 'Accueil',
        'navTrending': 'Tendances',
        'navSaved': 'Enregistré',
        'navSettings': 'Paramètres',
        'headerHome': 'NOUVELLES-FR',
        'headerTrending': 'TENDANCES',
        'headerSaved': 'ENREGISTRÉ',
        'headerSettings': 'PARAMÈTRES',
      },
    ),
  );
  mainCommon();
}
