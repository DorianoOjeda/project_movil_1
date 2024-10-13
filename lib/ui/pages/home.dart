import 'package:flutter/material.dart';
import 'package:project_1/managers/handler.dart';
import 'package:project_1/managers/taskmanager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              //image Racha
              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 80.0),
                child: Row(
                  children: [
                    getRachaImage(),
                    Text(
                      getSuperRachaNumber(),
                      style: const TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Tareas del día",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              Expanded(
                  child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 235, 235, 235),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child:
                    getTareasListPage(TaskManager.instance.getTareasDelDia()),
              )),
              const SizedBox(height: 10),
              FloatingActionButton(
                heroTag: 'uniqueFabTag', // Asegúrate de asignar un tag único
                onPressed: () async {
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => getTareasAddPage()),
                    );
                  }
                },
                child: const Icon(Icons.add),
              ),
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
