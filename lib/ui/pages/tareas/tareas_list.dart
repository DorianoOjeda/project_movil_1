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

    setState(() {
      // Marcar como completada la tarea
      tarea['completada'] = true;

      // Actualizar la racha al completarse
      RachasManager.actualizarRacha(tarea, true);

      // Verificar si la tarea es repetitiva y reprogramarla para la próxima fecha
      if (tarea['frecuencia'] != 'Nunca') {
        DateTime nuevaFecha = RachasManager.calcularSiguienteFecha(tarea);
        tarea['fechaInicio'] = nuevaFecha.toIso8601String();
      }
    });
  }

  void _incrementarCantidad(int index) {
    final tarea = widget.tareas[index];

    setState(() {
      if (tarea['cantidadProgreso'] < tarea['cantidad']) {
        tarea['cantidadProgreso'] += 1;

        // Si la cantidad es alcanzada, marcar como completada
        if (tarea['cantidadProgreso'] >= tarea['cantidad']) {
          tarea['completada'] = true;

          // Actualizar la racha al completarse
          RachasManager.actualizarRacha(tarea, true);

          // Verificar si la tarea es repetitiva y reprogramarla
          if (tarea['frecuencia'] != 'Nunca') {
            DateTime nuevaFecha = RachasManager.calcularSiguienteFecha(tarea);
            tarea['fechaInicio'] = nuevaFecha.toIso8601String();
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
        tarea['cantidadProgreso'] -= 1;
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
          today.add(Duration(days: 7 - today.weekday)); // Próxima semana
      return DateFormat('yyyy-MM-dd').format(proximaFecha);
    } else if (frecuencia == 'Mensualmente') {
      proximaFecha =
          DateTime(today.year, today.month + 1, fechaInicio.day); // Próximo mes
      return DateFormat('yyyy-MM-dd').format(proximaFecha);
    } else {
      return DateFormat('yyyy-MM-dd').format(fechaInicio);
    }
  }

  bool _mostrarTareaHoy(DateTime fechaInicio, String frecuencia) {
    DateTime today = DateTime.now();

    // Mostrar la tarea incluso si ha sido completada
    if (today.isBefore(fechaInicio)) {
      return false; // No mostrar tareas antes de la fecha de inicio
    }

    if (frecuencia == 'Diariamente') {
      return today.difference(fechaInicio).inDays % 1 == 0; // Diaria
    } else if (frecuencia == 'Semanalmente') {
      return today.difference(fechaInicio).inDays % 7 == 0; // Semanal
    } else if (frecuencia == 'Mensualmente') {
      return today.day == fechaInicio.day; // Mensual
    }
    return isSameDay(today, fechaInicio); // Mostrar solo si es el mismo día
  }

  bool _desbloquearTarea(DateTime fechaInicio) {
    DateTime today = DateTime.now();
    return isSameDay(today, fechaInicio); // Desbloquear si es la fecha actual
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
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

          // Determinar si la tarea debe mostrarse hoy
          bool mostrarHoy = _mostrarTareaHoy(fechaInicio, tarea['frecuencia']);
          bool desbloquear = _desbloquearTarea(fechaInicio);

          // Siempre mostrar la tarea, incluso si está completada
          if (!mostrarHoy && !tarea['completada']) return Container();

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
                        onPressed: desbloquear
                            ? () {
                                _incrementarCantidad(index);
                              }
                            : null, // Solo permitir si está desbloqueada
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
                      icon: desbloquear
                          ? const Icon(Icons.check_circle)
                          : const Icon(Icons
                              .lock), // Mostrar bloqueo si no está desbloqueada
                      onPressed: desbloquear
                          ? () {
                              _marcarTareaCompletada(index);
                            }
                          : null, // Solo permitir si está desbloqueada
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
                  tarea['cantidadProgreso'] = 0;
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
