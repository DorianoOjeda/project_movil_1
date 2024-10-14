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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 95, 50, 150),
              Color.fromARGB(255, 54, 29, 163)
            ], // Fondo degradado
          ),
        ),
        padding: const EdgeInsets.only(top: 60.0),
        child: Column(
          children: <Widget>[
            getCalendarWidget(_selectedDayNotifier),
            ValueListenableBuilder<DateTime?>(
              valueListenable: _selectedDayNotifier,
              builder: (context, selectedDay, child) {
                final selectedDate = selectedDay ?? DateTime.now();
                return Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.only(left: 5, right: 5, bottom: 20),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
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
