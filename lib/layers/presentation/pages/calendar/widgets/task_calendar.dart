import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:quantday/core/extensions/datetime_extension.dart';
import 'package:quantday/layers/domain/entities/task.dart';
import 'package:quantday/layers/presentation/controllers/calendar_controller.dart';
import 'package:quantday/layers/presentation/widgets/calendar_date_metric_badge.dart';
import 'package:table_calendar/table_calendar.dart';

class TaskCalendar extends StatelessWidget {
  TaskCalendar({super.key});

  final _calendarController = GetIt.I<CalendarController>();

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        _calendarController.allTasks.length;
        final today = DateTime.now().dateOnly;
        return TableCalendar<TaskEntity>(
          firstDay:
              (_calendarController.firstDay?.isAfter(today) ?? true)
                  ? _calendarController.standardMinDate
                  : _calendarController.firstDay!,

          lastDay: _calendarController.lastDate,

          focusedDay: _calendarController.focusedDay,

          eventLoader: _calendarController.getTasksOfSpecificDay,

          selectedDayPredicate: (day) {
            return isSameDay(_calendarController.selectedDay, day);
          },

          onDaySelected: (selectedDay, focusedDay) {
            _calendarController.selectedDay = selectedDay;
            _calendarController.focusedDay = focusedDay;
          },

          onPageChanged: (focusedDay) {
            _calendarController.focusedDay = focusedDay;
          },

          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, tasks) {
              if (tasks.isEmpty) return null;
              final isPastDate = date.dateOnly.isBefore(today);
              return CalendarDateMetricBadge(
                isPast: isPastDate,
                value:
                    isPastDate
                        ? _calendarController.getFinishedTasksValue(tasks)
                        : tasks.length.toDouble(),
              );
            },
          ),

          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            selectedDecoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
            todayDecoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.cyan,
            ),
            weekendTextStyle: TextStyle(color: Colors.white),
            defaultTextStyle: TextStyle(color: Colors.white),
            disabledTextStyle: TextStyle(color: Colors.grey.shade900),
          ),

          availableGestures: AvailableGestures.horizontalSwipe,

          availableCalendarFormats: {CalendarFormat.month: ''},

          calendarFormat: CalendarFormat.month,

          rangeSelectionMode: RangeSelectionMode.disabled,
        );
      },
    );
  }
}
