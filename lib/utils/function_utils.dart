import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FunctionUtils {
  static Future<List<dynamic>> getCheckListItems() async {
    final dataJson = await rootBundle.loadString('assets/json/check_list_data.json');
    final List data  = json.decode(dataJson);
    return data;
  }

  static Future congratulationDialog(BuildContext context) async {
    showDialog(context: context, builder: (context) {
      return Center(
        child: ConstrainedBox(
            constraints: const BoxConstraints.expand(width: 300, height: 300),
            child: Column(
              children: [
                Image.asset('assets/images/congratulations.png', width: 300),
                Image.asset('assets/images/hiyoko_like.png', width: 250)
              ],
            )
        ),
      );
    });
    await Future.delayed(const Duration(milliseconds: 1500));
    Navigator.of(context).pop();
  }
}
