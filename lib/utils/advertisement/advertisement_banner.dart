import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdvertisementBanner {
  final isDebug = false;

  static String get devBannerAdUnitId {
    return Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/6300978111'
        : 'ca-app-pub-3940256099942544/2934735716';
  }

  static String get prodBannerAdUnitId {
    return Platform.isAndroid
        ? 'ca-app-pub-3701968782958798/8427222108'
        : 'ca-app-pub-3701968782958798/6185607110';
  }

  BannerAd createBannerAd(context) {
    final BannerAdListener listener = BannerAdListener(
      onAdLoaded: (ad) => debugPrint('バナー広告 ロード完了'),
      onAdFailedToLoad: (ad, LoadAdError error) {
        ad.dispose();
        debugPrint('バナー広告 ロード失敗: $error');
        // ポップアップでエラーログを表示する
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('バナー広告の読み込みエラー'),
            content: Text('広告の読み込み中にエラーが発生しました。エラーコード: $error'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('閉じる'),
              ),
            ],
          ),
        );
      },
    );
    return BannerAd(
        size: AdSize.fullBanner,
        adUnitId: isDebug ? devBannerAdUnitId : prodBannerAdUnitId,
        listener: listener,
        request: const AdRequest());
  }
}
