import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:quantday/core/utils/quantday_validators.dart';
import 'package:quantday/layers/presentation/utils/show_quantday_snack_bar.dart';
import 'package:quantday/layers/presentation/widgets/add_bar/add_bar_button.dart';
import 'package:quantday/layers/presentation/widgets/add_bar/add_bar_field.dart';

class AddTaskBar extends StatefulWidget {
  final Function({required String taskName, required double? taskPoints}) saveTask;
  final int currentTaskCount;
  final int maxTaskCount;
  final double nextWeightedTaskValue;
  final double availablePoints;
  final int taskNameMaxLength;
  final bool canAddFixedTasks;

  const AddTaskBar({
    super.key,
    required this.saveTask,
    required this.currentTaskCount,
    required this.maxTaskCount,
    required this.nextWeightedTaskValue,
    required this.availablePoints,
    required this.taskNameMaxLength,
    required this.canAddFixedTasks,
  });

  @override
  State<AddTaskBar> createState() => _AddTaskBarState();
}

class _AddTaskBarState extends State<AddTaskBar> {
  final _taskPointsController = TextEditingController();
  final _taskNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _clearFields() {
    setState(() {
      _taskNameController.text = '';
      _taskPointsController.text = '';
    });
  }

  void _saveTask(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (widget.currentTaskCount >= widget.maxTaskCount) {
        _clearFields();
        return showQuantDaySnackBar(
          context,
          type: QuantDaySnackBarType.alert,
          message:
              'Limite atingido: você só pode adicionar até '
              '${widget.maxTaskCount} tarefas!',
        );
      }

      widget.saveTask(
        taskName: _taskNameController.text,
        taskPoints: double.tryParse(
          _taskPointsController.text.replaceAll(',', '.'),
        ),
      );

      _clearFields();
    }
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
          children: <Widget>[
            _PointsIndicator(
              taskPointsController: _taskPointsController,
              nextWeightedTaskValue: widget.nextWeightedTaskValue,
              availablePoints: widget.availablePoints,
              onSubmitted: _saveTask,
              canAddFixedTasks: widget.canAddFixedTasks,
            ),

            Expanded(
              child: AddBarField(
                textController: _taskNameController,
                maxLength: widget.taskNameMaxLength,
                onSubmitted: (_) => _saveTask(context),
                hintText: 'Digite o título da nova tarefa...',
                validator: (String? text) {
                  return QuantDayValidators.validateName(
                    text,
                    maxLength: widget.taskNameMaxLength,
                  );
                },
              ),
            ),

            AddBarButton(onTap: () => _saveTask(context)),
          ],
        ),
      ),
    );
  }
}

class _PointsIndicator extends StatefulWidget {
  const _PointsIndicator({
    required this.taskPointsController,
    required this.nextWeightedTaskValue,
    required this.availablePoints,
    required this.onSubmitted,
    required this.canAddFixedTasks,
  });

  final TextEditingController taskPointsController;
  final double nextWeightedTaskValue;
  final double availablePoints;
  final Function(BuildContext) onSubmitted;
  final bool canAddFixedTasks;

  @override
  State<_PointsIndicator> createState() => _PointsIndicatorState();
}

class _PointsIndicatorState extends State<_PointsIndicator> {
  final FocusNode _taskWeightFocusNode = FocusNode();
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _taskWeightFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _taskWeightFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rawValue = double.tryParse(
      widget.taskPointsController.text.replaceAll(',', '.'),
    );
    final effectiveValue = rawValue ?? widget.nextWeightedTaskValue;
    final percent = (effectiveValue / 10).clamp(0.0, 1.0);
    return CircularPercentIndicator(
      radius: 20,
      lineWidth: 2.5,
      percent: percent,
      progressColor:
          _hasError
              ? Colors.red
              : effectiveValue == widget.nextWeightedTaskValue
              ? Colors.grey
              : Colors.cyan,
      backgroundColor: Colors.black,
      center: TextFormField(
        enabled: widget.canAddFixedTasks,
        maxLength: 4,
        focusNode: _taskWeightFocusNode,
        controller: widget.taskPointsController,
        onFieldSubmitted: (_) => widget.onSubmitted(context),
        cursorColor: Colors.grey,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        autovalidateMode: AutovalidateMode.disabled,
        validator: (text) {
          return QuantDayValidators.validatePoints(
            text,
            availablePoints: widget.availablePoints,
          );
        },
        onChanged: (text) {
          final validationResult = QuantDayValidators.validatePoints(
            text,
            availablePoints: widget.availablePoints,
          );
          final isValid = validationResult == null;
          if (_hasError != !isValid) {
            setState(() {
              _hasError = !isValid;
            });
          }
        },
        style: const TextStyle(color: Colors.grey, fontSize: 13),
        decoration: InputDecoration(
          border: InputBorder.none,
          errorMaxLines: 1,
          errorStyle: TextStyle(fontSize: 0),
          counterText: '',
          isCollapsed: true,
          hintText:
              _taskWeightFocusNode.hasFocus
                  ? ""
                  : widget.nextWeightedTaskValue.toStringAsFixed(2),
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ),
    );
  }
}
