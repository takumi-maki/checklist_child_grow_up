import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdvertisement {
  RewardedAd? rewardedAd;

  static String get rewardedAdUnitId {
    return Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/5224354917'
        : 'ca-app-pub-3940256099942544/6978759866';
  }

  void loadRewardedAd() {
    RewardedAd.load(
        adUnitId: rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (RewardedAd ad) {
              debugPrint('リワード広告 ロード完了');
              rewardedAd = ad;
            },
            onAdFailedToLoad: (LoadAdError error) {
              debugPrint('リワード広告 ロードエラー: $error');
              rewardedAd = null;
            }
        )
    );
  }

  void showRewardedAd() {
    if(rewardedAd == null) return;
    rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        debugPrint('$ad onAdDismissedFullScreenContent');
        ad.dispose();
        loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        loadRewardedAd();
      },
    );
    rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardedItem) {
      debugPrint('リワード広告視聴完了');
    });
    rewardedAd = null;
  }
}