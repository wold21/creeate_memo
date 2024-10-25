import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({super.key});

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: HeatMapCalendar(
        defaultColor: Colors.black,
        datasets: {
          DateTime(2021, 1, 6): 3,
          DateTime(2021, 1, 7): 7,
          DateTime(2021, 1, 8): 10,
          DateTime(2021, 1, 9): 13,
          DateTime(2021, 1, 13): 6,
        },
        colorsets: const {
          1: Colors.red,
        },
      ),
    );
  }
}
