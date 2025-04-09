import 'package:flutter/material.dart';

class DateAndTime {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  /// Date
  DateTime initial = DateTime(2000);
  DateTime last = DateTime(2025);

  Future displayDatePicker(
      BuildContext context, TextEditingController dateController) async {
    var date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: initial,
      lastDate: last,
    );

    if (date != null) {
      selectedDate = date;
      dateController.text = date.toLocal().toString().split(" ")[0];
    }
  }

  Future displayTimePicker(
      BuildContext context, TextEditingController timeController) async {
    var time = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (time != null) {
      selectedTime = time;
      timeController.text = "${time.hour}:${time.minute}";
    }
  }
}
