import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

enum QuantDaySnackBarType { success, alert, error }

void showQuantDaySnackBar(
  BuildContext context, {
  required QuantDaySnackBarType type,
  required String message,
  String? title,
}) {
  final backgroundColor = switch (type) {
    QuantDaySnackBarType.success => Colors.green.shade600,
    QuantDaySnackBarType.alert => Colors.yellow.shade700,
    QuantDaySnackBarType.error => Colors.red.shade800,
  };

  late final Flushbar flushBar;

  flushBar = Flushbar(
    title: title,
    titleColor: Colors.black,
    titleSize: 18,
    message: message,
    messageColor: Colors.black,
    messageSize: 16,
    backgroundColor: backgroundColor,
    duration: Duration(milliseconds: (message.length * 100).clamp(5000, 30000)),
    flushbarStyle: FlushbarStyle.GROUNDED,
    mainButton: IconButton(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.close, color: Colors.black, size: 24),
      highlightColor: Colors.transparent,
      onPressed: () => flushBar.dismiss(),
      tooltip: 'Fechar',
    ),
  );

  flushBar.show(context);
}
