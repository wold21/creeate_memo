import 'package:create_author/components/calender.dart';
import 'package:create_author/components/record/record_detail.dart';
import 'package:create_author/components/record/record_tile_mini.dart';
import 'package:create_author/databases/contribution/contribution_helper.dart';
import 'package:create_author/databases/record/record_helper.dart';
import 'package:create_author/models/record.dart';
import 'package:create_author/utils/vibrator.dart';
import 'package:flutter/material.dart';

class GraphPage extends StatefulWidget {
  final ScrollController scrollController;
  const GraphPage({super.key, required this.scrollController});

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  Map<DateTime, int> contributionData = {};
  List<RecordInfo> _records = [];

  @override
  void initState() {
    super.initState();
    getContributions();
    getRecords(DateTime.now());
  }

  Future<void> getContributions() async {
    Map<DateTime, int> contributions =
        await ContributionHelper().getAllContributions();
    setState(() {
      contributionData = contributions;
    });
  }

  Future<void> getRecords(DateTime date) async {
    List<RecordInfo> records = await RecordHelper().getRecordsByDate(date);
    setState(() {
      _records = records;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          if (_records.isEmpty)
            Center(
              child: Text(
                'No records',
                style: TextStyle(color: Color(0xFF4D4D4D), fontSize: 18),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                  controller: widget.scrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: _records.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RecordDetail(record: _records[index]),
                            ),
                          );
                        },
                        child: RecordTileMini(record: _records[index]));
                  }),
            ),
        ],
      ),
    );
  }
}
