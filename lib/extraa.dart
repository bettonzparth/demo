import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class TrackPad extends StatefulWidget {
  @override
  _TrackPadState createState() => _TrackPadState();
}

class _TrackPadState extends State<TrackPad> {
  List<Offset> _circlePositions = [];
  Offset _dragPosition = Offset.zero;
  Timer? _timer;
  int _countdown = 0;
  List<int> startTimes = [];
  List<int> endTimes = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Pad'),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {

              Vibration.vibrate(pattern: [10,100]);
            },
            onPanStart: (details) {
              _dragPosition = details.localPosition;

              Vibration.vibrate(pattern: [0,500]);
            },
            onPanUpdate: (details) {
              _dragPosition = details.localPosition;
              Vibration.vibrate(pattern: [0,500]);
            },
            onPanEnd: (details) {
              Vibration.cancel();
            },
            child: Container(
              width: 500,
              height: 600,
              color: Colors.grey,
              child: Stack(
                children: [
                  CustomPaint(
                    painter: CirclePainter(
                      dragPosition: _dragPosition,
                      circlePositions: _circlePositions,
                    ),
                    child: Container(),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _startCountdown();
            },
            child: Text('Start Countdown'),
          ),
          ElevatedButton(
            onPressed: () {
              print(startTimes);
              print(endTimes);
            },
            child: Text('Print Times'),
          ),
          ElevatedButton(
            onPressed: () {
            startTimes.clear();
              endTimes.clear();
            },
            child: Text('Clean Times'),
          ),
          Center(
            child: Text(
              '$_countdown seconds remaining',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  void _addCirclePosition(Offset position) {
    _circlePositions.add(position);
  }

  void _startCountdown() {
    _countdown = 0;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown < 15) {
          _countdown++;
        } else {
          _timer?.cancel();
          _removeExcessElements();
        }
      });
    });
  }

  void _storeStartTime() {
    final int startTime = DateTime.now().second;
    if (_countdown > 0 && _countdown <= 15) {
      startTimes.add(startTime);
    }
  }

  void _storeEndTime() {
    final int endTime = DateTime.now().second;
    if (_countdown > 0 && _countdown <= 15) {
      endTimes.add(endTime);
    }
  }

  void _removeExcessElements() {
    final int length = startTimes.length > endTimes.length ? endTimes.length : startTimes.length;
    startTimes.removeRange(length, startTimes.length);
    endTimes.removeRange(length, endTimes.length);
  }
}

class CirclePainter extends CustomPainter {
  final Offset dragPosition;
  final List<Offset> circlePositions;

  CirclePainter({required this.dragPosition, required this.circlePositions});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    for (var position in circlePositions) {
      canvas.drawCircle(position, 10, paint);
    }

    if (dragPosition != Offset.zero) {
      canvas.drawCircle(dragPosition, 10, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

