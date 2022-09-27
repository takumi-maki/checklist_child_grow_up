import 'package:flutter/material.dart';

class LoadingElevatedButton extends StatefulWidget {
  final dynamic onPressed;
  final Widget? child;
  const LoadingElevatedButton({Key? key, required this.onPressed, this.child}) : super(key: key);

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
      style: ElevatedButton.styleFrom(primary: Colors.grey),
      child: _waiting ? Text('読み込み中...') : widget.child,
    );
  }
}
