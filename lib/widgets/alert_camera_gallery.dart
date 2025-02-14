import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../logics/image_picker.dart';
import '../state_management/state_of_todos.dart';
class ShowDialog{

  Future<void> showChoiceDialog(BuildContext context,TextEditingController taskController) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Make a choice"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text("Gallery"),
                  onTap: () {
                    Navigator.of(context).pop();
                    Provider.of<TodoState>(context,listen: false).pickAndRecognizeText(ImageSource.gallery,taskController);
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                  child: Text("Camera"),
                  onTap: () {
                    Navigator.of(context).pop();
                    Provider.of<TodoState>(context,listen: false).pickAndRecognizeText(ImageSource.camera,taskController);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
