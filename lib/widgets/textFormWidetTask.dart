import 'package:flutter/material.dart';

import 'edit_buttomsheet.dart';
class TextFormWidgetTask extends StatelessWidget {
  const TextFormWidgetTask({
    super.key,
    required this.icon,
    required this.widget,
    required this.text,
    required this.controller
  });

  final EditBottomSheet widget;
  final Icon icon;
  final String text;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      controller: controller,
      decoration: InputDecoration(
        hintText: text,
        prefixIcon: icon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.green, width: 2.0),
        ),
      ),
    );
  }
}