import 'package:flutter/cupertino.dart';

class TextFieldRemover {
  void removeTextFields(
      TextEditingController taskController,
      TextEditingController descpController,
      TextEditingController timeController,
      TextEditingController dateController,
      ) {
   taskController.clear();
    descpController.clear();
    timeController.clear();
    dateController.clear();
  }
}
