import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:provider/provider.dart';

import '../format_converter/date_time_convertor.dart';
import '../state_management/state_of_todos.dart';
class DetailedTaskContainer extends StatelessWidget {
  int index;

  DetailedTaskContainer({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final todo = Provider.of<TodoState>(context);
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(220)),
      height: double.infinity,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // Align text to the start
          children: [
            // Expanded section for the image or icon
            todo.tasks[index].photoPath.isNotEmpty
                ? Expanded(
              child: Center(
                child: Image.file(
                  File(todo.tasks[index].photoPath),
                  width: double.infinity,
                  fit: BoxFit
                      .contain, // Ensure the image fits within the available space
                ),
              ),
            )
                : Expanded(
              child: Center(
                child: Icon(
                  FontAwesome5.hotdog,
                  size: 100,
                  color: Colors.white,
                ),
              ),
            ),

            // Add space between the image and the text
            SizedBox(height: 20),

            // Task details with enhanced text styling
            Text(
              "Task: ${todo.tasks[index].task}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8), // Spacing between text lines

            Text(
              "Description: ${todo.tasks[index].description}",
            ),

            SizedBox(height: 8),

            Text(
              "Date: ${DateTimeConvert.formatDate(todo.tasks[index].date)}",
            ),

            SizedBox(height: 8),

            Text(
              "Time: ${DateTimeConvert.formatTimeOfDay(todo.tasks[index].time)}",
            ),
          ],
        ),
      ),
    );
  }
}
