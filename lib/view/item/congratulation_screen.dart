import 'package:flutter/material.dart';

class CongratulationScreen extends StatefulWidget {
  const CongratulationScreen({Key? key}) : super(key: key);

  @override
  State<CongratulationScreen> createState() => _CongratulationScreenState();
}

class _CongratulationScreenState extends State<CongratulationScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
          constraints: const BoxConstraints.expand(width: 300, height: 300),
          child: Column(
            children: [
              Image.asset('assets/images/congratulations.png', width: 300),
              Image.asset('assets/images/hiyoko_like.png', width: 250)
            ],
          )
      ),
    );
  }
}
