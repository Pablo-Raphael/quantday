import 'package:flutter/material.dart';

class AddBarField extends StatelessWidget {
  final TextEditingController textController;
  final int maxLength;
  final Function(String) onSubmitted;
  final String hintText;
  final String? Function(String?) validator;

  const AddBarField({
    super.key,
    required this.textController,
    required this.maxLength,
    required this.onSubmitted,
    required this.hintText,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      controller: textController,
      keyboardType: TextInputType.text,
      onFieldSubmitted: onSubmitted,
      style: const TextStyle(color: Colors.grey, fontSize: 14),
      decoration: InputDecoration(
        counterText: '',
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.cyan, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color.fromRGBO(255, 255, 255, 0.25),
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
      ),
      validator: validator,
    );
  }
}
