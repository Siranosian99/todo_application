import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../state_management/state_of_todos.dart';

class SwitchTeamLottie extends StatefulWidget {
  const SwitchTeamLottie({super.key});

  @override
  State<SwitchTeamLottie> createState() => _SwitchTeamLottieState();
}

class _SwitchTeamLottieState extends State<SwitchTeamLottie>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  bool isPressed = false;


  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 10));
  }

  void pressed() async {
    await _controller.animateTo(isPressed ? 100 * 2 : 100 * 2);
    isPressed = !isPressed;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todo = Provider.of<TodoState>(context);
    return InkWell(
      onTap: () async {
        await _controller.animateTo(isPressed ? 100 * 2 : 100 * 2);
        pressed();
        todo.checkThemes(isPressed);
      },
      child:
      Lottie.asset('assets/lottie_animation/switch_team_animation.json',
          controller: _controller,
          width: 100,
          height: 100,
          fit: BoxFit.contain,
          // onLoaded: (composition) {
          //   _controller.duration = composition.duration;
          // },
        repeat: true
          ),

    );
  }
}
