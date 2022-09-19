import 'package:flutter/material.dart';

BuildContext? loadingDialogContext;

class Dialog {

}
Future<void> showLoadingDialog(BuildContext context,
    {int durationTime = 500}) async {
  if(loadingDialogContext != null) {
    return;
  }
  showDialog(context: context, builder: (context) {
    loadingDialogContext = context;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints.expand(width: 50, height: 50),
        child: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
        ),
      ),
    );
  });
  await Future.delayed(Duration(milliseconds: durationTime));
  return;
}

Future<void> hideLoadingDialog() async {
  final context = loadingDialogContext;
  if(context != null) {
    Navigator.of(context).pop();
    loadingDialogContext = null;
  }
}