import 'package:flutter/material.dart';

class AddTareaPage extends StatefulWidget {
  const AddTareaPage({Key? key}) : super(key: key);

  @override
  _AddTareaPageState createState() => _AddTareaPageState();
}

class _AddTareaPageState extends State<AddTareaPage> {
  final TextEditingController _tituloController = TextEditingController();
  bool _esBooleana = true;
  final TextEditingController _cantidadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar Nueva Tarea"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _tituloController,
              decoration:
                  const InputDecoration(labelText: 'Título de la tarea'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text("Tipo de tarea: "),
                DropdownButton<bool>(
                  value: _esBooleana,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _esBooleana = newValue!;
                    });
                  },
                  items: const [
                    DropdownMenuItem(value: true, child: Text('Booleana')),
                    DropdownMenuItem(
                        value: false, child: Text('Cuantificable')),
                  ],
                ),
              ],
            ),
            if (!_esBooleana)
              TextField(
                controller: _cantidadController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Cantidad a realizar'),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_tituloController.text.isEmpty) return;

                // Crear nueva tarea
                final nuevaTarea = {
                  'titulo': _tituloController.text,
                  'tipo': _esBooleana ? 'booleano' : 'cuantificable',
                  'cantidad': _esBooleana
                      ? null
                      : int.tryParse(_cantidadController.text) ?? 1,
                };

                Navigator.pop(context, nuevaTarea);
              },
              child: const Text("Guardar Tarea"),
            ),
          ],
        ),
      ),
    );
  }
}
