import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_sns_app/model/check_list.dart';
import 'package:demo_sns_app/utils/firestore/rooms.dart';
import 'package:demo_sns_app/view/item_detail/item_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CheckListWidget extends StatefulWidget {
  final CheckList checkList;
  const CheckListWidget({Key? key, required this.checkList}) : super(key: key);

  @override
  State<CheckListWidget> createState() => _CheckListWidgetState();
}
class _CheckListWidgetState extends State<CheckListWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: RoomFirestore.rooms.doc(widget.checkList.roomId)
            .collection('check_lists').doc(widget.checkList.id)
            .collection('items').orderBy('month', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  Item item = Item(
                      id: snapshot.data!.docs[index].id,
                      month: data['month'],
                      isComplete: data['is_complete'] ?? false,
                      content: data['content'],
                      checkListId: data['check_list_id'],
                      hasComment: data['has_comment'] ?? false,
                      completedTime: data['completed_time']
                  );
                  final CollectionReference collectionReference = RoomFirestore.rooms.doc(widget.checkList.roomId)
                      .collection('check_lists').doc(widget.checkList.id)
                      .collection('items').doc(item.id)
                      .collection('comments');
                  collectionReference.get().then((value){
                  });
                  return Card(
                    child: ListTile(
                      leading: Text('${item.month}ヶ月'),
                      title: Text(item.content),
                      subtitle: item.isComplete ? Text('達成した日: ${DateFormat('yyyy/MM/dd').format(item.completedTime!.toDate())}') : null,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              padding: const EdgeInsets.symmetric(horizontal: 2.0),
                              child: item.hasComment ? const Icon(Icons.chat) : null
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Icon(Icons.star,
                                color: item.isComplete ? Colors.yellow : Colors.black12
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            ItemDetail(checkList: widget.checkList, item: item),
                        )
                        );
                      },
                    ),
                  );
                }
            );
          } else {
            return Container();
          }
        });
  }
}

