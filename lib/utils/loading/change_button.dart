import 'package:rounded_loading_button/rounded_loading_button.dart';

class ChangeButton {
  static Future<void> showErrorFor4Seconds(RoundedLoadingButtonController btnController) async {
    btnController.error();
    await Future.delayed(const Duration(seconds: 4));
    btnController.reset();
  }
  static Future<void> showSuccessFor1Seconds(RoundedLoadingButtonController btnController) async {
    btnController.success();
    await Future.delayed(const Duration(seconds: 1));
  }
}