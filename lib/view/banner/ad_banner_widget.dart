import 'package:checklist_child_grow_up/utils/advertisement/advertisement_banner.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({Key? key}) : super(key: key);

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  final adBanner = AdvertisementBanner();
  late BannerAd bannerAd;

  @override
  void initState() {
    super.initState();
    bannerAd = adBanner.createBannerAd();
    bannerAd.load();
  }

  @override
  void dispose() {
    bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64.0,
      child: AdWidget(ad: bannerAd),
    );
  }
}
