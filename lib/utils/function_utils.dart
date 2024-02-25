import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FunctionUtils {
  static Future<List<dynamic>> getCheckListItems() async {
    final dataJson =
        await rootBundle.loadString('assets/json/check_list_data.json');
    final List data = json.decode(dataJson);
    return data;
  }

  static Future<DateTime?> pickDateFromDatePicker(
      {required BuildContext context,
      required DateTime initialDate,
      DateTime? firstDate,
      DateTime? lastDate}) async {
    return await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? initialDate.add(const Duration(days: -1096)),
        lastDate: lastDate ?? initialDate.add(const Duration(days: 1096)),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                  primary: Colors.orange.shade300, onSurface: Colors.black87),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.secondary),
              ),
            ),
            child: child!,
          );
        });
  }
}
