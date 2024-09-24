import 'package:flutter/material.dart';

class TareasPage extends StatelessWidget {
  const TareasPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Lista de Tareas",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Por ahora un numero fijo de tareas
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text("Tarea ${index + 1}"),
                      subtitle: Text("Detalles de la tarea ${index + 1}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.check_circle_outline),
                        onPressed: () {
                          // implemetar completado de tarea
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
}
