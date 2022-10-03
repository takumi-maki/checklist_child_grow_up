import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoadingButton extends StatefulWidget {
  final RoundedLoadingButtonController btnController;
  final dynamic onPressed;
  final Widget child;
  final Color? color;
  const LoadingButton({
    Key? key,
    required this.btnController,
    required this.onPressed,
    required this.child,
    this.color
  }) : super(key: key);

  @override
  State<LoadingButton> createState() => _LoadingButtonState();

}
class _LoadingButtonState extends State<LoadingButton> {

  @override
  Widget build(BuildContext context) {
    return RoundedLoadingButton(
        controller: widget.btnController,
        onPressed: () async {
          await widget.onPressed();
        },
        borderRadius: 20,
        height: 36,
        width: 150,
        color: widget.color ?? Theme.of(context).colorScheme.secondary,
        successColor: Colors.lightGreen,
        child: widget.child
    );
  }
}
