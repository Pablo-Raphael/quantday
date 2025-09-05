import 'package:flutter/material.dart';
import 'package:quantday/core/utils/quantday_validators.dart';
import 'package:quantday/layers/presentation/widgets/add_bar/add_bar_button.dart';
import 'package:quantday/layers/presentation/widgets/add_bar/add_bar_field.dart';

class AddHabitCategoryBar extends StatefulWidget {
  final Function({required String title}) saveHabitCategory;
  final int habitCategoryTitleMaxLength;

  const AddHabitCategoryBar({
    super.key,
    required this.saveHabitCategory,
    required this.habitCategoryTitleMaxLength,
  });

  @override
  State<AddHabitCategoryBar> createState() => _AddHabitCategoryBarState();
}

class _AddHabitCategoryBarState extends State<AddHabitCategoryBar> {
  final _habitCategoryTitleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _saveHabitCategory() {
    if (_formKey.currentState!.validate()) {
      widget.saveHabitCategory(title: _habitCategoryTitleController.text);

      _habitCategoryTitleController.text = '';
    }
  }

  @override
  void dispose() {
    _habitCategoryTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(32),
          topLeft: Radius.circular(32),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Row(
          spacing: 12,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: AddBarField(
                textController: _habitCategoryTitleController,
                maxLength: widget.habitCategoryTitleMaxLength,
                onSubmitted: (_) => _saveHabitCategory(),
                hintText: 'Digite o título da nova categoria...',
                validator: (String? text) {
                  return QuantDayValidators.validateName(
                    text,
                    maxLength: widget.habitCategoryTitleMaxLength,
                  );
                },
              ),
            ),

            AddBarButton(onTap: () => _saveHabitCategory()),
          ],
        ),
      ),
    );
  }
}
