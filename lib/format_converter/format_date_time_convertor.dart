import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

mixin  formatConvertor on StatelessWidget {

String formatTimeOfDay(TimeOfDay time) {
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  final formattedTime = DateFormat.Hm().format(dt); // Using 24-hour format
  return formattedTime;
}

String formatDate(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date); // Change the format as needed
}
}