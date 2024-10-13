import 'package:flutter/material.dart';
import 'package:project_1/managers/taskmanager.dart';
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
        DateTime fechaInicio = DateTime.parse(tarea['fechaInicio']);
        DateTime fechaSiguiente = DateTime.parse(tarea['fechaSiguiente']);

        // Determinar si la tarea debe mostrarse hoy
        bool mostrarHoy =
            TaskManager.instance.mostrarTarea(fechaInicio, fechaSiguiente);
        bool desbloquear =
            TaskManager.instance.desbloquearTarea(fechaInicio, fechaSiguiente);

        // Siempre mostrar la tarea, incluso si está completada
        if (!mostrarHoy && !tarea['completada']) return Container();

        final String descripcion = tarea['descripcion'];
        if (tarea['tipo'] == 'cuantificable') {
          final int cantidadMaxima = tarea['cantidad'];
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
              borderRadius: BorderRadius.circular(5),
            ),
            child: ListTile(
              title: prederminedText(tarea['titulo'], 16),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (descripcion.isNotEmpty) Text(tarea['descripcion']),
                  Text(
                      "Progreso: $tarea['cantidadProgreso'] / $cantidadMaxima"),
                  Text("Fecha siguiente: $tarea['fechaSiguiente']"),
                  LinearProgressIndicator(
                    value: cantidadMaxima > 0
                        ? tarea['cantidadProgreso'] / cantidadMaxima
                        : 0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              tarea = TaskManager.instance
                                  .decrementarCantidadProgreso(tarea, 1);
                            });
                          },
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                          ),
                          width: 50,
                          alignment: Alignment.center,
                          child: Text(tarea['cantidadProgreso'].toString()),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: desbloquear
                              ? () {
                                  setState(() {
                                    tarea = TaskManager.instance
                                        .incrementarCantidadProgreso(tarea, 1);
                                  });
                                }
                              : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              trailing: tarea['completada']
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
            ),
          );
        } else {
          // Mostrar las tareas booleanas normales
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
              borderRadius: BorderRadius.circular(5),
            ),
            child: ListTile(
              title: prederminedText(tarea['titulo'], 16),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (descripcion.isNotEmpty) prederminedText(descripcion, 12),
                  prederminedText("${tarea['frecuencia']}", 12),
                  if (tarea["fechaSiguiente"] != null)
                    prederminedText(
                        'Fecha siguiente: ${TaskManager.instance.getFechaSiguiente(tarea)}',
                        12),
                  prederminedText("Racha: ${tarea['racha'] ?? 0} días", 10)
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
                              if (tarea['tipo'] == 'booleano') {
                                setState(() {
                                  tarea = TaskManager.instance
                                      .marcarTareaComoCompletada(tarea);
                                });
                              }
                            }
                          : null, // Solo permitir si está desbloqueada
                    ),
            ),
          );
        }
      },
    );
  }
}
