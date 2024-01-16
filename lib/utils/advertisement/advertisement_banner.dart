import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdvertisementBanner {
  static String get bannerAdUnitId {
    return Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/6300978111'
        : 'ca-app-pub-3940256099942544/2934735716';
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
        adUnitId: bannerAdUnitId,
        listener: listener,
        request: const AdRequest()
    );
  }
}