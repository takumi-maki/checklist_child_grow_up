import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:url_launcher/url_launcher.dart';

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

  static Future contactFormLaunchUrl() async {
    final Uri contactFormUrl = Uri.parse('https://docs.google.com/forms/d/e/1FAIpQLSfEdKoJqizieOq1IHkWpi99DamiyPzxMikN2_dxoh0T4UPNsA/viewform');
    if(!await launchUrl(contactFormUrl)) {
      throw 'Could not launch $contactFormUrl';
    }
  }
  static Future privacyPolicyLaunchUrl() async {
    final Uri privacyPolicyUrl = Uri.parse('https://checklist-child-grow-up.web.app/privacy_policy.html');
    if(!await launchUrl(privacyPolicyUrl)) {
      throw 'Could not launch $privacyPolicyUrl';
    }
  }
  static Future termsOfServiceLaunchUrl() async {
    final Uri termsOfServiceUrl = Uri.parse('https://checklist-child-grow-up.web.app/terms_of_service.html');
    if(!await launchUrl(termsOfServiceUrl)) {
      throw 'Could not launch $termsOfServiceUrl';
    }
  }
}
