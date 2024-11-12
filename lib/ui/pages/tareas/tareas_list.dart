import 'package:flutter/material.dart';
import 'package:project_1/managers/handler.dart';
import 'package:project_1/entities/tarea.dart';

class TareasPage extends StatefulWidget {
  final List<Tarea> tareas;
  const TareasPage({super.key, required this.tareas});
  @override
  State<TareasPage> createState() => _TareasPageState();
}

class _TareasPageState extends State<TareasPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.tareas.length,
      itemBuilder: (context, index) {
        Tarea tarea = widget.tareas[index];
        return Column(
          children: [
            tarea.tipo == 'cuantificable'
                ? getTaskQkt(tarea)
                : getTaskBool(tarea),
            const SizedBox(height: 2.0), // Espacio entre tareas
          ],
        );
      },
    );
  }
}
