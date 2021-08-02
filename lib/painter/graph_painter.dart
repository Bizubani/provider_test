
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GraphPainter extends CustomPainter {
  final int _size;
  GraphPainter(this._size);
  @override
  void paint(Canvas canvas, Size size) {
    double rectWidth = mapNumber(_size.toDouble(), 0, 20, 0, size.width);
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: rectWidth,
            height: size.height),
        Paint()..color = Colors.blue);
  }

  @override
  bool shouldRepaint(GraphPainter oldPainter) => _size != oldPainter._size;

  double mapNumber(double a, double range1Start, double range1End,
      double range2Start, double range2End) {
    return range2Start +
        (a - range1Start) *
            (range2End - range2Start) /
            (range1End - range1Start);
  }
}
