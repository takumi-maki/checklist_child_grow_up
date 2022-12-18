import 'package:checklist_child_grow_up/model/account.dart';
import 'package:checklist_child_grow_up/utils/firestore/accounts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:checklist_child_grow_up/utils/firestore/rooms.dart';
import 'package:checklist_child_grow_up/utils/widget_utils.dart';
import 'package:checklist_child_grow_up/view/room/add_email_widget.dart';
import 'package:flutter/material.dart';

import '../widget_utils/app_bar/app_bar_widget.dart';

class RegisteredEmailAddressesPage extends StatefulWidget {
  final String roomId;
  const RegisteredEmailAddressesPage({Key? key, required this.roomId}) : super(key: key);

  @override
  State<RegisteredEmailAddressesPage> createState() => _RegisteredEmailAddressesPageState();
}

class _RegisteredEmailAddressesPageState extends State<RegisteredEmailAddressesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: '登録中のメールアドレス一覧'),
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: RoomFirestore.rooms.doc(widget.roomId).snapshots(),
          builder: (context, roomSnapshot) {
            if(!roomSnapshot.hasData) {
              return Center(
                child: WidgetUtils.circularProgressIndicator()
              );
            }
            List<dynamic> registeredEmailAddresses = roomSnapshot.data!['registered_email_addresses'];
            return ListView.builder(
              itemCount: registeredEmailAddresses.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: AccountFirestore.accounts
                          .where('email', isEqualTo: registeredEmailAddresses[index])
                          .snapshots(),
                      builder: (context, accountSnapshot) {
                        if (!accountSnapshot.hasData) {
                          return const SizedBox(
                            height: 72.0,
                          );
                        }
                        if (accountSnapshot.data!.docs.isEmpty) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.orange.shade200,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.asset('assets/images/chicken.png'),
                              ),
                            ),
                            title: Text(registeredEmailAddresses[index]),
                            subtitle: const Text('アカウント 未作成'),
                          );
                        }
                        Map<String, dynamic> data = accountSnapshot.data!.docs.first.data() as Map<String, dynamic>;
                        final Account account = Account(
                          id: data['id'],
                          name: data['name'],
                          email: data['email'],
                          imagePath: data['image_path']
                        );
                        return ListTile(
                          leading: account.imagePath != null
                            ? CircleAvatar(
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage: NetworkImage(account.imagePath!)
                            )
                            : CircleAvatar(
                              backgroundColor: Colors.orange.shade200,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.asset('assets/images/chicken.png'),
                              ),
                          ),
                          title: Text(account.email),
                          subtitle: Text('${data['name']}',),
                        );
                      }
                    ),
                  )
                );
              }
            );
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20.0)
              )
            ),
            isScrollControlled: true,
            isDismissible: false,
            context: context,
            builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom
              ),
              child: AddEmailWidget(roomId: widget.roomId),
            );
          });
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
