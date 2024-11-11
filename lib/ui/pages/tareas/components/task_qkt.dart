import 'package:flutter/material.dart';
import 'package:project_1/managers/handler.dart';
import 'package:project_1/controllers/taskcontroller.dart';
import 'package:project_1/models/tarea.dart';
import 'package:provider/provider.dart';

class TaskQkt extends StatefulWidget {
  final Tarea tarea;
  const TaskQkt({super.key, required this.tarea});
  @override
  State<TaskQkt> createState() => _TaskQktState();
}

class _TaskQktState extends State<TaskQkt> {
  @override
  Widget build(BuildContext context) {
    Tarea tarea = widget.tarea;
    final int cantidadMaxima = tarea.cantidad ?? 1;

    return Container(
      margin: const EdgeInsets.only(right: 5, left: 5),
      padding: const EdgeInsets.only(top: 15, bottom: 15, left: 25, right: 25),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 73, 68, 102),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  tarea.titulo,
                  maxLines: 1,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (!tarea.completada) ...[
                if (tarea.racha != null && tarea.racha! > 0)
                  Row(
                    children: [
                      getRachaImage(tarea.racha!, 25, 25,
                          completada: tarea.completada),
                      const SizedBox(width: 5),
                      Text(
                        tarea.racha.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove,
                            size: 17, color: Colors.white),
                        onPressed: () {
                          Provider.of<TaskController>(context, listen: false)
                              .decrementarCantidadProgreso(tarea, 1);
                        },
                      ),
                      Container(
                        height: 20,
                        width: 1,
                        color: Colors.white,
                      ),
                      IconButton(
                        icon: const Icon(Icons.add,
                            size: 17, color: Colors.white),
                        onPressed: () {
                          if (tarea.cantidadProgreso! < cantidadMaxima) {
                            Provider.of<TaskController>(context, listen: false)
                                .incrementarCantidadProgreso(tarea, 1, context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ] else ...[
                if (tarea.racha != null && tarea.racha! > 0)
                  Row(
                    children: [
                      Consumer<TaskController>(
                        builder: (context, taskManager, child) {
                          return getRachaImage(tarea.racha!, 25, 25,
                              completada: tarea.completada);
                        },
                      ),
                      const SizedBox(width: 5),
                      Text(
                        tarea.racha.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Icon(Icons.check_circle_sharp, color: Colors.green),
                    ],
                  )
                else
                  const Icon(Icons.check_circle_sharp, color: Colors.green),
              ],
            ],
          ),
          const SizedBox(height: 10),
          if (tarea.frecuencia != "Nunca")
            prederminedText(tarea.frecuencia, 12),
          const SizedBox(height: 5),
          Center(
            child: Column(
              children: [
                LinearProgressIndicator(
                  minHeight: 10,
                  value: cantidadMaxima > 0
                      ? (tarea.cantidadProgreso ?? 0) / cantidadMaxima
                      : 0,
                ),
                prederminedText(
                  "${tarea.cantidadProgreso ?? 0} / ${tarea.cantidad}",
                  13,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
