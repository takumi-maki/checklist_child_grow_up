import 'package:checklist_child_grow_up/utils/firestore/accounts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:checklist_child_grow_up/utils/firestore/rooms.dart';
import 'package:checklist_child_grow_up/utils/widget_utils.dart';
import 'package:checklist_child_grow_up/view/banner/ad_banner_widget.dart';
import 'package:checklist_child_grow_up/view/room/add_email_widget.dart';
import 'package:flutter/material.dart';

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
      appBar: WidgetUtils.createAppBar(context, '登録中のメールアドレス一覧'),
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: RoomFirestore.rooms.doc(widget.roomId).snapshots(),
          builder: (context, roomSnapshot) {
            if(!roomSnapshot.hasData) {
              return const SizedBox();
            }
            List<dynamic> registeredEmailAddresses = roomSnapshot.data!['registered_email_addresses'];
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: registeredEmailAddresses.length,
                    itemBuilder: (context, index) {
                      return StreamBuilder<QuerySnapshot>(
                        stream: AccountFirestore.accounts.where('email', isEqualTo: registeredEmailAddresses[index]).snapshots(),
                        builder: (context, accountSnapshot) {
                          if (!accountSnapshot.hasData) {
                            return const SizedBox();
                          }
                          if (accountSnapshot.data!.docs.isEmpty) {
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  leading: Image.asset('assets/images/chicken.png', height: 36),
                                  title: Text(registeredEmailAddresses[index]),
                                  subtitle: const Text('未登録アカウント'),
                                ),
                              ),
                            );
                          }
                          Map<String, dynamic> data = accountSnapshot.data!.docs.first.data() as Map<String, dynamic>;
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: Image.asset('assets/images/chicken.png', height: 36),
                                title: Text(data['email']),
                                subtitle: Text(data['name']),
                              ),
                            ),
                          );
                        }
                      );
                    }
                  ),
                ),
                const AdBannerWidget(),
              ],
            );
          }
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 54.0),
        child: FloatingActionButton(
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
      ),
    );
  }
}
