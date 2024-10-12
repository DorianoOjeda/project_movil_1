import 'package:flutter/material.dart';
import 'package:project_1/handler.dart';
import 'tareas/tareas_list.dart';
import 'tareas/tareas_add.dart';
import 'package:table_calendar/table_calendar.dart';
import 'tareas/rachas.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> tareas = [];
  DateTime _selectedDay = DateTime.now(); // Mantener el día seleccionado

  void _addTarea(Map<String, dynamic> tarea) {
    setState(() {
      tareas.add(tarea);
    });
  }

  // Obtener las tareas del día seleccionado (incluye completadas)
  List<Map<String, dynamic>> _getTareasDelDia() {
    return tareas.where((tarea) {
      DateTime fechaInicio = DateTime.parse(tarea['fechaInicio']);

      // Mostrar tarea completada solo en su día correspondiente
      if (tarea['completada'] == true) {
        if (tarea['frecuencia'] == 'Diariamente') {
          return _selectedDay.difference(fechaInicio).inDays % 1 == 0;
        } else if (tarea['frecuencia'] == 'Semanalmente') {
          return _selectedDay.difference(fechaInicio).inDays % 7 == 0;
        } else if (tarea['frecuencia'] == 'Mensualmente') {
          return _selectedDay.day == fechaInicio.day;
        } else {
          return isSameDay(_selectedDay, fechaInicio); // Mostrar solo en su día
        }
      }

      // Evitar mostrar las tareas antes de la fecha de inicio
      if (_selectedDay.isBefore(fechaInicio)) {
        return false;
      }

      // Mostrar tareas no completadas en su ciclo correspondiente
      if (tarea['frecuencia'] != 'Nunca') {
        if (tarea['frecuencia'] == 'Diariamente') {
          return _selectedDay.difference(fechaInicio).inDays % 1 == 0;
        } else if (tarea['frecuencia'] == 'Semanalmente') {
          return _selectedDay.difference(fechaInicio).inDays % 7 == 0;
        } else if (tarea['frecuencia'] == 'Mensualmente') {
          return _selectedDay.day == fechaInicio.day;
        }
      }

      return isSameDay(
          fechaInicio, _selectedDay); // Mostrar si es el día exacto
    }).toList();
  }

  // Completar la tarea
  void _completarTarea(int index) {
    setState(() {
      Map<String, dynamic> tarea = tareas[index];

      // Solo marcar la tarea como completada si corresponde al día actual
      if (isSameDay(DateTime.now(), DateTime.parse(tarea['fechaInicio']))) {
        tarea['completada'] = true;

        // Actualizar la racha al completarse
        RachasManager.actualizarRacha(tarea, true);

        // Reprogramar la tarea si es repetitiva
        if (tarea['frecuencia'] != 'Nunca') {
          DateTime nuevaFecha = RachasManager.calcularSiguienteFecha(tarea);
          tarea['fechaInicio'] = nuevaFecha.toIso8601String();
          tarea['completada'] = false; // Resetear para la próxima repetición
        }
      }
    });
  }

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
        padding: const EdgeInsets.only(
            top: 100.0, bottom: 30.0, left: 30.0, right: 30.0),
        child: Center(
          child: Column(
            children: [
              const Text("Hola [username]!",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 80.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                        child: Image(image: AssetImage(getRachaImagePath())),
                      ),
                    ),
                    const Text(
                      "0",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text("¿Qué deseas hacer hoy?",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(height: 20),
              const Text("Implementar [agregar tareas]",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ],
          ),
        ));
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
