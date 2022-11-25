import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImagePreviewWidget extends StatelessWidget {
  const ImagePreviewWidget({Key? key, required this.image}) : super(key: key);

  final Uint8List image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.80
          ),
          child: Center(
            child: InteractiveViewer(
              minScale: 0.1,
              maxScale: 5,
              child: Image.memory(image),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Material(
            color: Colors.transparent,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
                icon: const Icon(Icons.close),
                color: Colors.white
            ),
          ),
        )
      ],
    );
  }
}
