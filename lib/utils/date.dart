import 'package:intl/intl.dart';

String getDate(String time) {
  final timestamp = DateTime.parse(time);
  final DateFormat formatter = DateFormat('EE, dd, MM, yyyy');
  return formatter.format(timestamp);
}
