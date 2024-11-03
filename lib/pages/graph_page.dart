import 'package:create_author/components/calender.dart';
import 'package:create_author/components/record/record_detail.dart';
import 'package:create_author/components/record/record_tile_mini.dart';
import 'package:create_author/config/%08scroll_notifier.dart';
import 'package:create_author/config/color/custom_theme.dart';
import 'package:create_author/databases/contribution/contribution_helper.dart';
import 'package:create_author/databases/record/record_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({super.key});

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  late ScrollNotifier? _scrollNotifier;
  Map<DateTime, int> contributionData = {};

  @override
  void initState() {
    super.initState();
    getContributions();
    getRecords(DateTime.now());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RecordHelper>(context, listen: false)
          .getRecordsByDate(DateTime.now());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _scrollNotifier = Provider.of<ScrollNotifier>(context, listen: false);
  }

  Future<void> getContributions() async {
    Map<DateTime, int> contributions =
        await ContributionHelper().getAllContributions();
    setState(() {
      contributionData = contributions;
    });
  }

  Future<void> getRecords(DateTime date) async {
    await RecordHelper().getRecordsByDate(date);
  }

  void _changeDate(dynamic date) {
    // nav position reset
    _scrollNotifier?.updateBottomNavPosition(0.0);
    getRecords(date);
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).extension<CustomTheme>()!;
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Activity Log',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          HistoryCalendar(
              contributionData: contributionData,
              onClick: (value) {
                _changeDate(value);
              },
              onMonthChange: (value) {
                _changeDate(value);
              }),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification notification) {
                if (notification is OverscrollNotification) {
                  final double overscroll = notification.overscroll;
                  if (overscroll > 0) {
                    _scrollNotifier?.updateBottomNavPosition(100.0);
                  } else if (overscroll < 0) {
                    _scrollNotifier?.updateBottomNavPosition(0.0);
                  }
                }
                return true;
              },
              child: Consumer<RecordHelper>(
                builder: (context, value, child) {
                  final records = value.historyRecords;
                  if (records.isEmpty) {
                    return Center(
                      child: Text(
                        'No records',
                        style: TextStyle(
                            color: themeColor.colorSubGrey, fontSize: 15),
                      ),
                    );
                  } else {
                    return ListView.builder(
                        controller: _scrollNotifier?.scrollController,
                        // shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: records.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RecordDetail(record: records[index]),
                                  ),
                                );
                              },
                              child: RecordTileMini(record: records[index]));
                        });
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
