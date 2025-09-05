import 'package:flutter/material.dart';

class AddBarButton extends StatelessWidget {
  final VoidCallback onTap;

  const AddBarButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.cyan,
        ),
        child: const Icon(Icons.add, size: 22.5),
      ),
    );
  }
}
