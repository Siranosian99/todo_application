import 'package:flutter/material.dart';

class BottomNavCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, 20); // Starting point
    path.quadraticBezierTo(size.width / 2, -40, size.width, 20); // Draw the curve
    path.lineTo(size.width, size.height); // Bottom right corner
    path.lineTo(0, size.height); // Bottom left corner
    path.close(); // Close the path

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
