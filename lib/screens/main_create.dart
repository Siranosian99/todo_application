import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:intl/intl.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/logics/authenticator.dart';
import '../logics/date_time_convertor.dart';
import '../notification/notifciation_method.dart';
import '../state_management/state_of_todos.dart';
import '../widgets/bottomsheet_column.dart';
import '../widgets/detailed_container.dart';
import '../widgets/edit_buttomsheet.dart';
import '../widgets/search_box.dart';
import '../widgets/switch_themes.dart';

class MainCreate extends StatefulWidget {
  const MainCreate({Key? key}) : super(key: key);

  @override
  State<MainCreate> createState() => _MainCreateState();
}

class _MainCreateState extends State<MainCreate> {
  int selectedIndex = 0; // Updated variable name for consistency
  Color tColor = Colors.white;
  Color fColor = Colors.black;
  String nodata = "There is No Tasks";

  @override
  Widget build(BuildContext context) {
    String imageLink = "images/todo1.jpg";
    String saveTask = "Save";
    String titleTxt = "Todo's List";
    return Consumer<TodoState>(
      builder: (context, todo, child) {
        bool check = todo.checkData();
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: todo.requiresAuth
                    ? Icon(FontAwesome5.lock)
                    : Icon(FontAwesome5.unlock),
                onPressed: () async {
                  todo.toggleAuthApp();
                  print(todo.requiresAuth);
                }),
            automaticallyImplyLeading: false,
            title: Text(titleTxt),
            actions: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: SwitchThemes(),
              )
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                isDismissible: true,
                context: context,
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.all(15) +  MediaQuery.of(context).viewInsets,
                    child: SingleChildScrollView(
                      child: BottomSheetColumn(
                        index:-1,
                        id: todo.id,
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
                todo.clearImg();// Clear the TextField
              });
            },
          ),
          body: check
              ? Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                SearchBox(searchController: todo.searchController),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog when tapped
                                    },
                                    child: DetailedTaskContainer(
                                      index: index,
                                    )));
                          },
                        );
                      },
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
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
                                                      padding: const EdgeInsets.all(15) +  MediaQuery.of(context).viewInsets,
                                                      child: SingleChildScrollView(
                                                        child: EditBottomSheet(
                                                          photoPath: todo.tasks[index].photoPath,
                                                          index: index,
                                                          id: todo.tasks[index].id,
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
                                                  todo.clearImg();// Clear the TextField
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
                      },
                      onDoubleTap: () {
                        todo.changeStatus(index);
                      },
                      child: Card(
                        color: todo.tasks[index].isDone
                            ? Colors.greenAccent
                            : Colors.red,
                        child: ListTile(
                          leading: todo.tasks[index].photoPath.isNotEmpty
                              ? Image.file(
                            File(todo.tasks[index].photoPath),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                              : Icon(FontAwesome5.hotdog),
                          title: Text(todo.tasks[index].task),
                          trailing: Column(

                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(DateTimeConvert.formatDate(todo.tasks[index].date)),
                              Text(
                                DateTimeConvert.formatTimeOfDay(todo.tasks[index].time),
                              )
                            ],
                          ),
                          subtitle: Text(todo.tasks[index].description),
                        ),
                      ),
                    ),
                    itemCount: todo.tasks.length,
                  ),
                ),
              ],
            ),
          )
              : Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SearchBox(searchController: todo.searchController),
                SizedBox(
                  height: 150,
                ),
                Image.asset(
                  imageLink,
                  scale: 2,
                ),
                Text(nodata),
              ],
            ),
          ),
        );
      },
    );
  }
}



