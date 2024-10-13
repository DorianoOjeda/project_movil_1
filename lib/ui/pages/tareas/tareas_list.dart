import 'package:flutter/material.dart';
import 'package:project_1/managers/handler.dart';

class TareasPage extends StatefulWidget {
  final List<Map<String, dynamic>> tareas;
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
        Map<String, dynamic> tarea = widget.tareas[index];
        return Column(
          children: [
            tarea['tipo'] == 'cuantificable'
                ? getTaskQkt(tarea)
                : getTaskBool(tarea),
            const SizedBox(height: 2.0), // Espacio entre tareas
          ],
        );
      },
    );
  }
}
