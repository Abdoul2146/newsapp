import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/flavor_config.dart';

final adServiceProvider = Provider((ref) => AdService());

class AdService {
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  int _saveCounter = 0;

  static String get bannerAdUnitId => Platform.isAndroid
      ? FlavorConfig.instance.androidAdIds.banner
      : FlavorConfig.instance.iosAdIds.banner;

  static String get interstitialAdUnitId => Platform.isAndroid
      ? FlavorConfig.instance.androidAdIds.interstitial
      : FlavorConfig.instance.iosAdIds.interstitial;

  static String get rewardedAdUnitId => Platform.isAndroid
      ? FlavorConfig.instance.androidAdIds.rewarded
      : FlavorConfig.instance.iosAdIds.rewarded;

  // --- Interstitial Ad ---

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              loadInterstitialAd(); // Load next one
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitialAd = null;
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (err) {
          debugPrint('InterstitialAd failed to load: $err');
          _interstitialAd = null;
        },
      ),
    );
  }

  void incrementSaveCounterAndShowAd() {
    _saveCounter++;
    if (_saveCounter >= 3) {
      _saveCounter = 0;
      if (_interstitialAd != null) {
        _interstitialAd!.show();
      } else {
        loadInterstitialAd();
      }
    }
  }

  // --- Rewarded Ad ---

  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedAd = null;
              loadRewardedAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _rewardedAd = null;
              loadRewardedAd();
            },
          );
        },
        onAdFailedToLoad: (err) {
          debugPrint('RewardedAd failed to load: $err');
          _rewardedAd = null;
        },
      ),
    );
  }

  Future<bool> showRewardedAd() async {
    if (_rewardedAd == null) {
      loadRewardedAd();
      return false;
    }

    final completer = Completer<bool>();
    
    await _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        // User finished the ad!
        completer.complete(true);
      },
    );

    // This waits until the ad is either rewarded OR dismissed
    // We also need to handle the dismissal case if it happens before reward
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        if (!completer.isCompleted) completer.complete(false);
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        if (!completer.isCompleted) completer.complete(false);
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd();
      },
    );

    return completer.future;
  }

  bool get isRewardedAdLoaded => _rewardedAd != null;
}
