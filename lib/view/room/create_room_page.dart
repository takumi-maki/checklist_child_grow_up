import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_sns_app/utils/authentication.dart';
import 'package:demo_sns_app/utils/firestore/rooms.dart';
import 'package:demo_sns_app/utils/widget_utils.dart';
import 'package:flutter/material.dart';

import '../../model/room.dart';

class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({Key? key, }) : super(key: key);

  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  TextEditingController childNameController = TextEditingController();
  TextEditingController partnerEmailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar('ルーム作成'),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 30),
            SizedBox(
              width: 300,
              child: TextField(
                controller: childNameController,
                decoration: const InputDecoration(
                  hintText: 'お子さんのお名前'
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 300,
              child: TextField(
                controller: partnerEmailController,
                decoration: const InputDecoration(
                    hintText: 'パートナーのメールアドレス'
                ),
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async {
                if(childNameController.text.isNotEmpty) {
                  Room newRoom = Room(
                    childName: childNameController.text,
                    joinedAccounts: [Authentication.currentFirebaseUser!.email, partnerEmailController.text],
                    createdTime: Timestamp.now(),
                  );
                  var result = await RoomFirestore.addRoom(newRoom);
                  if(result) {
                    Navigator.pop(context);
                  }
                }
              },
              style: ElevatedButton.styleFrom(primary: Colors.grey),
              child: const Text('作成')
            ),
          ],
        ),
      ),
    );
  }
}
