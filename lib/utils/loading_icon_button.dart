import 'package:flutter/material.dart';

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
    return IconButton(
      onPressed: _sending ? null : () async {
        setState(() {
          _sending = true;
        });
        await widget.onPressed();
        setState(() {
          _sending = false;
        });
      },
      icon: widget.icon,
      iconSize: widget.iconSize,
      color: widget.color,
    );
  }
}
