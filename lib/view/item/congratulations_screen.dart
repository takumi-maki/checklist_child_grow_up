import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class CongratulationScreen extends StatefulWidget {
  final String itemContent;
  const CongratulationScreen({Key? key, required this.itemContent}) : super(key: key);

  @override
  State<CongratulationScreen> createState() => _CongratulationScreenState();
}

class _CongratulationScreenState extends State<CongratulationScreen> {
  final confettiController = ConfettiController(duration: const Duration(seconds: 1));
  @override
  void initState() {
    super.initState();
    confettiController.play();
  }
  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            constraints: const BoxConstraints.expand(width: 300, height: 390),
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
                              fontSize: 30.0,
                              letterSpacing: 1.4,
                              color: Colors.black54,
                          ),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              WavyAnimatedText(
                                  'Congratulations',
                                  speed: const Duration(milliseconds: 150)
                              ),
                            ],
                            isRepeatingAnimation: false,
                            onTap: () {
                              if(!mounted) return;
                              Navigator.pop(context);
                            },
                          )
                      ),
                    ),
                    Image.asset('assets/images/hiyoko_like.png', width: 250),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Text('『${widget.itemContent}』を達成しました'),
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
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    numberOfParticles: 30,
                    minimumSize: const Size(10, 10),
                    maximumSize: const Size(15, 15),
                  ),
                ),
              ]

            ),
          ),
        ],
      ),
    );
  }
}
