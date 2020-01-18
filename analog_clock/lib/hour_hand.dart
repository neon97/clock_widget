// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'hand.dart';
import 'dart:math' as math;

/// A clock hand that is built out of the child of a [Container].
///
/// This hand does not scale according to the clock's size.
/// This hand is used as the hour hand in our analog clock, and demonstrates
/// building a hand using existing Flutter widgets.
class HourHand extends Hand {
  /// Create a const clock [Hand].
  ///
  /// All of the parameters are required and must not be null.
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

  /// The child widget used as the clock hand and rotated by [angleRadians].
  final Widget child;

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: HourHandCustomPainter(hours: now.hour, minutes: now.minute),
        ),
      ),
    );
  }
}

class HourHandCustomPainter extends CustomPainter {
  final Paint hourHandPaint;
  int hours;
  int minutes;

  HourHandCustomPainter({this.hours, this.minutes})
      : hourHandPaint = new Paint() {
    hourHandPaint.color = Colors.black87;
    hourHandPaint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 6;
    // To draw hour hand
    canvas.save();

    canvas.translate(radius, radius);

    //checks if hour is greater than 12 before calculating rotation
    canvas.rotate(this.hours >= 12
        ? 2 * math.pi * ((this.hours - 12) / 12 + (this.minutes / 720))
        : 2 * math.pi * ((this.hours / 12) + (this.minutes / 720)));

    Path path = new Path();

    path.moveTo(-1.0, -radius + radius / 4);
    path.lineTo(-5.0, -radius + radius / 2);

    //speedometer timer analog clock like
    // path.lineTo(-2.0, 0.0);
    // path.lineTo(2.0, 0.0);
    path.lineTo(5.0, -radius + radius / 2);
    path.lineTo(1.0, -radius + radius / 4);
    path.close();

    canvas.drawPath(path, hourHandPaint);
    canvas.drawShadow(path, Colors.black, 2.0, false);

    canvas.restore();
  }

  @override
  bool shouldRepaint(HourHandCustomPainter oldDelegate) {
    return true;
  }
}
