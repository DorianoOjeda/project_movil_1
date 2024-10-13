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
    String descripcion = tarea['descripcion'];
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 251, 238),
        border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
      ),
      child: ListTile(
        leading: getRachaImage(tarea['racha'], 60, 60,
            completada: tarea['completada']),
        title: prederminedText(tarea['titulo'], 16),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (descripcion.isNotEmpty) prederminedText(descripcion, 12),
            if (tarea['frecuencia'] != "Nunca")
              prederminedText("${tarea['frecuencia']}", 12),
          ],
        ),
        trailing: tarea['completada']
            ? const Icon(Icons.check, color: Colors.green)
            : IconButton(
                icon: const Icon(Icons.check_circle),
                onPressed: () {
                  if (tarea['tipo'] == 'booleano') {
                    setState(() {
                      tarea =
                          TaskManager.instance.marcarTareaComoCompletada(tarea);
                    });
                  }
                },
              ),
      ),
    );
  }
}
