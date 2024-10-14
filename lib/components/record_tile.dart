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
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    records.title,
                    style: TextStyle(
                        color: Color(0xffF0EFEB),
                        fontSize: 20,
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
              padding:
                  const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
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
              padding:
                  const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
              child: Row(
                children: const [
                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Icon(Icons.star_rate_rounded,
                        size: 28, color: Color(0xffF0EFEB)),
                  ]),
                  SizedBox(width: 10),
                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Icon(Icons.insert_comment_outlined,
                        color: Color(0xffF0EFEB)),
                    SizedBox(width: 5),
                    Text(
                      '5',
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
