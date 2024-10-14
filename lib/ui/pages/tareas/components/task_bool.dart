import 'package:flutter/material.dart';
import 'package:project_1/managers/handler.dart';
import 'package:project_1/managers/taskmanager.dart';

class TaskBool extends StatefulWidget {
  final Map<String, dynamic> tarea;
  const TaskBool({super.key, required this.tarea});
  @override
  State<TaskBool> createState() => _TaskBoolState();
}

class _TaskBoolState extends State<TaskBool> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> tarea = widget.tarea;
    bool isNonRepeating = tarea['frecuencia'] == "Nunca";

    return Container(
      margin: const EdgeInsets.only(right: 5, left: 5),
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 15),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 73, 68, 102),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: ListTile(
        title: Text(
          tarea['titulo'],
          maxLines: 1,
          style: const TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: isNonRepeating
            ? null
            : prederminedText("${tarea['frecuencia']}", 12),
        trailing: tarea['completada']
            ? const Icon(Icons.check_circle_sharp, color: Colors.green)
            : IconButton(
                icon: const Icon(
                  Icons.check_circle,
                  color: Color.fromARGB(255, 165, 165, 165),
                ),
                onPressed: () {
                  if (tarea['tipo'] == 'booleano') {
                    setState(() {
                      tarea =
                          TaskManager.instance.marcarTareaComoCompletada(tarea);
                    });
                  }
                },
                constraints: const BoxConstraints(maxWidth: 18, maxHeight: 40),
              ),
      ),
    );
  }
}
