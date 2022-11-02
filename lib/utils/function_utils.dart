import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class FunctionUtils {
  static Future<List<dynamic>> getCheckListItems() async {
    final dataJson = await rootBundle.loadString('assets/json/check_list_data.json');
    final List data  = json.decode(dataJson);
    return data;
  }
  static Future<void> showErrorButtonFor4Seconds(RoundedLoadingButtonController btnController) async {
    btnController.error();
    await Future.delayed(const Duration(seconds: 4));
    btnController.reset();
  }
  static Future<void> showSuccessButtonFor1Seconds(RoundedLoadingButtonController btnController) async {
    btnController.success();
    await Future.delayed(const Duration(seconds: 1));
  }
}
