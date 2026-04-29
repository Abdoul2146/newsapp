import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adServiceProvider = Provider((ref) => AdService());

class AdService {
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  int _saveCounter = 0;

  // Test IDs
  static String get bannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  static String get interstitialAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';

  static String get rewardedAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';

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
              loadInterstitialAd(); // Load next one
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (err) {
          debugPrint('InterstitialAd failed to load: $err');
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
              loadRewardedAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              loadRewardedAd();
            },
          );
        },
        onAdFailedToLoad: (err) {
          debugPrint('RewardedAd failed to load: $err');
        },
      ),
    );
  }

  Future<bool> showRewardedAd() async {
    if (_rewardedAd == null) {
      loadRewardedAd();
      return false;
    }

    bool success = false;
    await _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        success = true;
      },
    );
    return success;
  }

  bool get isRewardedAdLoaded => _rewardedAd != null;
}
