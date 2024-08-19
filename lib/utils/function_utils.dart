import 'dart:convert';
import 'dart:math' as math;

import 'package:age_calculator/age_calculator.dart';
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

  static int generateRandomInt(int maxInt) {
    var random = math.Random();
    return random.nextInt(maxInt);
  }

  static int? calculateAgeMonths(
      {required DateTime birthdate, DateTime? targetDate}) {
    final age = AgeCalculator.age(birthdate, today: targetDate);
    final ageMonths = age.years * 12 + age.months;
    if (ageMonths < 0) return null;
    return ageMonths;
  }
}
