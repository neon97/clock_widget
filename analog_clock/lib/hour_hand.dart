import 'package:flutter/material.dart';
import 'hand.dart';
import 'dart:math' as math;

class HourHand extends Hand {

  const HourHand({
    @required Color color,
    @required double size,
    @required double angleRadians,
    this.child,
  })  : assert(size != null),
        assert(angleRadians != null),
        super(
          color: color,
          size: size,
          angleRadians: angleRadians,
        );

  final Widget child;

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: HourHandCustomPainter(hours: now.hour, minutes: now.minute,colore: color),
        ),
      ),
    );
  }
}

class HourHandCustomPainter extends CustomPainter {
  final Paint hourHandPaint;
  final Color colore;
  int hours;
  int minutes;

  HourHandCustomPainter({this.hours, this.minutes,this.colore})
      : hourHandPaint = new Paint() {
    hourHandPaint.color = colore;
    hourHandPaint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 6;
    canvas.save();
    canvas.translate(radius, radius);
    canvas.rotate(this.hours >= 12
        ? 2 * math.pi * ((this.hours - 12) / 12 + (this.minutes / 720))
        : 2 * math.pi * ((this.hours / 12) + (this.minutes / 720)));

    Path path = new Path();

    path.moveTo(-1.0, -radius + radius / 4);
    path.lineTo(-5.0, -radius + radius / 2);
    path.lineTo(5.0, -radius + radius / 2);   //speedometer timer analog clock like
    path.lineTo(1.0, -radius + radius / 4);
    path.close();

    canvas.drawPath(path, hourHandPaint);
    canvas.drawShadow(path, Colors.white, 4.0, false);
    canvas.restore();
  }

  @override
  bool shouldRepaint(HourHandCustomPainter oldDelegate) {
    return true;
  }
}
