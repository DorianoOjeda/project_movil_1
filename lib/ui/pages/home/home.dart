import 'package:flutter/material.dart';
import 'package:project_1/managers/handler.dart';
import 'package:project_1/managers/taskmanager.dart';
import 'package:project_1/models/tarea.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showTasks = false;
  DateTime selectedDate = DateTime.now();
  List<Tarea> tareas = []; // pq tengo dos tareas?

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Tarea> tareas = TaskManager.instance.getTareasDelDia(selectedDate);
    return Scaffold(
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            top: showTasks ? -50 : 0,
            bottom: showTasks ? MediaQuery.of(context).size.height * 0.5 : 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 95, 50, 150),
                    Color.fromARGB(255, 54, 29, 163),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Hola [username]!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        getRachaImage(getSuperRachaNumber(), 100, 100),
                        const SizedBox(width: 10),
                        Text(
                          getSuperRachaNumber().toString(),
                          style: const TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "¿Qué harás hoy?",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (showTasks)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.35,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                margin: const EdgeInsets.only(bottom: 110),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 235, 235, 235),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: tareas.isEmpty
                    ? const Center(
                        child: Text(
                          "No tienes tareas para hoy",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : getTareasListPage(tareas),
              ),
            ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Agregar tarea",
                  style: TextStyle(
                    color: showTasks ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                FloatingActionButton(
                  heroTag: 'uniqueFabTag',
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => getTareasAddPage(),
                      ),
                    ).then((_) {
                      setState(() {});
                    });
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Ver tareas de hoy",
                  style: TextStyle(
                    color: showTasks ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      showTasks = !showTasks;
                    });
                  },
                  child: Icon(
                    showTasks ? Icons.arrow_downward : Icons.arrow_upward,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 150,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Seleccionar Fecha",
                  style: TextStyle(
                    color: showTasks ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                FloatingActionButton(
                  heroTag: 'uniqueFabTag2',
                  onPressed: () {
                    _selectDate(context);
                  },
                  child: const Icon(Icons.calendar_today),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
