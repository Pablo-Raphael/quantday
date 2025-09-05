import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:quantday/layers/presentation/controllers/habits_controller.dart';
import 'package:quantday/layers/presentation/pages/habits/widgets/habit_categories_list.dart';
import 'package:quantday/layers/presentation/utils/show_quantday_snack_bar.dart';
import 'package:quantday/layers/presentation/widgets/add_bar/add_habit_category_bar.dart';

class HabitsTab extends StatefulWidget {
  const HabitsTab({super.key, required this.tabIndex});

  final int tabIndex;

  @override
  State<HabitsTab> createState() => _HabitsTabState();
}

class _HabitsTabState extends State<HabitsTab> {
  final _controller = GetIt.I<HabitsController>();
  late final ReactionDisposer _successReactionDisposer;
  late final ReactionDisposer _alertReactionDisposer;
  late final ReactionDisposer _errorReactionDisposer;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _loadData();
    _successReactionDisposer = reaction((_) => _controller.successMessage, (
      successMessage,
    ) {
      if (successMessage != null && context.mounted) {
        showQuantDaySnackBar(
          context,
          type: QuantDaySnackBarType.success,
          title: 'Sucesso:',
          message: successMessage,
        );
        _controller.successMessage = null;
      }
    });
    _alertReactionDisposer = reaction((_) => _controller.alertMessage, (
      alertMessage,
    ) {
      if (alertMessage != null && context.mounted) {
        showQuantDaySnackBar(
          context,
          type: QuantDaySnackBarType.alert,
          title: 'Aviso:',
          message: alertMessage,
        );
        _controller.alertMessage = null;
        setState(() {});
      }
    });
    _errorReactionDisposer = reaction((_) => _controller.errorMessage, (
      errorMessage,
    ) {
      if (errorMessage != null && context.mounted) {
        showQuantDaySnackBar(
          context,
          type: QuantDaySnackBarType.error,
          title: 'Erro:',
          message: errorMessage,
        );
        _controller.errorMessage = null;
        setState(() {});
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tabController = DefaultTabController.of(context);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _successReactionDisposer();
    _alertReactionDisposer();
    _errorReactionDisposer();
    _tabController.removeListener(_handleTabChange);
    super.dispose();
  }

  void _loadData() => _controller.loadHabitCategories();

  void _handleTabChange() {
    final isSameIndex = _tabController.index == widget.tabIndex;
    if (isSameIndex && _tabController.indexIsChanging) {
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(
          child: SingleChildScrollView(child: HabitCategoriesListWidget()),
        ),

        Observer(
          builder: (_) {
            if (_controller.expandedCategoriesIds.isEmpty) {
              return AddHabitCategoryBar(
                saveHabitCategory: _controller.saveHabitCategory,
                habitCategoryTitleMaxLength: _controller.habitCategoryTitleMaxLength,
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }
}
