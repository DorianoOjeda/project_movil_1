import 'package:flutter/material.dart';
import 'package:project_1/managers/handler.dart';
import 'package:project_1/managers/taskmanager.dart';

class TaskQkt extends StatefulWidget {
  final Map<String, dynamic> tarea;
  const TaskQkt({super.key, required this.tarea});
  @override
  State<TaskQkt> createState() => _TaskQktState();
}

class _TaskQktState extends State<TaskQkt> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> tarea = widget.tarea;
    final int cantidadMaxima = tarea['cantidad'];
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 251, 238),
        border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ListTile(
                  leading: getRachaImage(tarea['racha'], 60, 60,
                      completada: tarea['completada']),
                  title: prederminedText(tarea['titulo'], 16),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (tarea['frecuencia'] != "Nunca")
                        prederminedText("${tarea['frecuencia']}", 12),
                      const SizedBox(height: 5),
                      Center(
                        child: Column(
                          children: [
                            LinearProgressIndicator(
                              minHeight: 10,
                              value: cantidadMaxima > 0
                                  ? tarea['cantidadProgreso'] / cantidadMaxima
                                  : 0,
                            ),
                            prederminedText(
                                "${tarea['cantidadProgreso']} / ${tarea['cantidad']}",
                                13),
                          ],
                        ),
                      ),
                      if (!tarea['completada'])
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove, size: 20),
                                  onPressed: () {
                                    setState(() {
                                      tarea = TaskManager.instance
                                          .decrementarCantidadProgreso(
                                              tarea, 1);
                                    });
                                  },
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                  ),
                                  width: 40,
                                  alignment: Alignment.center,
                                  child: Text(
                                      tarea['cantidadProgreso'].toString()),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add, size: 20),
                                  onPressed: () {
                                    setState(() {
                                      tarea = TaskManager.instance
                                          .incrementarCantidadProgreso(
                                              tarea, 1);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (tarea['completada'])
                const Padding(
                  padding: EdgeInsets.only(right: 15.0),
                  child: Icon(Icons.check, color: Colors.green),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
