import 'package:create_author/models/record.dart';
import 'package:flutter/material.dart';

class RecordTile extends StatelessWidget {
  final RecordInfo records;
  const RecordTile({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                Text(
                  records.title,
                  style: TextStyle(
                      color: Color(0xffF0EFEB),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    records.description,
                    style: TextStyle(
                        color: Color(0xffF0EFEB),
                        fontWeight: FontWeight.normal),
                    maxLines: 5, // null로 설정하면 자동으로 줄바꿈
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
