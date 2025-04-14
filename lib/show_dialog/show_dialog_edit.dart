import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../state_management/state_of_todos.dart';
import '../widgets/edit_buttomsheet.dart';

mixin ShowEditDialog<T extends StatefulWidget> on State<T> {
  Future<T?> showEditDialog<T>({
    required BuildContext context,
    required TodoState todo,
    required int index,
    required String saveTask
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 16,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Task Options",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                            showModalBottomSheet(
                              enableDrag: false,
                              isDismissible: false,
                              isScrollControlled: false,
                              context: context,
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: const EdgeInsets.all(15) +
                                      MediaQuery.of(context).viewInsets,
                                  child: SingleChildScrollView(
                                    child: EditBottomSheet(
                                      photoPath: todo.tasks[index].photoPath,
                                      index: index,
                                      id: todo.tasks[index].id ?? 0,
                                      descpController: todo.descpController,
                                      taskController: todo.taskController,
                                      dateController: todo.dateController,
                                      timeController: todo.timeController,
                                      save_task: saveTask,
                                    ),
                                  ),
                                );
                              },
                            ).whenComplete(() {
// This runs when the bottom sheet is closed by the back button or other means
                              todo.taskController.clear();
                              todo.descpController.clear();
                              todo.timeController.clear();
                              todo.dateController.clear();
                              todo.clearImg(); // Clear the TextField
                            });
                          },
                        ),
                        Text("Edit"),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            todo.removeFromList(index);
                            Navigator.pop(context); // Close the dialog
                          },
                        ),
                        Text("Delete"),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.archive, color: Colors.green),
                          onPressed: () {
                            todo.addToArchive(todo.tasks[index], index);
                            Navigator.pop(context); // Close the dialog
                          },
                        ),
                        Text("Archive"),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    icon: Icon(Icons.close, color: Colors.grey),
                    label: Text(
                      "Close",
                      style: TextStyle(color: Colors.grey),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
