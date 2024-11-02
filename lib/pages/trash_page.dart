import 'package:create_author/components/record/record_detail_trash.dart';
import 'package:create_author/components/record/record_tile_trash.dart';
import 'package:create_author/config/%08scroll_notifier.dart';
import 'package:create_author/config/color/custom_theme.dart';
import 'package:create_author/databases/record/record_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrashPage extends StatefulWidget {
  const TrashPage({super.key});

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  ScrollNotifier? _scrollNotifier;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RecordHelper>(context, listen: false).getDeletedRecords();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _scrollNotifier = Provider.of<ScrollNotifier>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).extension<CustomTheme>()!;
    return Scaffold(
        backgroundColor: themeColor.borderColor,
        appBar: AppBar(
          title: Text(
            'Trash',
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: themeColor.borderColor,
          elevation: 0,
        ),
        body: Container(
          color: themeColor.borderColor,
          child: SingleChildScrollView(
            controller: _scrollNotifier?.scrollController,
            child: Column(
              children: [
                Consumer<RecordHelper>(
                  builder: (context, recordHelper, child) {
                    final records = recordHelper.deletedRecords;
                    if (records.isEmpty) {
                      return Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                          ),
                          Center(
                            child: Text('No trash records',
                                style: TextStyle(
                                    color: themeColor.colorSubGrey,
                                    fontSize: 18)),
                          ),
                        ],
                      );
                    } else {
                      return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: records.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Dismissible(
                                key: Key(records[index].id.toString()),
                                direction: DismissDirection.horizontal,
                                dismissThresholds: const {
                                  DismissDirection.startToEnd: 0.4,
                                  DismissDirection.endToStart: 0.4,
                                },
                                background: Container(
                                  color: Colors.green[300],
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(left: 20),
                                  child: Icon(Icons.restore,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                secondaryBackground: Container(
                                  color: Colors.red[300],
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(right: 20),
                                  child: Icon(Icons.delete,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                onDismissed: (direction) async {
                                  final targetRecord = records[index];
                                  setState(() {
                                    records.remove(targetRecord);
                                  });
                                  if (direction ==
                                      DismissDirection.startToEnd) {
                                    await recordHelper
                                        .restoreRecords(targetRecord.id);
                                  } else {
                                    await recordHelper
                                        .truncateRecords(targetRecord.id);
                                  }
                                },
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                RecordDetailTrash(
                                                    record: records[index]),
                                          ));
                                    },
                                    child: RecordTileTrash(
                                        records: records[index])));
                          });
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
