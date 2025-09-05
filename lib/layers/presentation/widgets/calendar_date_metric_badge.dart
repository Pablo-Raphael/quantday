import 'package:flutter/material.dart';

class CalendarDateMetricBadge extends StatelessWidget {
  const CalendarDateMetricBadge({
    super.key,
    required this.value,
    required this.isPast,
  });

  final double value;
  final bool isPast;

  @override
  Widget build(BuildContext context) {
    return isPast
        ? PositionedDirectional(
          bottom: 0,
          end: 0,
          child: Container(
            color: Color.lerp(Colors.red, Colors.green, value / 10),
            width: 25,
            height: 14,
            alignment: AlignmentDirectional.bottomEnd,
            child: Center(
              child: Text(
                value.toStringAsFixed(2),
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        )
        : PositionedDirectional(
          bottom: 0,
          end: 0,
          child: Container(
            color: Colors.blue,
            width: 14,
            height: 14,
            alignment: AlignmentDirectional.bottomEnd,
            child: Center(
              child: Text(
                value.toInt().toString(),
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: const TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
          ),
        );
  }
}
