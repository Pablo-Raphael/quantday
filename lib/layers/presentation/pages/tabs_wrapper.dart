import 'package:flutter/material.dart';
import 'package:quantday/layers/presentation/pages/calendar/calendar_tab.dart';
import 'package:quantday/layers/presentation/pages/habits/habits_tab.dart';
import 'package:quantday/layers/presentation/pages/tasks/tasks_tab.dart';

class TabsWrapper extends StatelessWidget {
  const TabsWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.white10,
          elevation: 0,
          title: const Text(
            "QuantDay",
            style: TextStyle(fontSize: 24, color: Colors.cyan),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.grey,
            tabs: [
              Tab(
                icon: Icon(
                  Icons.check_circle_outline,
                  color: Colors.grey,
                  size: 24,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.rotate_left_outlined,
                  color: Colors.grey,
                  size: 24,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.grey,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
        body: const SafeArea(
          child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              TasksTab(tabIndex: 0),
              HabitsTab(tabIndex: 1),
              CalendarTab(tabIndex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
