import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdvertisementRewarded {
  final isDebug = false;
  RewardedAd? rewardedAd;

  static String get devRewardedAdUnitId {
    return Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/5224354917'
        : 'ca-app-pub-3940256099942544/6978759866';
  }
  static String get prodRewardedAdUnitId {
    return Platform.isAndroid
        ? 'ca-app-pub-3701968782958798/4890902391'
        : 'ca-app-pub-3701968782958798/1334800763';
  }

  void loadAd() {
    RewardedAd.load(
        adUnitId: isDebug ? devRewardedAdUnitId: prodRewardedAdUnitId,
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

  void showAd() {
    if(rewardedAd == null) return;
    rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        debugPrint('$ad onAdDismissedFullScreenContent');
        ad.dispose();
        loadAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        loadAd();
      },
    );
    rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardedItem) {
      debugPrint('リワード広告視聴完了');
    });
    rewardedAd = null;
  }
  void dispose() {
    rewardedAd?.dispose();
    debugPrint('リワード広告 廃棄');
  }
}