import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_sns_app/utils/firestore/rooms.dart';
import 'package:demo_sns_app/utils/widget_utils.dart';
import 'package:flutter/material.dart';

import '../../model/room.dart';

class AddEmailPage extends StatefulWidget {
  final String roomId;
  const AddEmailPage({Key? key, required this.roomId}) : super(key: key);

  @override
  State<AddEmailPage> createState() => _RoomAddEmailPageState();
}

class _RoomAddEmailPageState extends State<AddEmailPage> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar('メールアドレスの追加'),
      body: SizedBox(

        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 30.0),
            SizedBox(
              width: 300,
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'メールアドレス'
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                if(emailController.text.isNotEmpty) {
                  DocumentSnapshot documentSnapshot = await RoomFirestore.rooms.doc(widget.roomId).get();
                  Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
                  List<dynamic> newJoinedAccounts = data['joined_accounts'];
                  newJoinedAccounts.add(emailController.text);
                  Room updateRoom = Room(
                      id: widget.roomId,
                      childName: data['child_name'],
                      joinedAccounts: newJoinedAccounts,
                      createdTime: data['created_time']
                  );
                  var result = await RoomFirestore.updateRoom(updateRoom);
                  if(result) {
                    Navigator.pop(context);
                  }
                }
              },
              style: ElevatedButton.styleFrom(primary: Colors.grey),
              child: const Text('追加')),
          ],
        )
        ,
      ),
    );
  }
}
