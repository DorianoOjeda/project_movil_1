import 'package:flutter/material.dart';
import 'tareas/tareas_list.dart';
import 'tareas/tareas_add.dart';
import 'package:table_calendar/table_calendar.dart';
import 'tareas/rachas.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
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
    return DefaultTabController(
      length: 2, // Número de pestañas
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Mi Mejor Ser"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Calendario"),
              Tab(text: "Tareas"),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                // Implementar perfil de usuario
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _buildCalendar(),
            TareasPage(tareas: tareas, onTareaAdd: _addTarea), // Pasar tareas
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'uniqueFabTag', // Asegúrate de asignar un tag único
          onPressed: () async {
            // Navegación para agregar una nueva tarea
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TareasAddPage(
                  onSave: (tarea) {
                    tarea['cantidadProgreso'] = 0; // Inicializar progreso
                    tarea['racha'] = 0; // Inicializar racha
                    _addTarea(tarea); // Agregar la tarea a la lista
                  },
                ),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2021, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _selectedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
            });
          },
        ),
        _buildSuperStreaks(),
        _buildTareasDelDia(),
      ],
    );
  }

  Widget _buildSuperStreaks() {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(top: 10),
      color: const Color.fromARGB(255, 255, 217, 0),
      child: const Column(
        children: [
          Text("SuperRachas",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text("5 semanas consecutivas completando todas las tareas"),
        ],
      ),
    );
  }

  Widget _buildTareasDelDia() {
    final tareasDelDia = _getTareasDelDia();

    return Expanded(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Tareas del día",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tareasDelDia.length,
              itemBuilder: (context, index) {
                final tarea = tareasDelDia[index];

                return ListTile(
                  title: Text(tarea['titulo']),
                  subtitle: Text("Racha: ${tarea['racha'] ?? 0} días"),
                  trailing: tarea['completada']
                      ? const Icon(Icons.check, color: Colors.green)
                      : IconButton(
                          icon: const Icon(Icons.check_circle),
                          onPressed: () {
                            _completarTarea(index);
                          },
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
