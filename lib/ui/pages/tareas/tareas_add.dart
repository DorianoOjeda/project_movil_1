import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_1/managers/taskmanager.dart';

class TareasAddPage extends StatefulWidget {
  const TareasAddPage({super.key});
  @override
  State<TareasAddPage> createState() => _TareasAddPageState();
}

class _TareasAddPageState extends State<TareasAddPage> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _cantidadController =
      TextEditingController(); // Controlador para la cantidad
  bool _esBooleana = true;
  String _frecuenciaRepeticion = 'Nunca';
  DateTime _fechaInicio = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Nueva Tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título de la tarea',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descripcionController,
              maxLength: 250,
              decoration: const InputDecoration(
                labelText: 'Descripción (opcional, máximo 250 caracteres)',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tipo de tarea:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: _esBooleana ? 'Booleana' : 'Cuantificable',
                  onChanged: (String? newValue) {
                    setState(() {
                      _esBooleana = newValue == 'Booleana';
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                        value: 'Booleana', child: Text('Booleana')),
                    DropdownMenuItem(
                        value: 'Cuantificable', child: Text('Cuantificable')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Repetir tarea:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: _frecuenciaRepeticion,
                  onChanged: (String? newValue) {
                    setState(() {
                      _frecuenciaRepeticion = newValue ?? 'Nunca';
                    });
                  },
                  items: const [
                    DropdownMenuItem(value: 'Nunca', child: Text('Nunca')),
                    DropdownMenuItem(
                        value: 'Diariamente', child: Text('Diariamente')),
                    DropdownMenuItem(
                        value: 'Semanalmente', child: Text('Semanalmente')),
                    DropdownMenuItem(
                        value: 'Mensualmente', child: Text('Mensualmente')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Campo para la cantidad
            if (!_esBooleana)
              TextField(
                controller: _cantidadController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Cantidad (requerida para tareas cuantificables)',
                ),
              ),
            const SizedBox(height: 20),
            // Selector de fecha
            Row(
              children: [
                const Text("Fecha de inicio: "),
                TextButton(
                  onPressed: _selectFechaInicio,
                  child: Text(DateFormat('yyyy-MM-dd').format(_fechaInicio)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_tituloController.text.isEmpty) return;
                Map<String, dynamic> nuevaTarea =
                    TaskManager.instance.createNewTarea(
                  titulo: _tituloController.text,
                  descripcion: _descripcionController.text.isEmpty
                      ? ''
                      : _descripcionController.text,
                  tipo: _esBooleana ? 'booleano' : 'cuantificable',
                  cantidad: _esBooleana
                      ? null
                      : int.tryParse(_cantidadController.text) ??
                          1, // Cantidad minima 1 para cuantificable
                  cantidadProgreso: _esBooleana
                      ? null
                      : 0, // Progreso inicial en 0 para cuantificables
                  frecuencia: _frecuenciaRepeticion,
                  fechaInicio: DateFormat('yyyy-MM-dd').format(_fechaInicio),
                  fechaSiguiente: null,
                  completada: false,
                );
                nuevaTarea = TaskManager.instance.setFechaSiguiente(nuevaTarea);
                TaskManager.instance.addToList(nuevaTarea);
                print(nuevaTarea);
                print("Tareas: ");
                print(TaskManager.instance.getTareas());
                Navigator.pop(context);
              },
              child: const Text("Guardar Tarea"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectFechaInicio() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaInicio,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _fechaInicio) {
      setState(() {
        _fechaInicio = picked;
      });
    }
  }
}
