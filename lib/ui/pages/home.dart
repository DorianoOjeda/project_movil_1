import 'package:flutter/material.dart';
import 'tareas/tareas_list.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // numero de pestañas
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
            const TareasPage(),
          ],
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
          focusedDay: DateTime.now(),
        ),
        //widget para superrachas
        _buildSuperStreaks(),
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
          Text("5 semanas consecutivas completando todas las tareas",
              style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
