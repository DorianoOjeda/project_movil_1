import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'tareas_add.dart';
import 'rachas.dart'; // Importamos el archivo de rachas

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

      // Actualizar la racha al completarse
      RachasManager.actualizarRacha(tarea, true);

      // Verificar si la tarea es repetitiva y reprogramarla
      if (tarea['frecuencia'] != 'Nunca') {
        DateTime nuevaFecha = RachasManager.calcularSiguienteFecha(tarea);
        tarea['fechaInicio'] = nuevaFecha.toIso8601String();
        tarea['completada'] = false; // Resetear para la próxima aparición
      }
    });
  }

  void _incrementarCantidad(int index) {
    final tarea = widget.tareas[index];

    setState(() {
      if (tarea['cantidadProgreso'] < tarea['cantidad']) {
        tarea['cantidadProgreso'] = tarea['cantidadProgreso'] + 1;

        // Si la cantidad es alcanzada, marcar como completada
        if (tarea['cantidadProgreso'] >= tarea['cantidad']) {
          tarea['completada'] = true;

          // Actualizar la racha al completarse
          RachasManager.actualizarRacha(tarea, true);

          // Verificar si la tarea es repetitiva y reprogramarla
          if (tarea['frecuencia'] != 'Nunca') {
            DateTime nuevaFecha = RachasManager.calcularSiguienteFecha(tarea);
            tarea['fechaInicio'] = nuevaFecha.toIso8601String();
            tarea['completada'] = false; // Resetear para la próxima aparición
          }
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

  String _getFechaSiguiente(DateTime fechaInicio, String frecuencia) {
    DateTime today = DateTime.now();
    DateTime proximaFecha;

    if (frecuencia == 'Diariamente') {
      proximaFecha = today.add(Duration(days: 1));
      return "Mañana";
    } else if (frecuencia == 'Semanalmente') {
      proximaFecha =
          today.add(Duration(days: 7 - today.weekday)); // Proxima semana
      return DateFormat('yyyy-MM-dd').format(proximaFecha);
    } else if (frecuencia == 'Mensualmente') {
      proximaFecha =
          DateTime(today.year, today.month + 1, fechaInicio.day); // Proximo mes
      return DateFormat('yyyy-MM-dd').format(proximaFecha);
    } else {
      return DateFormat('yyyy-MM-dd').format(fechaInicio);
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
          DateTime fechaInicio = DateTime.parse(tarea['fechaInicio']);
          String fechaSiguiente =
              _getFechaSiguiente(fechaInicio, tarea['frecuencia']);

          if (tarea['tipo'] == 'cuantificable') {
            final int cantidadMaxima = tarea['cantidad'] ?? 1;
            final int progresoActual = tarea['cantidadProgreso'] ?? 0;

            return ListTile(
              title: Text(tarea['titulo']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (tarea['descripcion'] != null &&
                      tarea['descripcion'].isNotEmpty)
                    Text(tarea['descripcion']),
                  Text("Progreso: $progresoActual / $cantidadMaxima"),
                  Text("Fecha siguiente: $fechaSiguiente"),
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
                    Text(tarea['descripcion']),
                  Text("Repetir: ${tarea['frecuencia']}"),
                  Text("Fecha siguiente: $fechaSiguiente"),
                  Text("Racha: ${tarea['racha'] ?? 0} días"), // Mostrar racha
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
                  tarea['racha'] = 0; // Inicializar racha en 0
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
