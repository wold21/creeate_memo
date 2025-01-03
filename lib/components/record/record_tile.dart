import 'package:create_author/components/context_menu.dart';
import 'package:create_author/config/color/custom_theme.dart';
import 'package:create_author/databases/record/record_helper.dart';
import 'package:create_author/models/record.dart';
import 'package:create_author/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordTile extends StatelessWidget {
  final RecordInfo records;
  final VoidCallback? onDeleted;

  const RecordTile({
    super.key,
    required this.records,
    this.onDeleted,
  });

  void _showBottomSheet(BuildContext context) {
    final themeColor = Theme.of(context).extension<CustomTheme>()!;
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
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
                  color: themeColor.colorSubGrey, size: 40),
              Container(
                decoration: BoxDecoration(
                  color: themeColor.colorSubGrey,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: themeColor.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        // ContextMenu(
                        //   title: 'Edit',
                        //   icon: Icons.edit,
                        //   textColor: Color(0xFFC8C8C8),
                        //   iconColor: Color(0xFFC8C8C8),
                        //   onTap: () {
                        //     final scaffoldPageState = context
                        //         .findAncestorStateOfType<ScaffoldPageState>();
                        //     scaffoldPageState?.showInputSheet();
                        //   },
                        // ),
                        // Divider(color: Color(0xFF4D4D4D)),
                        ContextMenu(
                          title: 'Delete',
                          icon: Icons.delete_forever_rounded,
                          textColor: Theme.of(context).colorScheme.error,
                          iconColor: Theme.of(context).colorScheme.error,
                          onTap: () async {
                            Navigator.pop(context);
                            _deleteRecord(context);
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

  void _deleteRecord(BuildContext context) {
    Provider.of<RecordHelper>(context, listen: false)
        .deleteRecord(records.id)
        .then((_) {
      onDeleted?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).extension<CustomTheme>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      // padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: themeColor.recordTileBorderColor,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Text(
                          records.title,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          getDate(records.createAt),
                          style: TextStyle(
                              color: themeColor.colorSubGrey,
                              fontSize: 11,
                              fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            Provider.of<RecordHelper>(context, listen: false)
                                .toggleFavorite(records.id);
                          },
                          child: Icon(
                              records.isFavorite == 1
                                  ? Icons.star_outlined
                                  : Icons.star_outline_outlined,
                              size: 22,
                              color: records.isFavorite == 1
                                  ? Theme.of(context).colorScheme.primary
                                  : themeColor.colorSubGrey),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet(context);
                          },
                          child: Icon(
                            Icons.more_vert,
                            color: themeColor.colorSubGrey,
                            size: 24,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 3.0, left: 20.0, right: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        records.description,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w300),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 5.0, left: 20.0),
              //   child: GestureDetector(
              //     onTap: () {
              //       Provider.of<RecordHelper>(context, listen: false)
              //           .toggleFavorite(records.id);
              //     },
              //     child: Icon(
              //         records.isFavorite == 1
              //             ? Icons.star_outlined
              //             : Icons.star_outline_outlined,
              //         size: 22,
              //         color: Theme.of(context).colorScheme.primary),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
