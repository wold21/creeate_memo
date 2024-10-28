import 'package:create_author/models/record.dart';
import 'package:create_author/utils/date.dart';
import 'package:flutter/material.dart';

class RecordTileMini extends StatelessWidget {
  final RecordInfo record;
  const RecordTileMini({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Color(0xFF42403F),
        width: 1,
      ))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Text(
                  record.title,
                  style: TextStyle(
                      color: Color(0xffF0EFEB),
                      fontSize: 15,
                      fontWeight: FontWeight.normal),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Text(
              getDate(record.createAt),
              style: TextStyle(
                  color: Color(0xFF4D4D4D),
                  fontSize: 12,
                  fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
    );
  }
}
