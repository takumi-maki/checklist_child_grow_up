import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_sns_app/model/account.dart';
import 'package:demo_sns_app/utils/firestore/posts.dart';
import 'package:demo_sns_app/utils/firestore/users.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/post.dart';

class TimeLinePage extends StatefulWidget {
  const TimeLinePage({Key? key}) : super(key: key);

  @override
  State<TimeLinePage> createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('タイムライン', style: TextStyle(color: Colors.black54)),
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 1,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // postsドキュメントのスナップショットを取得
        stream: PostFirestore.posts.orderBy('created_time', descending: true).snapshots(),
        builder: (context, postSnapshot) {
          if(postSnapshot.hasData) {
            // 投稿がどのユーザーの投稿した情報なのか
            List<String> postAccountIds = [];
            for (var doc in postSnapshot.data!.docs) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              if(!postAccountIds.contains(data['post_account_id'])) {
                postAccountIds.add(data['post_account_id']);
              }
            }
            return FutureBuilder<Map<String, Account>?>(
              future: UserFirestore.getPostUserMap(postAccountIds),
              builder: (context, userSnapshot) {
                if(userSnapshot.hasData && userSnapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                    itemCount:postSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> data = postSnapshot.data!.docs[index].data() as Map<String, dynamic>;
                      Post post = Post(
                        id: postSnapshot.data!.docs[index].id,
                        content: data['content'],
                        postAccountId: data['post_account_id'],
                        createdTime: data['created_time']
                      );
                      Account postAccount = userSnapshot.data![post.postAccountId]!;
                      return Container(
                        decoration: BoxDecoration(
                          border: index == 0 ? const Border(
                            top: BorderSide(color: Colors.grey, width: 0),
                            bottom: BorderSide(color: Colors.grey, width: 0),
                          ) : const Border(
                            bottom: BorderSide(color: Colors.grey, width: 0),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.grey,
                              foregroundImage: NetworkImage(
                                  postAccount.imagePath
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(postAccount.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                            Text('@${postAccount.userId}'),
                                          ],
                                        ),
                                        Text(DateFormat('M/d/yy').format(post.createdTime!.toDate()))
                                      ],
                                    ),
                                    Text(post.content)
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return Container();
                }
              }
            );
          } else {
            return Container();
          }
        }
      ),
    );
  }
}
