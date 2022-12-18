import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../model/comment.dart';
import '../widget_utils/loading/loading_gesture_detector.dart';
import 'image_preview_widget.dart';

class CommentImageWidget extends StatefulWidget {
  const CommentImageWidget({Key? key, required this.comment}) : super(key: key);

  final Comment comment;

  @override
  State<CommentImageWidget> createState() => _CommentImageWidgetState();
}

class _CommentImageWidgetState extends State<CommentImageWidget> {

  Future<Uint8List> convertImagePathToUint8List(String imagePath) async {
    return (await NetworkAssetBundle(Uri.parse(imagePath)).load(imagePath)).buffer.asUint8List();
  }
  void showPreviewImage(Uint8List image) {
    showDialog(context: context, builder: (context) {
      return ImagePreviewWidget(image: image);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingGestureDetector(
      onTap: () async {
        Uint8List image =  await convertImagePathToUint8List(widget.comment.imagePath!);
        if (!mounted) return;
        return showPreviewImage(image);
      },
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.50,
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.network(
              widget.comment.imagePath!,
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: MediaQuery.of(context).size.width * 0.50,
                  height: MediaQuery.of(context).size.width * 0.40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Center(
                    child: SizedBox(
                      height: 20.0,
                      width: 20.0,
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                        valueColor: const AlwaysStoppedAnimation(Colors.amber),
                      ),
                    ),
                  ),
                );
              },
              errorBuilder: (BuildContext context, Object object, StackTrace? stackTrace) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.50,
                  height: MediaQuery.of(context).size.width * 0.40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline),
                        Text('画像の取得に失敗しました', style: Theme.of(context).textTheme.bodySmall)
                      ],
                    ),
                  ),
                );
              },
            )
        ),
      )
    );
  }
}
