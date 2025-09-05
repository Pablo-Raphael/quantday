import 'package:flutter/material.dart';
import 'package:quantday/core/utils/quantday_validators.dart';
import 'package:quantday/layers/presentation/adapters/edit_dialog/edit_dialog_adapter.dart';
import 'package:quantday/layers/presentation/utils/show_quantday_snack_bar.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class EditDialog<T extends EditDialogAdapter> extends StatefulWidget {
  final T item;
  final void Function(T) onSave;
  final double availablePoints;
  final int nameMaxLength;
  final bool canSetPoints;

  const EditDialog({
    super.key,
    required this.item,
    required this.onSave,
    required this.availablePoints,
    required this.nameMaxLength,
    required this.canSetPoints,
  });

  @override
  State<EditDialog<T>> createState() => _EditDialogState<T>();
}

class _EditDialogState<T extends EditDialogAdapter> extends State<EditDialog<T>> {
  final _formKey = GlobalKey<FormState>();
  late T _edited;

  @override
  void initState() {
    super.initState();
    _edited = widget.item;
  }

  void _setEdited(T v) => _edited = v;

  T _getEdited() => _edited;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey.shade900,
      insetPadding: EdgeInsets.all(24),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Text('Editar', style: TextStyle(color: Colors.cyan, fontSize: 24)),
          if (widget.item.dialogDescription.isNotEmpty)
            Text(
              widget.item.dialogDescription,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12, width: double.maxFinite),
          if (widget.item.isWeighted || widget.item.isFixed) ...[
            _ValueEditor<T>(
              original: widget.item,
              getEdited: _getEdited,
              setEdited: _setEdited,
              availablePoints: widget.availablePoints,
              canSetPoints: widget.canSetPoints,
            ),
            const SizedBox(height: 24),
          ],
          Form(
            key: _formKey,
            child: _NameEditor<T>(
              original: widget.item,
              getEdited: _getEdited,
              setEdited: _setEdited,
              nameMaxLength: widget.nameMaxLength,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancelar',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSave(_getEdited());
              Navigator.pop(context);
            }
          },
          child: const Text(
            'Editar',
            style: TextStyle(color: Colors.cyan, fontSize: 14),
          ),
        ),
      ],
    );
  }
}

class _NameEditor<T extends EditDialogAdapter> extends StatefulWidget {
  final T original;
  final T Function() getEdited;
  final void Function(T) setEdited;
  final int nameMaxLength;

  const _NameEditor({
    required this.original,
    required this.getEdited,
    required this.setEdited,
    required this.nameMaxLength,
  });

  @override
  State<_NameEditor<T>> createState() => _NameEditorState<T>();
}

class _NameEditorState<T extends EditDialogAdapter> extends State<_NameEditor<T>> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.original.displayName;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: TextFormField(
            controller: _controller,
            maxLength: widget.nameMaxLength,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontSize: 16),
            decoration: const InputDecoration(
              counterText: '',
              border: UnderlineInputBorder(),
              isCollapsed: true,
            ),
            onChanged: (String text) {
              widget.setEdited(
                widget.getEdited().copyWith(displayName: text) as T,
              );
            },
            validator: (String? text) {
              return QuantDayValidators.validateName(
                text,
                maxLength: widget.nameMaxLength,
              );
            },
          ),
        ),
        const Icon(Icons.edit, color: Colors.grey, size: 20),
      ],
    );
  }
}

class _ValueEditor<T extends EditDialogAdapter> extends StatefulWidget {
  final T original;
  final T Function() getEdited;
  final void Function(T) setEdited;
  final double availablePoints;
  final bool canSetPoints;

  const _ValueEditor({
    required this.original,
    required this.getEdited,
    required this.setEdited,
    required this.availablePoints,
    required this.canSetPoints,
  });

  @override
  State<_ValueEditor<T>> createState() => _ValueEditorState<T>();
}

class _ValueEditorState<T extends EditDialogAdapter> extends State<_ValueEditor<T>> {
  final _pointsController = TextEditingController();
  final _focusNode = FocusNode();
  String _hintText = '';

  @override
  void initState() {
    super.initState();

    if (widget.original.weight != null) {
      _hintText = _formatValue(
        value: widget.original.weight!,
        isFixedValue: false,
      );
    }

    if (widget.original.points != null && widget.original.isFixed) {
      _pointsController.text = _formatValue(
        value: widget.original.points!,
        isFixedValue: true,
      );
    }

    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _pointsController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String _formatValue({required double value, required bool isFixedValue}) {
    return isFixedValue
        ? value.toStringAsFixed(2).substring(0, 4)
        : value % 1 != 0
        ? '${value}x'
        : '${value.toInt()}x';
  }

  void _setNewPoints(String? value) {
    try {
      if (widget.original.points == null) throw Exception();

      if (value == null) throw Exception();

      final parsed = double.parse(
        value.isNotEmpty ? value.trim().replaceAll(',', '.') : '0',
      );

      final maxPoints = widget.availablePoints + widget.original.points!;
      if (parsed < 0 || parsed > maxPoints) throw Exception();

      widget.setEdited(
        widget.getEdited().copyWith(weight: 1, points: parsed) as T,
      );

      setState(() {});
    } catch (_) {
      _focusNode.unfocus();

      final maxPoints = widget.availablePoints + widget.original.points!;

      _pointsController.text = _formatValue(
        value: maxPoints,
        isFixedValue: true,
      );

      widget.setEdited(
        widget.getEdited().copyWith(weight: 1, points: maxPoints) as T,
      );

      showQuantDaySnackBar(
        context,
        type: QuantDaySnackBarType.alert,
        message:
            'O valor deve ser maior que zero e no máximo '
            '${maxPoints.toStringAsFixed(2)} pontos.',
      );

      setState(() {});
    }
  }

  void _setNewWeight(double raw) {
    double newWeight;

    final decimal = raw - raw.toInt();
    if (decimal > 0.25 && decimal < 0.75) {
      newWeight = raw.toInt() + 0.5;
    } else {
      newWeight = raw.roundToDouble();
    }

    newWeight = newWeight.clamp(1.0, 5.0);

    final edited = widget.getEdited();

    if (newWeight == edited.weight && edited.isWeighted) return;

    _hintText = _formatValue(value: newWeight, isFixedValue: false);

    _pointsController.clear();

    widget.setEdited(edited.copyWith(points: 0, weight: newWeight) as T);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final edited = widget.getEdited();

    return SleekCircularSlider(
      initialValue: widget.original.weight ?? 0,
      min: 0,
      max: 5,
      appearance: CircularSliderAppearance(
        customColors: CustomSliderColors(
          trackColor: Colors.black,
          hideShadow: edited.isFixed,
          progressBarColors:
              edited.isFixed
                  ? [Colors.grey, Colors.grey]
                  : [Colors.indigo, Colors.blue, Colors.cyan],
        ),
      ),
      onChange: (double value) {
        if (_focusNode.hasFocus) _focusNode.unfocus();
        _setNewWeight(value);
      },
      innerWidget: (_) {
        return Center(
          child: TextField(
            enabled: widget.canSetPoints,
            maxLength: 4,
            focusNode: _focusNode,
            controller: _pointsController,
            cursorColor: Colors.grey,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            onChanged: _setNewPoints,
            style: const TextStyle(color: Colors.grey, fontSize: 30),
            decoration: InputDecoration(
              border: InputBorder.none,
              counterText: '',
              isCollapsed: true,
              hintText: _focusNode.hasFocus ? '' : _hintText,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 30),
            ),
          ),
        );
      },
    );
  }
}
