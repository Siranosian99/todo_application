import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../state_management/state_of_todos.dart';

class SwitchThemes extends StatelessWidget {
  const SwitchThemes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final todo = Provider.of<TodoState>(context);
    return LiteRollingSwitch(
      value: todo.checkTheme,
      onChanged: (value) {

        todo.checkThemes(value);
      },
      textOn: 'Dark Mode',
      textOff: 'Light Mode',
      colorOn: Color.fromRGBO(54, 142, 197, 0.8),
      animationDuration:Duration(microseconds: 0),
      colorOff:  Colors.yellow,
      iconOn: FontAwesome5.moon,
      iconOff: FontAwesome5.sun,

      // Slight animation for smooth transition
      textSize: 14.0,
      // Slightly smaller for ea sleeker look
      width: 100.0,
      // Increased width for better spacing
      onTap: () {},
      onDoubleTap: () {},
      onSwipe: () {},
    );
  }
}