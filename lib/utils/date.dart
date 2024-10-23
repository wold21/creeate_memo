import 'package:intl/intl.dart';

String getDate(String time) {
  final timestamp = DateTime.parse(time);
  final DateFormat formatter = DateFormat('EE, MMM dd, yyyy, HH:mm');
  return formatter.format(timestamp);
}
