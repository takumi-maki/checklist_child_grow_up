import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset('assets/images/hiyoko_memo.png', height: 300, width: 350),
        const Positioned(
            left: 74,
            top: 126,
            child: Text('モンテッソーリ教育', style: TextStyle(fontSize: 10, letterSpacing: 3.0, fontWeight: FontWeight.bold, color: Colors.black87))
        ),
        const Positioned(
            left:  78,
            top: 168,
            child: Text('0~3歳', style: TextStyle(fontSize: 28, letterSpacing: 3.0, fontWeight: FontWeight.bold, color: Colors.green))
        ),
        const Positioned(
            left:  178,
            top: 182,
            child: Text('までの', style: TextStyle(fontSize: 16, letterSpacing: 3.0, fontWeight: FontWeight.bold, color: Colors.black87))
        ),
        const Positioned(
            left: 94,
            top: 212,
            child: Text('成長のチェックリスト', style: TextStyle(fontSize: 16, letterSpacing: 3.0, fontWeight: FontWeight.bold, color: Colors.black87))
        ),
      ],
    );
  }

}
