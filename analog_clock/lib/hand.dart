import 'package:flutter/material.dart';

abstract class Hand extends StatelessWidget {

  const Hand({
    @required this.color,
    @required this.size,
    @required this.angleRadians,
  })  : assert(color != null),
        assert(size != null),
        assert(angleRadians != null);

  final Color color;
  final double size;
  final double angleRadians;
}
