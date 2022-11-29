import 'package:flutter/material.dart';

import '../../model/check_list.dart';
import '../../model/room.dart';
import '../check_list/check_lists_page.dart';
import 'check_list_progress_widget.dart';

class RoomListCardDetailWidget extends StatefulWidget {
  const RoomListCardDetailWidget({
    Key? key,
    required this.room,
    required this.checkListsProgress
  }) : super(key: key);

  final Room room;
  final List<CheckListProgress> checkListsProgress;


  @override
  State<RoomListCardDetailWidget> createState() => _RoomListCardDetailWidgetState();
}

class _RoomListCardDetailWidgetState extends State<RoomListCardDetailWidget> {


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => CheckListsPageWidget(
            childName: widget.room.childName,
            roomId: widget.room.id)
          )
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  widget.room.childName,
                  style: Theme.of(context).textTheme.titleLarge
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: widget.room.imagePath == null
                        ? CircleAvatar(
                          backgroundColor: Colors.green.shade200,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset(
                              'assets/images/hiyoko_up.png',
                            ),
                          ),
                        )
                        : CircleAvatar(
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: NetworkImage(widget.room.imagePath!)
                        ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.checkListsProgress.map((checkListProgress) {
                          switch (checkListProgress.type) {
                            case CheckListType.body:
                              return CheckListProgressWidget(
                                title: '体の大きな動き',
                                checkListProgress: checkListProgress
                              );
                            case CheckListType.hand:
                              return CheckListProgressWidget(
                                title: '手の動き',
                                checkListProgress: checkListProgress
                              );
                            case CheckListType.voice:
                              return CheckListProgressWidget(
                                title: 'ことばの成長と理解',
                                checkListProgress: checkListProgress
                              );
                            case CheckListType.life:
                              return CheckListProgressWidget(
                                title: '生活習慣',
                                checkListProgress: checkListProgress
                              );
                            default:
                              return const SizedBox();
                          }
                        }).toList(),
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

