import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/format_converter/format_date_time_convertor.dart';

import '../logics/authenticator.dart';
import '../state_management/state_of_todos.dart';

class ArchiveScreen extends StatefulWidget  {
   ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> with formatConvertor{
  bool checker=false;
  void isLocked()async{
    checker=await AuthService.isDeviceSecure();
    setState(() {
      checker;
    });
  }
  @override
  void initState() {
    super.initState();
    isLocked();
  }
  @override
  Widget build(BuildContext context) {

    double size = 30;
    String title_txt1 = "Archived notes";
    String title_txt = "Todo's List";
    String imgLink =
        'images/todo2.jpg';
    String nodata = "Dont have Archived Task";
    return Consumer<TodoState>(builder: (context, todo, child) {
      return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(title_txt),
            actions: [checker ?
              IconButton(
                  icon:  todo.authArchive
                      ? Icon(FontAwesome5.lock)
                      : Icon(FontAwesome5.unlock),
                  onPressed: ()  {
                    todo.toggleAuthArchive();
                    print(todo.authArchive);
                  }):IconButton(onPressed: (){
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Active Your Screen Lock to use AUTH in App')),
              );
            }, icon:Icon(Icons.security_rounded)),

            ],
          ),

          body: Padding(
            padding: const EdgeInsets.all(25.0),
            child: todo.archive_tasks.isNotEmpty
                ? Column(
                    children: [
                      Text(
                        title_txt1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: size,
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(child: Consumer<TodoState>(
                        builder: (context, todo, child) {
                          return ListView.separated(
                            itemBuilder: (context, index) => GestureDetector(
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
                                                      icon: Icon(Icons.delete, color: Colors.red),
                                                      onPressed: () {
                                                        todo.removeFromListArchive(index);
                                                        Navigator.pop(context); // Close the dialog
                                                      },
                                                    ),
                                                    Text("Delete"),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(Icons.unarchive_outlined, color: Colors.green),
                                                      onPressed: () {
                                                        todo.addToList(todo.archive_tasks[index]);
                                                        todo.removeFromListArchive(index);
                                                        Navigator.pop(context); // Close the dialog
                                                      },
                                                    ),
                                                    Text("Undo Archive"),
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
                                todo.changeArchiveStatus(index);
                              },
                              child: Card(
                                color: todo.archive_tasks[index].isDone
                                    ? Colors.green
                                    : Colors.red,
                                child:  ListTile(
                                  leading: todo.archive_tasks[index].photoPath.isNotEmpty
                                      ? Image.file(
                                    File(todo.archive_tasks[index].photoPath),
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )
                                      : Icon(FontAwesome5.hotdog),
                                  title: Text(todo.archive_tasks[index].task),
                                  trailing: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(formatDate(todo.archive_tasks[index].date)),
                                      Text(
                                        formatTimeOfDay(todo.archive_tasks[index].time),
                                      )
                                    ],
                                  ),
                                  subtitle: Text(todo.archive_tasks[index].description),
                                ),
                              ),
                            ),
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 10),
                            itemCount: todo.archive_tasks.length,
                          );
                        },
                      )),
                    ],
                  )
                : Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [Image.asset(imgLink), Text(nodata)]),
                  ),
          ));
    });
  }
}
