import 'package:create_author/models/record.dart';
import 'package:flutter/material.dart';

class RecordTile extends StatelessWidget {
  final RecordInfo records;
  const RecordTile({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF4D4D4D), width: 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
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
    );
  }
}
