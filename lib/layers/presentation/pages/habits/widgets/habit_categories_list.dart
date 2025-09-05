import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:quantday/layers/domain/entities/habit_category.dart';
import 'package:quantday/layers/presentation/adapters/edit_dialog/habit_category_dialog_adapter.dart';
import 'package:quantday/layers/presentation/controllers/habits_controller.dart';
import 'package:quantday/layers/presentation/utils/show_confirmation_dialog.dart';
import 'package:quantday/layers/presentation/widgets/add_bar/add_habit_bar.dart';
import 'package:quantday/layers/presentation/widgets/habit.dart';
import 'package:quantday/layers/presentation/widgets/edit_dialog.dart';

class HabitCategoriesListWidget extends StatefulWidget {
  const HabitCategoriesListWidget({super.key});

  @override
  State<HabitCategoriesListWidget> createState() =>
      _HabitCategoriesListWidgetState();
}

class _HabitCategoriesListWidgetState extends State<HabitCategoriesListWidget> {
  final _controller = GetIt.I<HabitsController>();

  void _expansionCallBack(int index, bool isExpanded) {
    if (isExpanded) {
      _controller.expandedCategoriesIds.add(
        _controller.habitCategories[index].id,
      );
    } else {
      _controller.expandedCategoriesIds.remove(
        _controller.habitCategories[index].id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return ExpansionPanelList(
          expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 4),
          expansionCallback: _expansionCallBack,
          children: _controller.habitCategories.map((habitCategory) {
            return _habitCategory(habitCategory);
          }).toList(),
        );
      },
    );
  }

  ExpansionPanel _habitCategory(HabitCategoryEntity habitCategory) {
    final categoryId = habitCategory.id;
    final isExpanded = _controller.expandedCategoriesIds.contains(categoryId);
    return ExpansionPanel(
      backgroundColor: Colors.white10,
      isExpanded: isExpanded,
      headerBuilder: (context, _) {
        return ListTile(
          contentPadding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
          leading: isExpanded ? _leading(habitCategory) : null,
          title: Text(habitCategory.title, overflow: TextOverflow.ellipsis),
          trailing: _trailing(habitCategory),
        );
      },

      body: Column(
        children: [
          Column(
            children: habitCategory.habits.map((habit) {
              return HabitWidget(
                habit: habit,
                habitNameMaxLength: _controller.habitNameMaxLength,
                updateHabit: _controller.updateHabit,
                deleteHabit: _controller.deleteHabit,
              );
            }).toList(),
          ),

          AddHabitBar(
            habitCategory: habitCategory,
            saveHabit: _controller.saveHabit,
            onTapWeightIndicator: _controller.getIncrementedHabitWeight,
            habitNameMaxLength: _controller.habitNameMaxLength,
          ),
        ],
      ),
    );
  }

  Widget _trailing(HabitCategoryEntity habitCategory) {
    return Observer(
      builder: (context) {
        return _controller.addedCategoriesIds.contains(habitCategory.id)
            ? Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.cyan,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(3),
                  child: Icon(Icons.check, size: 14, color: Colors.black),
                ),
              )
            : GestureDetector(
                onTap: () => _controller.addHabitsToTodayTasks(habitCategory),
                child: const Icon(
                  Icons.add_circle_outline_sharp,
                  color: Colors.white70,
                ),
              );
      },
    );
  }

  Widget _leading(HabitCategoryEntity habitCategory) {
    return Row(
      spacing: 12,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            showConfirmationDialog(
              context,
              title: 'Remoção de categoria',
              description: 'Deseja mesmo apagar essa categoria?',
              onConfirmation: () {
                _controller.deleteHabitCategory(habitCategory);
              },
            );
          },
          child: Icon(Icons.delete, size: 20, color: Colors.white),
        ),

        GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            showDialog(
              context: context,
              builder: (_) {
                return EditDialog<HabitCategoryEditDialogAdapter>(
                  item: HabitCategoryEditDialogAdapter(habitCategory),
                  nameMaxLength: _controller.habitNameMaxLength,
                  canSetPoints: false,
                  availablePoints: 0,
                  onSave: (HabitCategoryEditDialogAdapter edited) {
                    _controller.updateHabitCategory(edited.toEntity());
                  },
                );
              },
            );
          },
          child: Icon(Icons.edit, size: 20, color: Colors.white),
        ),
      ],
    );
  }
}
