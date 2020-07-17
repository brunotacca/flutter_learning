import 'package:flutter/material.dart';
import 'dart:math' as math;

enum ObjectForm { circle, line }

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
    this.form,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;
  ObjectForm form;

  @override
  void paint(Canvas canvas, Size size) {
    if (form == null) form = ObjectForm.circle;

    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;
    if (form == ObjectForm.circle) {
      canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
      paint.color = color;
      double progress = (1.0 - animation.value) * 2 * math.pi;
      canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
    } else if (form == ObjectForm.line) {
      canvas.drawLine(size.centerLeft(Offset.zero), size.centerRight(Offset.zero), paint);
      paint.color = color;
      double progress = 1 - animation.value;
      canvas.drawLine(
          size.centerLeft(Offset.zero), size.centerLeft(Offset.zero).translate(progress * size.width, 0), paint);
    }
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value || color != old.color || backgroundColor != old.backgroundColor;
  }
}
