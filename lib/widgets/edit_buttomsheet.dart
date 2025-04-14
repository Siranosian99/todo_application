import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/format_converter/date_time_convertor.dart';
import 'package:todo_application/widgets/textFormWidetTask.dart';
import '../format_converter/time_date.dart';
import 'alert_camera_gallery.dart';
import '../logics/image_picker.dart';
import '../model/todo_model.dart';
import '../notification/notifciation_method.dart';
import '../state_management/state_of_todos.dart';
import 'buttonDesignCancel.dart';

class EditBottomSheet extends StatefulWidget {
  EditBottomSheet({
    Key? key,
    required this.photoPath,
    required this.id,
    required this.index,
    required this.descpController,
    required this.taskController,
    required this.dateController,
    required this.timeController,
    required this.save_task,
  }) : super(key: key);

  final TextEditingController descpController;
  final TextEditingController taskController;
  final TextEditingController dateController;
  final TextEditingController timeController;
  String photoPath;
  final String save_task;
  final int index;
  final int id;

  @override
  State<EditBottomSheet> createState() => _EditBottomSheetState();
}

class _EditBottomSheetState extends State<EditBottomSheet> {
  double size = 20;
  Picker picker = Picker();
  DateAndTime date_time = DateAndTime();
  ShowDialog showDialog = ShowDialog();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getFirstData();
  }

  void getFirstData(){
    final todo = context.read<TodoState>().tasks[widget.index];
    widget.taskController.text = todo.task;
    widget.photoPath=todo.photoPath;
    widget.descpController.text = todo.description;
    widget.dateController.text = DateTimeConvert.formatDate(todo.date);
    widget.timeController.text = DateTimeConvert.formatTimeOfDay(todo.time);
  }

  // @override
  // void didUpdateWidget(covariant EditBottomSheet oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //
  //   if (oldWidget.index != widget.index) {
  //     final todo = context.read<TodoState>().tasks[widget.index];
  //     setState(() {
  //       widget.taskController.text = todo.task;
  //       widget.photoPath = todo.photoPath;
  //       widget.descpController.text = todo.description;
  //       widget.dateController.text = DateTimeConvert.formatDate(todo.date);
  //       widget.timeController.text = DateTimeConvert.formatTimeOfDay(todo.time);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoState>(builder: (context, todo, child) {
      return Form(
        key:_formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomCloseButton(
              onPressed: () {
                widget.taskController.clear();
                widget.descpController.clear();
                widget.timeController.clear();
                widget.dateController.clear();
                todo.clearImg();
                Navigator.pop(context);
              },
            ),

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
                    child: widget.photoPath != null && widget.photoPath.isNotEmpty
                        ? Image.file(
                      File(widget.photoPath),
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

            SizedBox(height: size),
            TextFormWidgetTask(controller:widget.taskController,widget: widget,text:"Enter Your Task Here",icon:Icon(FontAwesome.table),),
            SizedBox(height: size),
            TextFormWidgetTask(controller: widget.descpController,widget: widget,text:"Enter Your Description Here",icon:Icon(FontAwesome.tasks),),
            SizedBox(height: size),
            TextFormWidgetTime(date_time: date_time, widget: widget),
            SizedBox(height: size),
            TextFormWidgets(date_time: date_time, widget: widget),
            SizedBox(height: size),
            ElevatedButton(
              onPressed: () {
                final newTask = TodoModel(
                  id: widget.id,
                  task: widget.taskController.text,
                  date: date_time.selectedDate,
                  time: date_time.selectedTime,
                  description: widget.descpController.text,
                  photoPath: widget.photoPath,
                  isDone: false,
                );
                todo.updateTask(widget.index, newTask);
                // todo.generateUniqueId();
                Navigator.pop(context);
                widget.taskController.clear();
                widget.descpController.clear();
                widget.timeController.clear();
                widget.dateController.clear();
                todo.clearImg();

              },
              child: Text(widget.save_task),
            ),
          ],
        ),
      );
    });
  }
}



class TextFormWidgetTime extends StatelessWidget {
  const TextFormWidgetTime({
    super.key,
    required this.date_time,
    required this.widget,
  });

  final DateAndTime date_time;
  final EditBottomSheet widget;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      onTap: () {
        date_time.displayDatePicker(context, widget.dateController);
      },
      controller: widget.dateController,
      readOnly: true,
      decoration: InputDecoration(
        hintText: 'Enter task date here',
        prefixIcon: Icon(FontAwesome.calendar_times_o),
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

class TextFormWidgets extends StatelessWidget {
  const TextFormWidgets({
    super.key,
    required this.date_time,
    required this.widget,
  });

  final DateAndTime date_time;
  final EditBottomSheet widget;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.done,
      onTap: () {
        date_time.displayTimePicker(context, widget.timeController);
      },
      controller: widget.timeController,
      readOnly: true,
      decoration: InputDecoration(
        hintText: 'Enter task time here',
        prefixIcon: Icon(FontAwesome.clock),
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
