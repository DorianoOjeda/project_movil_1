import 'package:flutter/material.dart';
import 'package:project_1/managers/handler.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});
  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 60.0, bottom: 30.0),
        child: Column(
          children: <Widget>[
            getCalendarWidget(),
            const SizedBox(height: 20),
            const Text("Aqui va logica de las tareas",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ));
  }
}
