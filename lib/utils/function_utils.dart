import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class FunctionUtils {
  static Future<List<dynamic>> getCheckListItems() async {
    final dataJson = await rootBundle.loadString('assets/json/check_list_data.json');
    final List data  = json.decode(dataJson);
    return data;
  }
  static Future contactFormLaunchUrl() async {
    final Uri contactFormUrl = Uri.parse('https://docs.google.com/forms/d/e/1FAIpQLSfEdKoJqizieOq1IHkWpi99DamiyPzxMikN2_dxoh0T4UPNsA/viewform');
    if(!await launchUrl(contactFormUrl)) {
      throw 'Could not launch $contactFormUrl';
    }
  }
}
