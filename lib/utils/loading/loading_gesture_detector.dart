import 'package:flutter/material.dart';

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
            SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.secondary),
              ),
            )
          ]
        )
        : widget.child
    );
  }
}
