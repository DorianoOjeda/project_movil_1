import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_1/controllers/rachascontroller.dart';
import 'package:project_1/managers/handler.dart';
import 'package:project_1/controllers/taskcontroller.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showTasks = false;
  DateTime selectedDate = DateTime.now();
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
        // Reiniciamos las tareas del día y creamos las tareas correspondientes a la fecha seleccionada
        // Esto se usa para mostrar el avance de los dias.
        Provider.of<TaskController>(context, listen: false)
            .restartTareasDelDia(context);
        Provider.of<TaskController>(context, listen: false)
            .createTareasDelDia(selectedDate, false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                return Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      top: showTasks ? -50 : 0,
                      bottom: showTasks
                          ? MediaQuery.of(context).size.height * 0.5
                          : 0,
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
                              Consumer<TaskController>(
                                builder: (context, taskManager, child) {
                                  return Text(
                                      "Tareas de hoy: ${taskManager.tareasDelDia.length.toString()}",
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ));
                                },
                              ),
                              const SizedBox(height: 20),
                              Consumer<RachasController>(
                                  builder: (context, rachasManager, child) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    getRachaImage(
                                        rachasManager.superRachaNumber,
                                        100,
                                        100),
                                    const SizedBox(width: 10),
                                    Text(
                                      rachasManager.superRachaNumber.toString(),
                                      style: const TextStyle(
                                        fontSize: 38,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                );
                              }),
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
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            child: Consumer<TaskController>(
                              builder: (context, taskManager, child) {
                                if (taskManager.isLoadingTasks) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                return taskManager.isDairyTaskEmpty()
                                    ? const Center(
                                        child: Text("No tienes tareas para hoy",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)))
                                    : getTareasListPage(
                                        taskManager.tareasDelDia);
                              },
                            )),
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
                              showTasks
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
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
                            onPressed: () => _selectDate(context),
                            child: const Icon(Icons.calendar_today),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: Text("No data available"),
                );
              }
            }));
  }
}
