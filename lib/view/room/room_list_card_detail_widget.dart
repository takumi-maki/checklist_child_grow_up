import 'package:checklist_child_grow_up/utils/function_utils.dart';
import 'package:flutter/material.dart';

import '../../model/check_list.dart';
import '../../model/room.dart';
import '../check_list/check_lists_page.dart';
import 'check_list_progress_widget.dart';

class RoomListCardDetailWidget extends StatefulWidget {
  const RoomListCardDetailWidget(
      {Key? key, required this.room, required this.checkListsProgress})
      : super(key: key);

  final Room room;
  final List<CheckListProgress> checkListsProgress;

  @override
  State<RoomListCardDetailWidget> createState() =>
      _RoomListCardDetailWidgetState();
}

class _RoomListCardDetailWidgetState extends State<RoomListCardDetailWidget> {
  @override
  Widget build(BuildContext context) {
    late final int? ageMonths;
    ageMonths = FunctionUtils.calculateAgeMonths(
        birthdate: widget.room.birthdate.toDate());

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CheckListsPageWidget(room: widget.room)));
      },
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        widget.room.childName,
                        style: Theme.of(context).textTheme.titleLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ageMonths != null
                        ? Text('($ageMonthsヶ月)',
                            style: Theme.of(context).textTheme.titleSmall)
                        : const SizedBox(),
                  ),
                ],
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
                              backgroundImage:
                                  NetworkImage(widget.room.imagePath!)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 2.0),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2.0),
                          child: Text('達成したアイテム数',
                              style: Theme.of(context).textTheme.bodySmall),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widget.checkListsProgress
                                .map((checkListProgress) {
                              switch (checkListProgress.type) {
                                case CheckListType.body:
                                  return CheckListProgressWidget(
                                      title: '・体の大きな動き',
                                      checkListProgress: checkListProgress);
                                case CheckListType.hand:
                                  return CheckListProgressWidget(
                                      title: '・手の動き',
                                      checkListProgress: checkListProgress);
                                case CheckListType.voice:
                                  return CheckListProgressWidget(
                                      title: '・ことばの成長と理解',
                                      checkListProgress: checkListProgress);
                                case CheckListType.life:
                                  return CheckListProgressWidget(
                                      title: '・生活習慣と社会的な成長',
                                      checkListProgress: checkListProgress);
                                default:
                                  return const SizedBox();
                              }
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: const Icon(Icons.arrow_forward_ios)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
