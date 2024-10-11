import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTareaPage extends StatefulWidget {
  const AddTareaPage({Key? key}) : super(key: key);

  @override
  _AddTareaPageState createState() => _AddTareaPageState();
}

class _AddTareaPageState extends State<AddTareaPage> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  bool _esBooleana = true;
  final TextEditingController _cantidadController = TextEditingController();
  String _frecuenciaRepeticion = 'Nunca'; // Nueva variable para la frecuencia
  DateTime _fechaInicio = DateTime.now(); // Fecha actual

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

            // Descripción de la tarea
            TextField(
              controller: _descripcionController,
              maxLength: 250,
              decoration: const InputDecoration(
                  labelText: 'Descripción (opcional, máximo 250 caracteres)'),
              maxLines: 3,
            ),
            const SizedBox(height: 20),

            // Selector de tipo de tarea
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

            // Si la tarea es cuantificable
            if (!_esBooleana)
              TextField(
                controller: _cantidadController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Cantidad a realizar'),
              ),
            const SizedBox(height: 20),

            // Selector de frecuencia de repetición
            const Text("Repetir tarea: "),
            DropdownButton<String>(
              value: _frecuenciaRepeticion,
              onChanged: (String? newValue) {
                setState(() {
                  _frecuenciaRepeticion = newValue!;
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
                      : int.tryParse(_cantidadController.text) ?? 1,
                  'frecuencia': _frecuenciaRepeticion,
                  'fechaInicio': DateFormat('yyyy-MM-dd').format(_fechaInicio),
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
