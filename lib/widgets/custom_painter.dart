import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hangman/models/painter_model.dart';

class MyPainter extends CustomPainter {
  PainterModel circlePainter;
  PainterModel leftHandPainter;
  PainterModel rightHandPainter;
  PainterModel bodyPainter;
  PainterModel rightLegPainter;
  PainterModel leftLegPainter;
  MyPainter({
    @required this.circlePainter,
    @required this.bodyPainter,
    @required this.leftHandPainter,
    @required this.leftLegPainter,
    @required this.rightHandPainter,
    @required this.rightLegPainter,
  });
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    Paint darkPainter = new Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    double standHeight = ScreenUtil.getInstance().setHeight(200);
    double hangerHeight = ScreenUtil.getInstance().setHeight(30);
    double hangerWidth = ScreenUtil.getInstance().setHeight(120);
    double platformWidth = ScreenUtil.getInstance().setWidth(100);
    double headSize = ScreenUtil.getInstance().setHeight(25);
    double bodyHeight = ScreenUtil.getInstance().setHeight(50);
    double limbSize = ScreenUtil.getInstance().setHeight(45);
    double legSpace = ScreenUtil.getInstance().setWidth(30);
    double neckHeight = ScreenUtil.getInstance().setHeight(20);
    double handTilt = ScreenUtil.getInstance().setHeight(20);

    // drawing platform
    canvas.drawLine(Offset(0, standHeight + 10),
        Offset(platformWidth, standHeight + 10), darkPainter);
    // drawing stand
    canvas.drawLine(Offset(0, 0), Offset(0, standHeight + 10), darkPainter);
    // drawing hanger
    canvas.drawLine(Offset(0, 0), Offset(hangerWidth, 0), darkPainter);
    canvas.drawLine(
        Offset(hangerWidth, 0), Offset(hangerWidth, hangerHeight), paint);
    // drawing head
    if (circlePainter.shouldPaint) {
      double arcAngle = 2 * pi * (circlePainter.percentage / 100);
      canvas.drawArc(
          new Rect.fromCircle(
              center: Offset(hangerWidth, hangerHeight + headSize),
              radius: headSize),
          -pi / 2,
          arcAngle,
          false,
          paint);
    }
    // drawing body
    if (bodyPainter.shouldPaint) {
      canvas.drawLine(
          Offset(hangerWidth, hangerHeight + (2 * headSize)),
          Offset(
              hangerWidth,
              hangerHeight +
                  (2 * headSize) +
                  howMuchLeft(bodyPainter.percentage, bodyHeight)),
          paint);
    }

    // drawing left hand
    if (leftHandPainter.shouldPaint) {
      canvas.drawLine(
          Offset(hangerWidth, hangerHeight + (2 * headSize) + neckHeight),
          Offset(
              hangerWidth - howMuchLeft(leftHandPainter.percentage, limbSize),
              hangerHeight +
                  (2 * headSize) +
                  neckHeight -
                  howMuchLeft(leftHandPainter.percentage, handTilt)),
          paint);
    }
    // draw right hand
    if (rightHandPainter.shouldPaint) {
      canvas.drawLine(
          Offset(hangerWidth, hangerHeight + (2 * headSize) + neckHeight),
          Offset(
              hangerWidth + howMuchLeft(rightHandPainter.percentage, limbSize),
              hangerHeight +
                  (2 * headSize) +
                  neckHeight -
                  howMuchLeft(rightHandPainter.percentage, handTilt)),
          paint);
    }

    // drawing left leg
    var bodyEnd =
        Offset(hangerWidth, hangerHeight + (2 * headSize) + bodyHeight);
    if (leftLegPainter.shouldPaint) {
      canvas.drawLine(
          bodyEnd,
          Offset(bodyEnd.dx - howMuchLeft(leftLegPainter.percentage, legSpace),
              bodyEnd.dy + howMuchLeft(leftLegPainter.percentage, limbSize)),
          paint);
    }

    // drawing right leg
    if (rightLegPainter.shouldPaint) {
      canvas.drawLine(
          bodyEnd,
          Offset(bodyEnd.dx + howMuchLeft(rightLegPainter.percentage, legSpace),
              bodyEnd.dy + howMuchLeft(rightLegPainter.percentage, limbSize)),
          paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double howMuchLeft(double currentValue, double targeValue) {
    return (targeValue / 100) * currentValue;
  }
}
