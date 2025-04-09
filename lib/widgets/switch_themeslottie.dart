// switch_team_lottie.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../state_management/state_of_todos.dart';

class SwitchTeamLottie extends StatefulWidget {
  final bool isPressed;
  const SwitchTeamLottie({super.key, required this.isPressed});

  @override
  State<SwitchTeamLottie> createState() => _SwitchTeamLottieState();
}

class _SwitchTeamLottieState extends State<SwitchTeamLottie>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late bool _isPressed;

  @override
  void initState() {
    super.initState();
    _isPressed = widget.isPressed;
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 0));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.value = _isPressed ? 0.5 : 0.0;
    });
  }

  void press() {
    setState(() {
      _isPressed = !_isPressed;
    });
    _isPressed
        ? _controller.animateTo(0.5, duration: const Duration(milliseconds: 500))
        : _controller.animateBack(0.0, duration: const Duration(milliseconds: 500));
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
      onTap: () {
        press();
        todo.checkThemes(_isPressed);
      },
      child: Lottie.asset(
        'assets/lottie_animation/switch_team_animation.json',
        controller: _controller,
        width: 100,
        height: 100,
        fit: BoxFit.contain,
        repeat: false,
        onLoaded: (composition) {
          _controller.duration = composition.duration;
        },
      ),
    );
  }
}
