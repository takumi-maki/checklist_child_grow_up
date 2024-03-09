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

  void loadAd(BuildContext context) {
    RewardedAd.load(
        adUnitId: isDebug ? devRewardedAdUnitId : prodRewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback:
            RewardedAdLoadCallback(onAdLoaded: (RewardedAd ad) {
          debugPrint('リワード広告 ロード完了');
          rewardedAd = ad;
        }, onAdFailedToLoad: (LoadAdError error) {
          debugPrint('リワード広告 ロードエラー: $error');
          rewardedAd = null;
          // ポップアップでエラーログを表示する
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('リワード広告の読み込みエラー'),
              content: Text('広告の読み込み中にエラーが発生しました。エラーコード: $error'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('閉じる'),
                ),
              ],
            ),
          );
        }));
  }

  void showAd(BuildContext context) {
    if (rewardedAd == null) return;
    rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        debugPrint('$ad onAdDismissedFullScreenContent');
        ad.dispose();
        loadAd(context);
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        loadAd(context);
      },
    );
    rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem rewardedItem) {
      debugPrint('リワード広告視聴完了');
    });
    rewardedAd = null;
  }

  void dispose() {
    rewardedAd?.dispose();
    debugPrint('リワード広告 廃棄');
  }
}
