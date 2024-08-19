import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';

class RateMyAppService {
  final RateMyApp _rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 7,
    minLaunches: 10,
    remindDays: 7,
    remindLaunches: 10,
  );

  void initRateMyApp(BuildContext context) {
    _rateMyApp.init().then((_) {
      if (_rateMyApp.shouldOpenDialog) {
        if (Platform.isAndroid) {
          _rateMyApp.showRateDialog(context,
              ignoreNativeDialog: Platform.isAndroid,
              title: '0~3歳までの成長のチェックリスト',
              message: 'はいかがですか? 左下のボタンから Google Play のページで評価していただけると大変嬉しいです。',
              rateButton: '評価する',
              laterButton: 'あとで通知',
              noButton: '今はしない');
        } else {
          _rateMyApp.showRateDialog(context);
        }
      }
    });
  }
}
