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

Future<void> hideLoadingDialog(BuildContext context) async {
  final context = loadingDialogContext;
  if(context != null) {
    Navigator.of(context).pop();
    loadingDialogContext = null;
  }
}

Future<void> congratulationDialog(BuildContext context) async {
  if(loadingDialogContext != null) {
    return;
  }
  showDialog(context: context, builder: (context) {
    loadingDialogContext = context;
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
  await Future.delayed(const Duration(seconds: 2));
  return;
}