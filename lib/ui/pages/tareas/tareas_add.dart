import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TareasAddPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const TareasAddPage({required this.onSave, Key? key}) : super(key: key);

  @override
  _TareasAddPageState createState() => _TareasAddPageState();
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

            // Tipo de tarea
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

            // Repeticion de la tarea
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

            // Guardar la tarea
            ElevatedButton(
              onPressed: () {
                if (_tituloController.text.isEmpty) return;

                // Crear nueva tarea
                final nuevaTarea = {
                  'titulo': _tituloController.text,
                  'descripcion': _descripcionController.text,
                  'tipo': _esBooleana ? 'booleano' : 'cuantificable',
                  'cantidad': _esBooleana
                      ? null
                      : int.tryParse(_cantidadController.text) ??
                          1, // Cantidad minima 1 para cuantificable
                  'cantidadProgreso': _esBooleana
                      ? null
                      : 0, // Progreso inicial en 0 para cuantificables
                  'frecuencia': _frecuenciaRepeticion,
                  'fechaInicio': DateFormat('yyyy-MM-dd').format(_fechaInicio),
                  'completada': false,
                };

                widget.onSave(nuevaTarea);
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
