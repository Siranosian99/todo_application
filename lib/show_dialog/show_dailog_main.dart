import 'package:flutter/material.dart';
import 'package:todo_application/screens/main_create.dart';
import '../widgets/detailed_container.dart';

mixin ShowMainDialog <T extends StatefulWidget> on State<T> {
  Future<T?> showMainCustomDialog<T>({
    required BuildContext context,
    required int index,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) {
        return Dialog(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop(); // Close the dialog when tapped
            },
            child: DetailedTaskContainer(index: index),
          ),
        );
      },
    );
  }
}
