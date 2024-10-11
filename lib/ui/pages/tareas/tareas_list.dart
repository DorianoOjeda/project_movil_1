import 'package:flutter/material.dart';
import 'tareas_add.dart';

class TareasPage extends StatefulWidget {
  final List<Map<String, dynamic>>
      tareas; // Map para incluir descripción y cantidad
  final Function(Map<String, dynamic>) onTareaAdd;

  const TareasPage({Key? key, required this.tareas, required this.onTareaAdd})
      : super(key: key);

  @override
  _TareasPageState createState() => _TareasPageState();
}

class _TareasPageState extends State<TareasPage> {
  Map<int, int> _progresoCuantificables =
      {}; // Para guardar el progreso de tareas cuantificables

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
                  final tarea = widget.tareas[index];
                  final esCuantificable = tarea['tipo'] == 'cuantificable';
                  final cantidad =
                      tarea['cantidad'] ?? 1; // 1 para tareas booleanas
                  final cantidadCompletada =
                      _progresoCuantificables[index] ?? 0;

                  return Card(
                    child: ListTile(
                      title: Text(tarea['titulo']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Mostrar la descripcion de la tarea
                          if (tarea['descripcion'] != null &&
                              tarea['descripcion'].isNotEmpty)
                            Text(
                              tarea['descripcion'],
                              style: const TextStyle(color: Colors.grey),
                            ),
                          const SizedBox(height: 5),
                          // Mostrar progreso solo para tareas cuantificables
                          if (esCuantificable)
                            Column(
                              children: [
                                Text(
                                    'Progreso: $cantidadCompletada / $cantidad'),
                                LinearProgressIndicator(
                                  value: cantidadCompletada / cantidad,
                                ),
                                // Incrementar o decrementar el progreso
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        _actualizarProgreso(index, cantidad, 1);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () {
                                        _actualizarProgreso(
                                            index, cantidad, -1);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        ],
                      ),
                      // completar solo para tareas booleanas
                      trailing: esCuantificable
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.check_circle_outline),
                              onPressed: () {
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

  void _actualizarProgreso(int index, int cantidad, int incremento) {
    setState(() {
      _progresoCuantificables[index] =
          (_progresoCuantificables[index] ?? 0) + incremento;

      if (_progresoCuantificables[index]! >= cantidad) {
        _completeTarea(index);
      } else if (_progresoCuantificables[index]! < 0) {
        _progresoCuantificables[index] = 0;
      }
    });
  }
}
