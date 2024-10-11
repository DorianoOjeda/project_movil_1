import 'package:flutter/material.dart';
import 'tareas_add.dart';

class TareasPage extends StatefulWidget {
  final List<Map<String, dynamic>> tareas;
  final Function(Map<String, dynamic>) onTareaAdd;

  TareasPage({required this.tareas, required this.onTareaAdd});

  @override
  _TareasPageState createState() => _TareasPageState();
}

class _TareasPageState extends State<TareasPage> {
  void _marcarTareaCompletada(int index) {
    final tarea = widget.tareas[index];

    if (tarea['tipo'] == 'cuantificable') {
      return; // No permitir completar directamente tareas cuantificables con el check
    }

    // Actualizar el estado de completado de la tarea booleana
    setState(() {
      tarea['completada'] = true;
    });

    // Verificar si la tarea es repetitiva y reprogramarla
    if (tarea['frecuencia'] != 'Nunca') {
      DateTime nuevaFecha = DateTime.parse(tarea['fechaInicio']);
      if (tarea['frecuencia'] == 'Diariamente') {
        nuevaFecha = nuevaFecha.add(Duration(days: 1));
      } else if (tarea['frecuencia'] == 'Semanalmente') {
        nuevaFecha = nuevaFecha.add(Duration(days: 7));
      } else if (tarea['frecuencia'] == 'Mensualmente') {
        nuevaFecha =
            DateTime(nuevaFecha.year, nuevaFecha.month + 1, nuevaFecha.day);
      }

      final nuevaTarea = {
        'titulo': tarea['titulo'],
        'descripcion': tarea['descripcion'],
        'tipo': tarea['tipo'],
        'cantidad': tarea['cantidad'],
        'cantidadProgreso': tarea['cantidadProgreso'],
        'frecuencia': tarea['frecuencia'],
        'fechaInicio': nuevaFecha.toIso8601String(),
        'completada': false,
      };

      widget.onTareaAdd(nuevaTarea);
    }
  }

  void _incrementarCantidad(int index) {
    final tarea = widget.tareas[index];

    setState(() {
      if (tarea['cantidadProgreso'] < tarea['cantidad']) {
        tarea['cantidadProgreso'] = tarea['cantidadProgreso'] + 1;

        // Si la cantidad es alcanzada, marcar como completada
        if (tarea['cantidadProgreso'] >= tarea['cantidad']) {
          tarea['completada'] = true;
        }
      }
    });
  }

  void _disminuirCantidad(int index) {
    final tarea = widget.tareas[index];

    // No permitir disminuir cantidad si ya está completada
    if (!tarea['completada'] && tarea['cantidadProgreso'] > 0) {
      setState(() {
        tarea['cantidadProgreso'] = tarea['cantidadProgreso'] - 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Tareas"),
      ),
      body: ListView.builder(
        itemCount: widget.tareas.length,
        itemBuilder: (context, index) {
          final tarea = widget.tareas[index];

          if (tarea['tipo'] == 'cuantificable') {
            final int cantidadMaxima = tarea['cantidad'] ?? 1;
            final int progresoActual = tarea['cantidadProgreso'] ??
                0; // Inicializar progreso en 0 si es nulo

            return ListTile(
              title: Text(tarea['titulo']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (tarea['descripcion'] != null &&
                      tarea['descripcion'].isNotEmpty)
                    Text(tarea['descripcion']), // Mostrar descripcion si existe
                  Text("Progreso: $progresoActual / $cantidadMaxima"),
                  LinearProgressIndicator(
                    value: cantidadMaxima > 0
                        ? progresoActual / cantidadMaxima
                        : 0,
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          _disminuirCantidad(index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          _incrementarCantidad(index);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              trailing: tarea['completada']
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
            );
          } else {
            // Mostrar las tareas booleanas normales
            return ListTile(
              title: Text(tarea['titulo']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (tarea['descripcion'] != null &&
                      tarea['descripcion'].isNotEmpty)
                    Text(tarea['descripcion']), // Mostrar descripción si existe
                  tarea['completada']
                      ? Text("Completada")
                      : Text("Fecha de inicio: ${tarea['fechaInicio']}"),
                ],
              ),
              trailing: tarea['completada']
                  ? const Icon(Icons.check, color: Colors.green)
                  : IconButton(
                      icon: const Icon(Icons.check_circle),
                      onPressed: () {
                        _marcarTareaCompletada(index);
                      },
                    ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TareasAddPage(
                onSave: (tarea) {
                  tarea['cantidadProgreso'] = 0; // Inicializar progreso en 0
                  widget.onTareaAdd(tarea);
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
