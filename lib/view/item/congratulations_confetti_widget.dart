import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class CongratulationsConfettiWidget extends StatelessWidget {
  const CongratulationsConfettiWidget({Key? key, required this.confettiController,}) : super(key: key);

  final ConfettiController confettiController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: ConfettiWidget(
        confettiController: confettiController,
        blastDirectionality: BlastDirectionality.explosive,
        numberOfParticles: 60,
        emissionFrequency: 0.00001,
        gravity: 0.05,
        minimumSize: const Size(10.0, 10.0),
        maximumSize: const Size(10.0, 10.0),
        colors: const [Colors.orange, Colors.amber, Colors.green, Colors.red]
      ),
    );
  }
}