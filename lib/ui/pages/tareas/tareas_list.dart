import 'package:flutter/material.dart';
import 'tareas_add.dart';

class TareasPage extends StatefulWidget {
  final List<Map<String, dynamic>> tareas; //Map para incluir el tipo y cantidad
  final Function(Map<String, dynamic>) onTareaAdd;

  const TareasPage({Key? key, required this.tareas, required this.onTareaAdd})
      : super(key: key);

  @override
  _TareasPageState createState() => _TareasPageState();
}

class _TareasPageState extends State<TareasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Tareas"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final nuevaTarea = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddTareaPage()),
              );

              if (nuevaTarea != null) {
                widget.onTareaAdd(nuevaTarea); // Agregar nueva tarea a la lista
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tareas",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: widget.tareas.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(widget.tareas[index]['titulo']),
                      subtitle: Text(
                        widget.tareas[index]['tipo'] +
                            (widget.tareas[index]['tipo'] == 'cuantificable'
                                ? ' - Cantidad: ${widget.tareas[index]['cantidad']}'
                                : ''),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.check_circle_outline),
                        onPressed: () {
                          // Acción de completar tarea
                          _completeTarea(index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _completeTarea(int index) {
    setState(() {
      widget.tareas.removeAt(index); // Eliminar la tarea al completar
    });
  }
}
