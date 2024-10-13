import 'package:flutter/material.dart';
import 'package:project_1/managers/handler.dart';
import 'package:project_1/managers/taskmanager.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});
  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final ValueNotifier<DateTime?> _selectedDayNotifier =
      ValueNotifier<DateTime?>(null);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 60.0, bottom: 30.0),
        child: Column(
          children: <Widget>[
            getCalendarWidget(_selectedDayNotifier),
            const SizedBox(height: 20),
            ValueListenableBuilder<DateTime?>(
              valueListenable: _selectedDayNotifier,
              builder: (context, selectedDay, child) {
                final selectedDate = selectedDay ?? DateTime.now();
                print('Tareas del día: $selectedDate');
                print(TaskManager.instance.getTareasDelDia(selectedDate));
                return Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    // Mostramos las tareas correspondientes a la fecha seleccionada
                    child: getTareasListPage(
                        TaskManager.instance.getTareasDelDia(selectedDate)),
                  ),
                );
              },
            ),
          ],
        ));
  }
}
