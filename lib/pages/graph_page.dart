import 'package:create_author/databases/contribution/contribution_helper.dart';
import 'package:create_author/models/record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({super.key});

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
  }

  Future<void> getContributions() async {
    Map<DateTime, int> contributions =
        await ContributionHelper().getAllContributions();
    setState(() {
      contributionData = contributions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
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
          HeatMapCalendar(
            defaultColor: Colors.black,
            flexible: false,
            datasets: contributionData,
            showColorTip: false,
            weekTextColor: Color(0xffF0EFEB),
            textColor: Color(0xffF0EFEB),
            margin: EdgeInsets.all(5),
            colorsets: const {
              1: Colors.teal,
            },
            onClick: (value) {},
          ),
          _records.isEmpty
              ? Expanded(
                  child: Center(
                    child: Text(
                      'No colored date...',
                      style: TextStyle(color: Color(0xFF4D4D4D), fontSize: 18),
                    ),
                  ),
                )
              : Expanded(
                  child: Center(
                    child: Text(
                      'Select a colored date',
                      style: TextStyle(color: Color(0xFF4D4D4D), fontSize: 18),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
