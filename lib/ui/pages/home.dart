import 'package:flutter/material.dart';
import 'tareas/tareas_list.dart';
import 'tareas/tareas_add.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> tareas = [];
  DateTime _selectedDay = DateTime.now(); // Mantener el dia seleccionado

  void _addTarea(Map<String, dynamic> tarea) {
    setState(() {
      tareas.add(tarea);
    });
  }

  List<Map<String, dynamic>> _getTareasDelDia() {
    return tareas.where((tarea) {
      DateTime fechaInicio = DateTime.parse(tarea['fechaInicio']);

      // Evitar que las tareas completadas se muestren
      if (tarea['completada'] == true) {
        return false;
      }

      // Evitar que las tareas se muestren antes de su fecha de inicio
      if (_selectedDay.isBefore(fechaInicio)) {
        return false;
      }

      // Verificar si es una tarea repetitiva y calcular la proxima aparicoin
      if (tarea['frecuencia'] != 'Nunca') {
        if (tarea['frecuencia'] == 'Diariamente') {
          return _selectedDay.difference(fechaInicio).inDays % 1 == 0;
        } else if (tarea['frecuencia'] == 'Semanalmente') {
          return _selectedDay.difference(fechaInicio).inDays % 7 == 0;
        } else if (tarea['frecuencia'] == 'Mensualmente') {
          return _selectedDay.day == fechaInicio.day;
        }
      }

      // Mostrar solo las tareas no repetitivas si son del dia seleccionado
      return isSameDay(fechaInicio, _selectedDay);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // número de pestañas
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
                // implementar perfil de usuario
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
          heroTag: 'uniqueFabTag',
          onPressed: () async {
            // Navegacion para agregar una nueva tarea
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TareasAddPage(
                  onSave: (tarea) {
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
      color: Color.fromARGB(255, 255, 217, 0),
      child: const Column(
        children: [
          Text("SuperRachas",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text("5 semanas consecutivas completando todas las tareas"),
        ],
      ),
    );
  }

  // Mostrar tareas del dia seleccionado
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
                  subtitle: Text("Fecha: ${tarea['fechaInicio']}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
