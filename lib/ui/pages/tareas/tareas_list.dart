import 'package:flutter/material.dart';
import 'tareas_add.dart';

class TareasPage extends StatefulWidget {
  const TareasPage({Key? key}) : super(key: key);

  @override
  _TareasPageState createState() => _TareasPageState();
}

class _TareasPageState extends State<TareasPage> {
  List<Map<String, dynamic>> tareas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tareas Diarias"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navegar a la pagina de agregar nueva tarea
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddTareaPage()),
              ).then((nuevaTarea) {
                if (nuevaTarea != null) {
                  setState(() {
                    tareas.add(nuevaTarea);
                  });
                }
              });
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
              "Lista de Tareas",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: tareas.isEmpty
                  ? const Center(child: Text("No hay tareas"))
                  : ListView.builder(
                      itemCount: tareas.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(tareas[index]['titulo']),
                            subtitle: Text(tareas[index]['tipo'] == 'booleano'
                                ? "Tarea booleana"
                                : "Cantidad a realizar: ${tareas[index]['cantidad']}"),
                            trailing: IconButton(
                              icon: const Icon(Icons.check_circle_outline),
                              onPressed: () {
                                // Completar tarea
                                setState(() {
                                  tareas.removeAt(index);
                                });
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
