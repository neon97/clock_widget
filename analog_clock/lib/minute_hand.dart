import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'hand.dart';

class MinuteHand extends Hand {
  const MinuteHand({
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
            painter: MinuteHandCustomPainter(
                minutes: now.minute, seconds: now.second,colore: color)),
      ),
    );
  }
}

class MinuteHandCustomPainter extends CustomPainter {
  final Color colore;
  final Paint minuteHandPaint;
  int minutes;
  int seconds;

  MinuteHandCustomPainter({this.minutes, this.seconds,this.colore})
      : minuteHandPaint = new Paint() {
    minuteHandPaint.color = colore;
    minuteHandPaint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width /6;
    canvas.save();
    canvas.translate(radius, radius);
    canvas.rotate(2 * math.pi * ((this.minutes + (this.seconds / 60)) / 60));

    Path path = new Path();
    path.moveTo(-1.5, -radius - 10.0);
    path.lineTo(-5.0, -radius / 1.8);
    path.lineTo(5.0, -radius / 1.8);
    path.lineTo(1.5, -radius - 10.0);
    path.close();

    canvas.drawPath(path, minuteHandPaint);
    canvas.drawShadow(path, Colors.white, 4.0, false);
    canvas.restore();
  }

  @override
  bool shouldRepaint(MinuteHandCustomPainter oldDelegate) {
    return true;
  }
}
