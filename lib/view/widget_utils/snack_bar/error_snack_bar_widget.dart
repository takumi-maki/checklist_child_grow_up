import 'package:flutter/material.dart';

class ErrorSnackBar extends SnackBar {
  final String title;

  ErrorSnackBar(BuildContext context, {Key? key, required this.title})
      : super(
          key: key,
          content: Text(title),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
}
