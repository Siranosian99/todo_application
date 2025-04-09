import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/screens/archive_screen.dart';

import '../logics/authenticator.dart';
import '../state_management/state_of_todos.dart';
import 'home_screen.dart';
import 'main_create.dart';


class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TodoState>().loadThemeState();
  }
  @override
  Widget build(BuildContext context) {
    int font_small = 25;
    int font_big = 40;
    String wlc2_txt = "Welcome Againn to ToDo\'s";
    String button_txt = "Next";
    String wlc_txt = "Welcome to ToDo let\'s save your Todos";
    String image_link =
        "images/todo.jpg";
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
        Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text(
            Provider.of<TodoState>(context).data ? wlc2_txt :wlc_txt,
            style: TextStyle(
              fontSize: font_big.toDouble(),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Image.asset(image_link),
          TextButton(
              onPressed: () async{
                bool isAuthenticated = await AuthService.authenticate( Provider.of<TodoState>(context,listen: false).requiresAuth);
                print(isAuthenticated);
              if (isAuthenticated) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              }
              else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Secure Problem'),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.blue,
                  ),
                );

              }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    button_txt,
                    style: TextStyle(fontSize: font_small.toDouble()),
                  ),
                  Icon(Icons.navigate_next)
                ],
              ))
        ]),
      ),
    );
  }
}