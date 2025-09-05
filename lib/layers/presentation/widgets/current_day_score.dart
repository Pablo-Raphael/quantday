import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CurrentDayScore extends StatelessWidget {
  const CurrentDayScore({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 20, bottom: 15),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(50.0)),
        color: Colors.white10,
      ),
      child: CircularPercentIndicator(
        radius: 60,
        lineWidth: 10.5,
        percent: (progress / 10).clamp(0, 1),
        progressColor: Colors.cyan,
        arcBackgroundColor: Colors.black,
        arcType: ArcType.FULL,
        center: Text(
          progress.toStringAsFixed(2),
          style: const TextStyle(color: Colors.cyan, fontSize: 30),
        ),
      ),
    );
  }
}
