import 'package:create_author/components/calender.dart';
import 'package:create_author/components/record/record_detail.dart';
import 'package:create_author/components/record/record_tile_mini.dart';
import 'package:create_author/databases/contribution/contribution_helper.dart';
import 'package:create_author/databases/record/record_helper.dart';
import 'package:create_author/utils/vibrator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GraphPage extends StatefulWidget {
  final ScrollController scrollController;
  const GraphPage({super.key, required this.scrollController});

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Activity Log',
                  style: TextStyle(
                      color: Color(0xffF0EFEB),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            HistoryCalendar(
                contributionData: contributionData,
                onClick: (value) {
                  callVibration();
                  getRecords(value);
                },
                onMonthChange: (value) {
                  callVibration();
                  getRecords(value);
                }),
            Consumer<RecordHelper>(
              builder: (context, value, child) {
                final records = value.historyRecords;
                if (records.isEmpty) {
                  return Text(
                    'No records',
                    style: TextStyle(color: Color(0xFF4D4D4D), fontSize: 18),
                  );
                } else {
                  return ListView.builder(
                      controller: widget.scrollController,
                      shrinkWrap: true,
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
            )
          ],
        ),
      ),
    );
  }
}
