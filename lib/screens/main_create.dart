import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:intl/intl.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/logics/authenticator.dart';
import 'package:todo_application/show_dialog/show_dailog_main.dart';
import 'package:todo_application/widgets/switch_themeslottie.dart';
import '../format_converter/date_time_convertor.dart';
import '../logics/textfield_remover.dart';
import '../notification/notifciation_method.dart';
import '../show_dialog/show_dialog_edit.dart';
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

class _MainCreateState extends State<MainCreate> with ShowMainDialog,ShowEditDialog{
  int selectedIndex = 0; // Updated variable name for consistency
  Color tColor = Colors.white;
  Color fColor = Colors.black;
  String nodata = "There is No Tasks";
  String imageLink = "images/todo1.jpg";
  String saveTask = "Save";
  String titleTxt = "Todo's List";


  @override
  Widget build(BuildContext context) {

    return Consumer<TodoState>(
      builder: (context, todo, child) {
        bool check = todo.checkData();
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: AuthService.checker ? todo.requiresAuth
                    ? Icon(FontAwesome5.lock)
                    : Icon(FontAwesome5.unlock): Text("NO"),
                onPressed: () async {
                  todo.toggleAuthApp();
                  print(todo.requiresAuth);

                }),
            automaticallyImplyLeading: false,
            title: Text(titleTxt),
            actions: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: SwitchTeamLottie(isPressed:todo.checkTheme),
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
                TextFieldRemover().removeTextFields(todo.taskController, todo.descpController,  todo.timeController, todo.dateController);
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
                       showMainCustomDialog(context: context, index: index);
                      },
                      onLongPress: () {
                        showEditDialog(context: context, todo: todo, index: index, saveTask: saveTask);
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



