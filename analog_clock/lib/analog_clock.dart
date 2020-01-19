import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import 'package:vector_math/vector_math_64.dart' show radians;
import 'package:analog_clock/hour_hand.dart';
import 'package:analog_clock/minute_hand.dart';
import 'package:analog_clock/seconds_dart.dart';
import 'clock_dial_painter.dart';


final radiansPerTick = radians(360 / 60);
final radiansPerHour = radians(360 / 12);

class AnalogClock extends StatefulWidget {
  const AnalogClock(this.model);
  final ClockModel model;

  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  var _now = DateTime.now();
  var _temperature = '';
  var _temperatureRange = '';
  var _condition = '';
  var _location = '';
  Timer _timer;

  @override
  void initState() {
    super.initState();

//orientation control in landscape mode only...

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    widget.model.addListener(_updateModel);
    // Set the initial values.
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(AnalogClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;
      _temperatureRange = '(${widget.model.low} - ${widget.model.highString})';
      _condition = widget.model.weatherString;
      _location = widget.model.location;
    });
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      // Update once per second. Make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).brightness == Brightness.dark
        ? Theme.of(context)
            .copyWith(accentColor: Colors.black, backgroundColor: Colors.white)
        : Theme.of(context).copyWith(
            accentColor: Colors.white,
            backgroundColor: Colors.black,
          );

    final time = DateFormat.Hms().format(DateTime.now());
    final weatherInfo = DefaultTextStyle(
      style: TextStyle(color: customTheme.accentColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _temperature,
            style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
          ),
          Text(
            _condition,
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),

          // Text(_location),
        ],
      ),
    );

    final locationInfo = DefaultTextStyle(
      style: TextStyle(color: customTheme.accentColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _location,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 22.0
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    "images/night.jpg"), //can change acc to location and time.
                fit: BoxFit.fill)),

//clock background

        child: Stack(
          children: [
            
//Weather conditions

            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("images/rain.gif")),
              ),
            ),

//Clock  background

            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: customTheme.backgroundColor),
              height: 220,
              width: 220,
            ),

//Dailers of the clock

            new Container(
              padding: EdgeInsets.only(top: 9.0, left: 8.0),
              width: double.infinity,
              height: double.infinity,
              child: new CustomPaint(
                painter: new ClockDialPainter(
                  clockText: "Alert",
                  colore: customTheme.accentColor,
                ),
              ),
            ),

// SecondHand

            Container(
              padding: EdgeInsets.only(top: 8.0, left: 8.0),
              child: SecondsHand(
                color: Colors.red,
                thickness: 4,
                size: 1,
                angleRadians: _now.second * radiansPerTick,
              ),
            ),

// MinuteHand

            Container(
              padding: EdgeInsets.only(top: 8.0, left: 8.0),
              child: MinuteHand(
                color: customTheme.accentColor,
                thickness: 16,
                size: 0.9,
                angleRadians: _now.minute * radiansPerTick,
              ),
            ),

// HourHand

            Container(
              padding: EdgeInsets.only(top: 8.0, left: 8.0),
              child: HourHand(
                color: customTheme.accentColor,
                size: 0.5,
                angleRadians: _now.hour * radiansPerHour +
                    (_now.minute / 60) * radiansPerHour,
                child: Transform.translate(
                  offset: Offset(0.0, -60.0),
                  child: Container(
                    width: 32,
                    height: 150,
                    decoration: BoxDecoration(
                      color: customTheme.primaryColor,
                    ),
                  ),
                ),
              ),
            ),

//weather info

            Positioned(
              right: 0,
              top: 0,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: weatherInfo,
              ),
            ),

// location info

            Positioned(
              right: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: locationInfo,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
