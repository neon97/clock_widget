import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'hand.dart';

class SecondsHand extends Hand {
  
  const SecondsHand({
    @required Color color,
    @required this.thickness,
    @required double size,
    @required double angleRadians,
  })  : assert(color != null),
        assert(thickness != null),
        assert(size != null),
        assert(angleRadians != null),
        super(
          color: color,
          size: size,
          angleRadians: angleRadians,
        );
  final double thickness;

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: SecondHandCustomPaint(seconds: now.second, colore: color),
        ),
      ),
    );
  }
}

class SecondHandCustomPaint extends CustomPainter {
  final Paint secondHandPaint;
  final Color colore;
  final Paint secondHandPointsPaint;
  int seconds;

  SecondHandCustomPaint({this.seconds, this.colore})
      : secondHandPaint = new Paint(),
        secondHandPointsPaint = new Paint() {
    secondHandPaint.color = colore;
    secondHandPaint.style = PaintingStyle.stroke;
    secondHandPaint.strokeWidth = 2.0;
    secondHandPointsPaint.color = Colors.red;
    secondHandPointsPaint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 6;
    canvas.save();
    canvas.translate(radius, radius);
    canvas.rotate(0.65 * math.pi * this.seconds / 20);

    Path path1 = new Path();
    Path path2 = new Path();

    path1.moveTo(0.0, -radius);
    path1.lineTo(0.0, radius / 4);

    path2.addOval(
        new Rect.fromCircle(radius: 5.0, center: new Offset(0.0, 0.0)));

    canvas.drawPath(path1, secondHandPaint);
    canvas.drawPath(path2, secondHandPointsPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(SecondHandCustomPaint oldDelegate) {
    return this.seconds != oldDelegate.seconds;
  }
}
