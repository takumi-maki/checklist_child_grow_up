import 'package:demo_sns_app/model/check_list.dart';
import 'package:demo_sns_app/view/check_list/item_detail.dart';
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
    return ListView.builder(
        itemCount: widget.checkList.items.length,
        itemBuilder: (context, index) {
          // Map<String, dynamic> data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
          Item item = Item(
              id: widget.checkList.items[index].id,
              month: widget.checkList.items[index].month,
              isComplete: widget.checkList.items[index].isComplete,
              content: widget.checkList.items[index].content,
              hasComment: widget.checkList.items[index].hasComment,
              completedTime: widget.checkList.items[index].completedTime
          );
          return Card(
            child: ListTile(
              leading: Text('${item.month}ヶ月'),
              title: Text(item.content),
              subtitle: item.completedTime != null
                ? Text('達成した日: ${DateFormat('yyyy/MM/dd').format(item.completedTime!.toDate())}')
                : null,
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
                    ItemDetail(checkList: widget.checkList, itemIndex: index, item: item),
                )
                );
              },
            ),
          );
        }
    );
  }
}
