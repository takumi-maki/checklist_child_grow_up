import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class CongratulationScreen extends StatefulWidget {
  final String itemContent;
  const CongratulationScreen({Key? key, required this.itemContent}) : super(key: key);

  @override
  State<CongratulationScreen> createState() => _CongratulationScreenState();
}

class _CongratulationScreenState extends State<CongratulationScreen> {
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                  child: DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 30.0,
                        letterSpacing: 2.0,
                        color: Colors.black54,
                        shadows: [Shadow(offset: Offset(2.0, 2.0), blurRadius: 2.0, color: Colors.black26)]
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
          )
        ],
      ),
    );
  }
}
