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
        ? 'ca-app-pub-3701968782958798/2870274488'
        : 'ca-app-pub-3701968782958798/4120944262';
  }

  final BannerAdListener listener = BannerAdListener(
    onAdLoaded: (ad) => debugPrint('バナー広告 ロード完了'),
    onAdFailedToLoad: (ad, LoadAdError error) {
      ad.dispose();
      debugPrint('バナー広告 ロード失敗: $error');
    },
  );

  BannerAd createBannerAd() {
    return BannerAd(
        size: AdSize.fullBanner,
        adUnitId: isDebug ? devBannerAdUnitId : prodBannerAdUnitId,
        listener: listener,
        request: const AdRequest());
  }
}
