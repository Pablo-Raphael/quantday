import 'package:get_it/get_it.dart';
import 'package:quantday/core/utils/database_helper.dart';
import 'package:quantday/layers/data/datasources/dates_datasource.dart';
import 'package:quantday/layers/data/datasources/habit_categories_datasource.dart';
import 'package:quantday/layers/data/datasources/habits_datasource.dart';
import 'package:quantday/layers/data/datasources/tasks_datasource.dart';
import 'package:quantday/layers/data/repositories/dates_repository_imp.dart';
import 'package:quantday/layers/data/repositories/habits_repository_imp.dart';
import 'package:quantday/layers/data/repositories/tasks_repository_imp.dart';
import 'package:quantday/layers/domain/repositories/dates_repository.dart';
import 'package:quantday/layers/domain/repositories/habits_repository.dart';
import 'package:quantday/layers/domain/repositories/tasks_repository.dart';
import 'package:quantday/layers/domain/usecases/habit_categories/get_all_habit_categories.dart';
import 'package:quantday/layers/domain/usecases/habit_categories/save_habit_category.dart';
import 'package:quantday/layers/domain/usecases/habit_categories/update_habit_category.dart';
import 'package:quantday/layers/domain/usecases/habits/delete_habit.dart';
import 'package:quantday/layers/domain/usecases/habit_categories/delete_habit_category.dart';
import 'package:quantday/layers/domain/usecases/habits/save_habit.dart';
import 'package:quantday/layers/domain/usecases/habits/update_habit.dart';
import 'package:quantday/layers/domain/usecases/tasks/save_task.dart';
import 'package:quantday/layers/domain/usecases/tasks/delete_task.dart';
import 'package:quantday/layers/domain/usecases/tasks/get_current_day_tasks.dart';
import 'package:quantday/layers/domain/usecases/tasks/get_all_tasks_grouped_by_day.dart';
import 'package:quantday/layers/domain/usecases/tasks/save_tasks.dart';
import 'package:quantday/layers/domain/usecases/tasks/toggle_task_finished_status.dart';
import 'package:quantday/layers/domain/usecases/tasks/update_task.dart';
import 'package:quantday/layers/presentation/controllers/calendar_controller.dart';
import 'package:quantday/layers/presentation/controllers/habits_controller.dart';
import 'package:quantday/layers/presentation/controllers/tasks_controller.dart';

abstract class Inject {
  static void init() {
    final getIt = GetIt.instance;

    // Database
    getIt.registerLazySingleton<DataBaseHelper>(() {
      return DataBaseHelper();
    });

    // DataSources
    getIt.registerLazySingleton<DatesDataSource>(() {
      return DatesDataSource();
    });
    getIt.registerLazySingleton<TasksDataSource>(() {
      return TasksDataSource(getIt<DataBaseHelper>());
    });
    getIt.registerLazySingleton<HabitCategoriesDataSource>(() {
      return HabitCategoriesDataSource(getIt<DataBaseHelper>());
    });
    getIt.registerLazySingleton<HabitsDataSource>(() {
      return HabitsDataSource(getIt<DataBaseHelper>());
    });

    // Repositories
    getIt.registerLazySingleton<DatesRepository>(() {
      return DatesRepositoryImp(getIt<DatesDataSource>());
    });
    getIt.registerLazySingleton<TasksRepository>(() {
      return TasksRepositoryImp(getIt<TasksDataSource>());
    });
    getIt.registerLazySingleton<HabitsRepository>(() {
      return HabitsRepositoryImp(
        getIt<HabitCategoriesDataSource>(),
        getIt<HabitsDataSource>(),
      );
    });

    // UseCases
    getIt.registerLazySingleton<SaveTaskUseCase>(() {
      return SaveTaskUseCase(getIt<TasksRepository>());
    });
    getIt.registerLazySingleton<SaveTasksUseCase>(() {
      return SaveTasksUseCase(getIt<TasksRepository>());
    });
    getIt.registerLazySingleton<DeleteTaskUseCase>(() {
      return DeleteTaskUseCase(getIt<TasksRepository>());
    });
    getIt.registerLazySingleton<GetCurrentDayTasksUseCase>(() {
      return GetCurrentDayTasksUseCase(
        getIt<TasksRepository>(),
        getIt<DatesRepository>(),
      );
    });
    getIt.registerLazySingleton<ToggleTaskFinishedStatusUseCase>(() {
      return ToggleTaskFinishedStatusUseCase(getIt<TasksRepository>());
    });
    getIt.registerLazySingleton<UpdateTaskUseCase>(() {
      return UpdateTaskUseCase(getIt<TasksRepository>());
    });
    getIt.registerLazySingleton<GetAllTasksGroupedByDayUseCase>(() {
      return GetAllTasksGroupedByDayUseCase(getIt<TasksRepository>());
    });
    getIt.registerLazySingleton<GetAllHabitCategoriesUseCase>(() {
      return GetAllHabitCategoriesUseCase(getIt<HabitsRepository>());
    });
    getIt.registerLazySingleton<UpdateHabitUseCase>(() {
      return UpdateHabitUseCase(getIt<HabitsRepository>());
    });
    getIt.registerLazySingleton<UpdateHabitCategoryUseCase>(() {
      return UpdateHabitCategoryUseCase(getIt<HabitsRepository>());
    });
    getIt.registerLazySingleton<DeleteHabitUseCase>(() {
      return DeleteHabitUseCase(getIt<HabitsRepository>());
    });
    getIt.registerLazySingleton<DeleteHabitCategoryUseCase>(() {
      return DeleteHabitCategoryUseCase(getIt<HabitsRepository>());
    });
    getIt.registerLazySingleton<SaveHabitCategoryUseCase>(() {
      return SaveHabitCategoryUseCase(getIt<HabitsRepository>());
    });
    getIt.registerLazySingleton<SaveHabitUseCase>(() {
      return SaveHabitUseCase(getIt<HabitsRepository>());
    });

    // Controllers
    getIt.registerLazySingleton<TasksController>(() {
      return TasksController(
        saveTaskUseCase: getIt<SaveTaskUseCase>(),
        updateTaskUseCase: getIt<UpdateTaskUseCase>(),
        getCurrentDayTasksUseCase: getIt<GetCurrentDayTasksUseCase>(),
        deleteTaskUseCase: getIt<DeleteTaskUseCase>(),
        toggleTaskFinishedStatusUseCase: getIt<ToggleTaskFinishedStatusUseCase>(),
      );
    });
    getIt.registerLazySingleton<CalendarController>(() {
      return CalendarController(
        getAllTasksGroupedByDayUseCase: getIt<GetAllTasksGroupedByDayUseCase>(),
        saveTaskUseCase: getIt<SaveTaskUseCase>(),
        updateTaskUseCase: getIt<UpdateTaskUseCase>(),
        deleteTaskUseCase: getIt<DeleteTaskUseCase>(),
      );
    });
    getIt.registerLazySingleton<HabitsController>(() {
      return HabitsController(
        saveHabitCategoryUseCase: getIt<SaveHabitCategoryUseCase>(),
        getAllHabitCategoriesUseCase: getIt<GetAllHabitCategoriesUseCase>(),
        updateHabitCategoryUseCase: getIt<UpdateHabitCategoryUseCase>(),
        deleteHabitCategoryUseCase: getIt<DeleteHabitCategoryUseCase>(),
        saveHabitUseCase: getIt<SaveHabitUseCase>(),
        updateHabitUseCase: getIt<UpdateHabitUseCase>(),
        deleteHabitUseCase: getIt<DeleteHabitUseCase>(),
        saveTasksUseCase: getIt<SaveTasksUseCase>(),
      );
    });
  }
}
