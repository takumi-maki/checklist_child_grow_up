import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_sns_app/utils/authentication.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/account.dart';
import '../../model/post.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  Account myAccount = Authentication.myAccount!;
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(right: 15, left: 15, top: 20),
                  height: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 32,
                                foregroundImage: NetworkImage(myAccount.imagePath),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(myAccount.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                  Text('@${myAccount.userId}', style: const TextStyle(color: Colors.grey),),
                                ],
                              )
                            ],
                          ),
                          OutlinedButton(onPressed: () {}, child: const Text('編集'))
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(myAccount.selfIntroduction)
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(
                      color: Colors.grey, width: 1,
                    )),
                  ),
                  child: const Text('投稿', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                ),
                Expanded(child: ListView.builder(
                  itemCount: postList.length,
                  physics: const NeverScrollableScrollPhysics(),
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
                                          Text(myAccount.name, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
