import 'package:flutter/material.dart';

import 'circular_progress_indicator_widget.dart';

class LoadingIconButton extends StatefulWidget {
  final dynamic onPressed;
  final Icon icon;
  final double iconSize;
  final Color color;
  const LoadingIconButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.iconSize,
    required this.color
  }) : super(key: key);

  @override
  State<LoadingIconButton> createState() => _LoadingIconButtonState();
}

class _LoadingIconButtonState extends State<LoadingIconButton> {
  bool _sending = false;
  @override
  Widget build(BuildContext context) {
    return _sending
      ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: CircularProgressIndicatorWidget(height: 16.0, width: 16.0, color: widget.color)
      )
      : IconButton(
        onPressed: () async {
          setState(() {
            _sending = true;
          });
          await widget.onPressed();
          setState(() {
            _sending = false;
          });
        },
        icon: _sending ? const Icon(Icons.hourglass_top) : widget.icon,
        iconSize: widget.iconSize,
        color: widget.color,
      );
  }
}
