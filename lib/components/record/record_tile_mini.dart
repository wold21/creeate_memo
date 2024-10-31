import 'package:create_author/config/color/custom_theme.dart';
import 'package:create_author/models/record.dart';
import 'package:create_author/utils/date.dart';
import 'package:flutter/material.dart';

class RecordTileMini extends StatelessWidget {
  final RecordInfo record;
  const RecordTileMini({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).extension<CustomTheme>()!;
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: themeColor.borderColor,
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
                      color: Theme.of(context).colorScheme.primary,
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
                  color: themeColor.colorSubGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
    );
  }
}
