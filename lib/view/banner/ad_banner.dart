import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdBanner extends StatefulWidget {
  const AdBanner({Key? key}) : super(key: key);

  static String get unitId {
    return Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';
  }

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  late BannerAd banner;

  @override
  void initState() {
    super.initState();
    banner = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: AdBanner.unitId,
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) => debugPrint('Banner was loaded'),
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            debugPrint('Banner Ad failed to load: $error');
          },
          onAdOpened: (Ad ad) => debugPrint('Banner Ad opened'),
          onAdClosed: (Ad ad) => debugPrint('Banner Ad closed'),
        ),
        request: const AdRequest()
    ) ..load();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64.0,
      child: AdWidget(ad: banner),
    );
  }
}
