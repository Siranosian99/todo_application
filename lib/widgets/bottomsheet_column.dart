import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/logics/textfield_remover.dart';
import 'package:todo_application/widgets/textFormAddTask.dart';
import '../logics/time_date.dart';
import 'alert_camera_gallery.dart';
import '../logics/image_picker.dart';
import '../model/todo_model.dart';
import '../notification/notifciation_method.dart';
import '../state_management/state_of_todos.dart';

class BottomSheetColumn extends StatefulWidget {
  BottomSheetColumn({
    Key? key,
    required this.id,
    required this.descpController,
    required this.taskController,
    required this.dateController,
    required this.timeController,
    required this.save_task,
    required this.index,
  }) : super(key: key);

  final TextEditingController descpController;
  final TextEditingController taskController;
  final TextEditingController dateController;
  final TextEditingController timeController;
  final String save_task;
  final int index;
  final int id;

  @override
  State<BottomSheetColumn> createState() => _BottomSheetColumnState();
}

class _BottomSheetColumnState extends State<BottomSheetColumn> {
  double size = 20;
  Picker picker = Picker();
  DateAndTime date_time = DateAndTime();
  ShowDialog showDialog = ShowDialog();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoState>(builder: (context, todo, child) {
      return Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Image container with rounded corners and a shadow
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(2, 4),
                      ),
                    ],
                    color: Colors.grey[200], // Default color for placeholder
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: todo.photoPath != null
                        ? Image.file(
                            File(todo.photoPath!),
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            todo.networkImageUrl,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                // Positioned floating button with animation
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: InkWell(
                    onTap: () {
                      todo.pickImage(widget.index);
                    },
                    borderRadius: BorderRadius.circular(30),
                    splashColor: Colors.blue.withOpacity(0.5),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(2, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        FontAwesome.plus_squared_alt,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: size,
            ),

            TextformAdd(
              input: TextInputAction.next,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    showDialog.showChoiceDialog(context, widget.taskController);
                  },
                  icon: Icon(FontAwesome.camera),
                ),
                hintText: 'Enter your task here',
                prefixIcon: Icon(FontAwesome.table),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.green,
                    width: 2.0,
                  ),
                ),
              ),
              controller: widget.taskController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a task';
                }
                return null;
              },
            ),
            SizedBox(
              height: size,
            ),
            TextformAdd(
              input: TextInputAction.next,
              decoration: InputDecoration(
                hintText: 'Enter your description here',
                prefixIcon: Icon(FontAwesome.tasks),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.green,
                    width: 2.0,
                  ),
                ),
              ),
              controller: widget.descpController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            SizedBox(
              height: size,
            ),
            // TextFormField(
            //   textInputAction: TextInputAction.next,
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter a Date';
            //     }
            //     return null;
            //   },
            //   onTap: () {
            //     date_time.displayDatePicker(context, widget.dateController);
            //   },
            //   controller: widget.dateController,
            //   readOnly: true,
            //   decoration: InputDecoration(
            //     hintText: 'Enter task date here',
            //     prefixIcon: Icon(FontAwesome.calendar_times_o),
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(10.0),
            //     ),
            //     enabledBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(10.0),
            //       borderSide: BorderSide(
            //         color: Colors.blue,
            //         width: 2.0,
            //       ),
            //     ),
            //     focusedBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(10.0),
            //       borderSide: BorderSide(
            //         color: Colors.green,
            //         width: 2.0,
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(
              height: size,
            ),
            TextformAdd(
              input: TextInputAction.done,
              decoration: InputDecoration(
                hintText: 'Enter task time here',
                prefixIcon: Icon(FontAwesome.clock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.green,
                    width: 2.0,
                  ),
                ),
              ),
              controller: widget.timeController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Time';
                }
                return null;
              },
              onTap: () {
                date_time.displayTimePicker(context, widget.timeController);
              },
              readOnly: true,
            ),
            SizedBox(
              height: size,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newTask = TodoModel(
                    id: widget.id,
                    task: widget.taskController.text,
                    date: date_time.selectedDate,
                    time: date_time.selectedTime,
                    description: widget.descpController.text,
                    photoPath: todo.photoPath ?? '',
                    // Save the photo path
                    isDone: false, // Assuming new tasks are initially not done
                  );
                  todo.addToList(newTask);
                  NotificationMethod.scheduleNotificationFromInput(
                      widget.id,
                      date_time.selectedDate,
                      date_time.selectedTime,
                      widget.taskController.text);
                  todo.generateUniqueId();
                  Navigator.pop(context);
                  TextFieldRemover().removeTextFields(
                      widget.taskController,
                      widget.descpController,
                      widget.timeController,
                      widget.dateController);
                  todo.clearImg();
                }
              },
              child: Text(widget.save_task),
            ),
          ],
        ),
      );
    });
  }
}
