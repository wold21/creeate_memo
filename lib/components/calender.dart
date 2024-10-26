import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class HistoryCalendar extends StatelessWidget {
  final Map<DateTime, int> contributionData;
  final Function onClick;
  final Function onMonthChange;
  const HistoryCalendar(
      {super.key,
      required this.contributionData,
      required this.onClick,
      required this.onMonthChange});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: HeatMapCalendar(
        defaultColor: Colors.black,
        flexible: true,
        datasets: contributionData,
        showColorTip: false,
        weekTextColor: Color(0xffF0EFEB),
        textColor: Color(0xffF0EFEB),
        margin: EdgeInsets.all(5),
        colorsets: const {
          1: Colors.teal,
        },
        onClick: (value) {
          onClick(value);
        },
        onMonthChange: (value) {
          onMonthChange(value);
        },
      ),
    );
  }
}
