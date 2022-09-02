import 'package:demo_sns_app/model/account.dart';
import 'package:demo_sns_app/view/time_line/post_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/post.dart';

class TimeLinePage extends StatefulWidget {
  const TimeLinePage({Key? key}) : super(key: key);

  @override
  State<TimeLinePage> createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  Account myAccount = Account(
    id: '1',
    name: 'takumi',
    imagePath: 'https://thumb.photo-ac.com/f5/f5118d1dee2e1e2cec87f643e8010390_w.jpeg',
    userId: 'takumi_maki_1203',
    createdTime: DateTime.now()
  );
  List<Post> postList = [
    Post(
      id: '1',
      content: 'test_post_1',
      postAccountId: '1',
      createdTime: DateTime.now(),
    ),
    Post(
      id: '2',
      content: 'test_post_2',
      postAccountId: '1',
      createdTime: DateTime.now(),
    )
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('タイムライン', style: TextStyle(color: Colors.black54)),
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: postList.length,
        itemBuilder: (context, index) {
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
                    myAccount.imagePath
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
                                Text(myAccount.name, style: TextStyle(fontWeight: FontWeight.bold)),
                                Text('@${myAccount.userId}'),
                              ],
                            ),
                            Text(DateFormat('M/d/yy').format(postList[index].createdTime!))
                          ],
                        ),
                        Text(postList[index].content)
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
