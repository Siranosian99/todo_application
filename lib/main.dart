import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/screens/first_screen.dart';
import 'package:todo_application/screens/home_screen.dart';
import 'package:todo_application/screens/main_create.dart';
import 'package:todo_application/state_management/state_of_todos.dart';
import 'package:todo_application/theme/dark_light.dart';
import 'package:todo_application/widgets/switch_themeslottie.dart';

import 'notification/notifciation_method.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TodoState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: Provider
            .of<TodoState>(context)
            .checkTheme ? ThemeSwitch.darkTheme : ThemeSwitch.lightTheme,
        debugShowCheckedModeBanner: false,
        title: 'Todo App',
        home: FirstScreen()
    );
  }
}


