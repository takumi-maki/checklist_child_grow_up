import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import 'congratulations_confetti_widget.dart';

class CongratulationScreen extends StatefulWidget {
  final String itemContent;
  const CongratulationScreen({Key? key, required this.itemContent}) : super(key: key);

  @override
  State<CongratulationScreen> createState() => _CongratulationScreenState();
}

class _CongratulationScreenState extends State<CongratulationScreen> {
  final rightConfettiController = ConfettiController();
  final leftConfettiController = ConfettiController();

  @override
  void initState() {
    super.initState();
    leftConfettiController.play();
    Future(() async {
      await Future.delayed(const Duration(milliseconds: 2100));
      rightConfettiController.play();
    });
  }

  @override
  void dispose() {
    leftConfettiController.dispose();
    rightConfettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints.expand(width: 300, height: 360),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50.0, bottom: 10.0),
                  child: DefaultTextStyle(
                      style: const TextStyle(
                          fontSize: 20.0,
                          letterSpacing: 5.0,
                          color: Colors.black87,
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          WavyAnimatedText(
                              'Congratulations',
                              speed: const Duration(milliseconds: 150)
                          ),
                        ],
                        isRepeatingAnimation: false,
                      )
                  ),
                ),
                Image.asset('assets/images/hiyoko_like.png', width: 250),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    '『 ${widget.itemContent} 』を達成しました',
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Material(
              color: Colors.transparent,
              child: IconButton(
                  iconSize: 16.0,
                  onPressed: () {
                    if (!mounted) return;
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close)
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: CongratulationsConfettiWidget(
                confettiController: rightConfettiController
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: CongratulationsConfettiWidget(
                confettiController: leftConfettiController
              ),
            ),
          ]
        ),
      ),
    );
  }
}
