import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:quantday/layers/domain/entities/habit.dart';
import 'package:quantday/layers/presentation/adapters/edit_dialog/habit_edit_dialog_adapter.dart';
import 'package:quantday/layers/presentation/widgets/edit_dialog.dart';

class HabitWidget extends StatelessWidget {
  final HabitEntity habit;
  final int habitNameMaxLength;
  final Function(HabitEntity) updateHabit;
  final Function(HabitEntity) deleteHabit;

  const HabitWidget({
    super.key,
    required this.habit,
    required this.habitNameMaxLength,
    required this.updateHabit,
    required this.deleteHabit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        spacing: 8,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return EditDialog<HabitEditDialogAdapter>(
                      item: HabitEditDialogAdapter(habit),
                      availablePoints: 0,
                      nameMaxLength: habitNameMaxLength,
                      canSetPoints: false,
                      onSave: (HabitEditDialogAdapter edited) {
                        updateHabit(edited.toEntity());
                      },
                    );
                  },
                );
              },
              child: Row(
                spacing: 8,
                children: [
                  CircularPercentIndicator(
                    radius: 16,
                    lineWidth: 1,
                    percent: 1,
                    progressColor: Colors.grey,
                    center: Text(
                      habit.weight.toString().contains(".5")
                          ? "${habit.weight}x"
                          : "${habit.weight.toStringAsFixed(0)}x",
                      maxLines: 1,
                      textScaler: TextScaler.noScaling,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),

                  Expanded(
                    child: Text(
                      habit.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),

          GestureDetector(
            onTap: () => deleteHabit(habit),
            child: Icon(
              Icons.highlight_remove_outlined,
              size: 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
