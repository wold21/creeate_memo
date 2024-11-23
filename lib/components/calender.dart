import 'package:create_author/config/color/custom_theme.dart';
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
    final themeColor = Theme.of(context).extension<CustomTheme>()!;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600), // Limit maximum width
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
          child: HeatMapCalendar(
            defaultColor: Colors.transparent,
            flexible: true,
            datasets: contributionData,
            showColorTip: false,
            weekTextColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).colorScheme.primary,
            fontSize: 12,
            margin: EdgeInsets.all(5),
            colorsets: {
              1: themeColor.calenderColor,
            },
            onClick: (value) {
              onClick(value);
            },
            onMonthChange: (value) {
              onMonthChange(value);
            },
          ),
        ),
      ),
    );
  }
}
