import 'package:create_author/components/context_menu.dart';
import 'package:create_author/models/record.dart';
import 'package:create_author/pages/scaffold_page.dart';
import 'package:flutter/material.dart';

class RecordTile extends StatelessWidget {
  final RecordInfo records;
  const RecordTile({super.key, required this.records});

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(
            left: 25.0,
            right: 25.0,
            top: 0,
            bottom: 40.0,
          ),
          decoration: BoxDecoration(
            color: Color(0xff1A1918),
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.horizontal_rule_rounded,
                  color: Color(0xFF4D4D4D), size: 40),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF4D4D4D),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF212121),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        ContextMenu(
                          title: 'Edit',
                          icon: Icons.edit,
                          textColor: Color(0xFFC8C8C8),
                          iconColor: Color(0xFFC8C8C8),
                          onTap: () {
                            final scaffoldPageState = context
                                .findAncestorStateOfType<ScaffoldPageState>();
                            scaffoldPageState?.showInputSheet();
                          },
                        ),
                        Divider(color: Color(0xFF4D4D4D)),
                        ContextMenu(
                          title: 'Delete',
                          icon: Icons.delete_forever_rounded,
                          textColor: Colors.red,
                          iconColor: Colors.red,
                          onTap: () {
                            print('delete');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Color(0xff4D4D4D),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      records.title,
                      style: TextStyle(
                          color: Color(0xffF0EFEB),
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text(
                          'Created',
                          style: TextStyle(
                              color: Color(0xFF4D4D4D),
                              fontSize: 12,
                              fontWeight: FontWeight.w300),
                        ),
                        SizedBox(width: 5),
                        Text(
                          records.createAt,
                          style: TextStyle(
                              color: Color(0xFF4D4D4D),
                              fontSize: 12,
                              fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet(context);
                          },
                          child: Icon(
                            Icons.more_vert,
                            color: Color(0xFF4D4D4D),
                            size: 22,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        records.description,
                        style: TextStyle(
                            color: Color(0xffF0EFEB),
                            fontWeight: FontWeight.normal),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 20.0),
                child: Row(
                  children: [
                    Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Icon(
                          records.isFavorite
                              ? Icons.star_outlined
                              : Icons.star_outline_outlined,
                          size: 22,
                          color: Color(0xffF0EFEB)),
                    ]),
                    SizedBox(width: 10),
                    Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Icon(Icons.insert_comment_outlined,
                          color: Color(0xffF0EFEB), size: 22),
                      SizedBox(width: 5),
                      Text(
                        records.replyCount.toString(),
                        style: TextStyle(color: Color(0xffF0EFEB)),
                      )
                    ])
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
