import 'package:flutter/material.dart';
import 'package:project_1/managers/handler.dart';
import 'package:project_1/controllers/taskcontroller.dart';
import 'package:project_1/entities/tarea.dart';
import 'package:provider/provider.dart';

class TaskBool extends StatefulWidget {
  final Tarea tarea;
  const TaskBool({super.key, required this.tarea});
  @override
  State<TaskBool> createState() => _TaskBoolState();
}

class _TaskBoolState extends State<TaskBool> {
  @override
  Widget build(BuildContext context) {
    Tarea tarea = widget.tarea;
    bool isNonRepeating = tarea.frecuencia == "Nunca";

    return Container(
      margin: const EdgeInsets.only(right: 5, left: 5),
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 15),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 73, 68, 102),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: ListTile(
        title: Row(
          children: [
            Text(
              tarea.titulo,
              maxLines: 1,
              style: const TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
        subtitle: isNonRepeating ? null : prederminedText(tarea.frecuencia, 12),
        trailing: SizedBox(
          width: 88,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              tarea.racha == 0 || tarea.frecuencia == "Nunca"
                  ? Container()
                  : Row(
                      children: [
                        Consumer<TaskController>(
                          builder: (context, taskManager, child) {
                            return getRachaImage(tarea.racha, 25, 25,
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
                      ],
                    ),
              tarea.completada
                  ? const Padding(
                      padding: EdgeInsets.only(left: 18.0),
                      child:
                          Icon(Icons.check_circle_sharp, color: Colors.green),
                    )
                  : IconButton(
                      icon: const Icon(
                        Icons.check_circle,
                        color: Color.fromARGB(255, 165, 165, 165),
                      ),
                      onPressed: () {
                        Provider.of<TaskController>(context, listen: false)
                            .marcarTareaComoCompletada(tarea, context);
                      },
                      constraints:
                          const BoxConstraints(maxWidth: 18, maxHeight: 40),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
