import 'package:flutter/material.dart';

void showConfirmationDialog(
  BuildContext context, {
  required VoidCallback onConfirmation,
  required String title,
  String? description,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 26, 26, 26),
        title: Text(title, style: TextStyle(color: Colors.cyan)),
        content: description != null ? Text(description) : null,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ),
          TextButton(
            onPressed: () async {
              onConfirmation();
              Navigator.pop(context);
            },
            child: const Text(
              'Confirmar',
              style: TextStyle(color: Colors.cyan, fontSize: 14),
            ),
          ),
        ],
      );
    },
  );
}
