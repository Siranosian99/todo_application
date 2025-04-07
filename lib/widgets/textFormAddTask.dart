import 'package:flutter/material.dart';

class TextformAdd extends StatelessWidget {
  final TextInputAction input;
  final InputDecoration decoration;
  final TextEditingController controller;
  final String? Function(String?)? validator; // Optional validator
  final VoidCallback? onTap;
  final bool? readOnly;
  const TextformAdd({
    super.key,
    required this.input,
    required this.decoration,
    required this.controller,
    this.validator,
    this.onTap,
    this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction:input,
      controller: controller,
      decoration: decoration,
      validator: validator,
      onTap:onTap,
      readOnly:readOnly ?? false,
    );
  }

} 