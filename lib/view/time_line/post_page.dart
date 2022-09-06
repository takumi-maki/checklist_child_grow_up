import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_sns_app/utils/authentication.dart';
import 'package:demo_sns_app/utils/firestore/posts.dart';
import 'package:flutter/material.dart';

import '../../model/post.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle:true,
        title: const Text('新規投稿', style: TextStyle(color: Colors.black54)),
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.black54),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: contentController,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (contentController.text.isNotEmpty) {
                  Post newPost = Post(
                    id: '',
                    content: contentController.text,
                    postAccountId: Authentication.myAccount!.id,
                    createdTime: Timestamp.now(),
                  );
                  var resultAddPost = await PostFirestore.addPost(newPost);
                  if(resultAddPost) {
                    Navigator.pop(context);
                  }
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith((states) => Colors.grey),
              ),
              child: const Text('投稿'),
            ),
          ],
        ),
      ),
    );
  }
}
