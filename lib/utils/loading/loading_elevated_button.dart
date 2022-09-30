import 'package:flutter/material.dart';

class LoadingElevatedButton extends StatefulWidget {
  final dynamic onPressed;
  final Widget? child;
  final ButtonStyle? buttonStyle;
  const LoadingElevatedButton({
    Key? key,
    required this.onPressed,
    this.child,
    this.buttonStyle
  }) : super(key: key);

  @override
  State<LoadingElevatedButton> createState() => _LoadingElevatedButtonState();

}
class _LoadingElevatedButtonState extends State<LoadingElevatedButton> {
  bool _waiting = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _waiting ? null : () async {
        setState(() {
          _waiting = true;
        });
        await widget.onPressed();
        setState(() {
          _waiting = false;
        });
      },
      style: widget.buttonStyle ?? ElevatedButton.styleFrom(primary: Theme.of(context).colorScheme.secondary),
      child: _waiting ? const Text('読み込み中...') : widget.child,
    );
  }
}
