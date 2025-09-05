import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:quantday/core/utils/quantday_validators.dart';
import 'package:quantday/layers/domain/entities/habit_category.dart';
import 'package:quantday/layers/presentation/widgets/add_bar/add_bar_button.dart';
import 'package:quantday/layers/presentation/widgets/add_bar/add_bar_field.dart';

class AddHabitBar extends StatefulWidget {
  final Function({
    required String name,
    required HabitCategoryEntity habitCategory,
    double? weight,
  })
  saveHabit;
  final double Function(double) onTapWeightIndicator;
  final HabitCategoryEntity habitCategory;
  final int habitNameMaxLength;

  const AddHabitBar({
    super.key,
    required this.saveHabit,
    required this.onTapWeightIndicator,
    required this.habitCategory,
    required this.habitNameMaxLength,
  });

  @override
  State<AddHabitBar> createState() => _AddHabitBarState();
}

class _AddHabitBarState extends State<AddHabitBar> {
  double _habitWeight = 1;
  final _habitNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _saveHabit() {
    if (_formKey.currentState!.validate()) {
      widget.saveHabit(
        name: _habitNameController.text,
        habitCategory: widget.habitCategory,
        weight: _habitWeight,
      );

      setState(() {
        _habitNameController.text = '';
        _habitWeight = 1;
      });
    }
  }

  @override
  void dispose() {
    _habitNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Row(
          spacing: 12,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _habitWeight = widget.onTapWeightIndicator(_habitWeight);
                });
              },
              child: CircularPercentIndicator(
                radius: 20,
                lineWidth: 2,
                percent: 1,
                progressColor: Colors.cyan,
                backgroundColor: Colors.black,
                center: Text(
                  _habitWeight.toString().contains(".5")
                      ? "${_habitWeight}x"
                      : "${_habitWeight.toStringAsFixed(0)}x",
                  textScaler: TextScaler.noScaling,
                ),
              ),
            ),

            Expanded(
              child: AddBarField(
                textController: _habitNameController,
                maxLength: widget.habitNameMaxLength,
                onSubmitted: (_) => _saveHabit(),
                hintText: 'Digite o título do novo hábito...',
                validator: (String? text) {
                  return QuantDayValidators.validateName(
                    text,
                    maxLength: widget.habitNameMaxLength,
                  );
                },
              ),
            ),

            AddBarButton(onTap: () => _saveHabit()),
          ],
        ),
      ),
    );
  }
}
