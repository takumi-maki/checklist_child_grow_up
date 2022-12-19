import 'package:flutter/material.dart';

import 'circular_progress_indicator_widget.dart';

class LoadingGestureDetector extends StatefulWidget {
  final dynamic onTap;
  final Widget child;
  const LoadingGestureDetector({
    Key? key,
    required this.onTap,
    required this.child
  }) : super(key: key);

  @override
  State<LoadingGestureDetector> createState() => _LoadingGestureDetectorState();
}

class _LoadingGestureDetectorState extends State<LoadingGestureDetector> {
  bool _sending = false;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: _sending ? null : () async {
        setState(() {
          _sending = true;
        });
        await widget.onTap();
        setState(() {
          _sending = false;
        });
      },
      child: _sending
        ? Stack(
          alignment: Alignment.center,
          children: [
            widget.child,
            const CircularProgressIndicatorWidget()
          ]
        )
        : widget.child
    );
  }
}
