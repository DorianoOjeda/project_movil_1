import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:project_1/controllers/taskcontroller.dart';
import 'package:provider/provider.dart';

class TareasAddPage extends StatefulWidget {
  const TareasAddPage({super.key});
  @override
  State<TareasAddPage> createState() => _TareasAddPageState();
}

class _TareasAddPageState extends State<TareasAddPage> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  bool _esBooleana = true;
  String _frecuenciaRepeticion = 'Nunca';
  DateTime _fechaInicio = DateTime.now();
  String? _errorTitulo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text('Nueva Tarea', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20.0, left: 25.0, right: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _tituloController,
              maxLength: 25,
              decoration: InputDecoration(
                labelText: 'Título de la tarea',
                labelStyle: const TextStyle(color: Colors.deepPurple),
                errorText: _errorTitulo,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: const Icon(Icons.title, color: Colors.deepPurple),
              ),
              onChanged: (value) {
                setState(() {
                  _errorTitulo = (value.isEmpty || value.length > 25)
                      ? 'El título debe tener entre 1 y 25 caracteres'
                      : null;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descripcionController,
              maxLength: 250,
              decoration: InputDecoration(
                labelText: 'Descripción (opcional)',
                labelStyle: const TextStyle(color: Colors.deepPurple),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon:
                    const Icon(Icons.description, color: Colors.deepPurple),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tipo de tarea:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                DropdownButton<String>(
                  value: _esBooleana ? 'Booleana' : 'Cuantificable',
                  style: const TextStyle(color: Colors.deepPurple),
                  dropdownColor: Colors.deepPurple[50],
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                DropdownButton<String>(
                  value: _frecuenciaRepeticion,
                  style: const TextStyle(color: Colors.deepPurple),
                  dropdownColor: Colors.deepPurple[50],
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
            if (!_esBooleana)
              TextField(
                controller: _cantidadController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  labelText: 'Cantidad',
                  labelStyle: const TextStyle(color: Colors.deepPurple),
                  errorText: !_esBooleana &&
                          (_cantidadController.text.isEmpty ||
                              int.tryParse(_cantidadController.text) == null)
                      ? 'Ingresa un número válido'
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: const Icon(Icons.confirmation_number,
                      color: Colors.deepPurple),
                ),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Fecha de inicio:',
                  style: TextStyle(fontSize: 16),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.calendar_today,
                      color: Colors.deepPurple),
                  label: Text(
                    DateFormat('yyyy-MM-dd').format(_fechaInicio),
                    style: const TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: _selectFechaInicio,
                ),
              ],
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 15.0),
                ),
                onPressed: _guardarTarea,
                child: const Text(
                  'Guardar Tarea',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _guardarTarea() {
    setState(() {
      if (_tituloController.text.isEmpty ||
          _tituloController.text.length > 25) {
        _errorTitulo = 'El título debe tener entre 1 y 25 caracteres';
        return;
      } else {
        _errorTitulo = null;
      }

      if (!_esBooleana &&
          (_cantidadController.text.isEmpty ||
              int.tryParse(_cantidadController.text) == null)) {
        return;
      }
    });

    if (_errorTitulo != null ||
        (!_esBooleana && int.tryParse(_cantidadController.text) == null)) {
      return;
    }

    Provider.of<TaskController>(context, listen: false).createNewTarea(
      titulo: _tituloController.text,
      descripcion: _descripcionController.text.isEmpty
          ? ''
          : _descripcionController.text,
      tipo: _esBooleana ? 'booleano' : 'cuantificable',
      cantidad: _esBooleana ? 0 : int.parse(_cantidadController.text),
      cantidadProgreso: _esBooleana ? 0 : 0,
      frecuencia: _frecuenciaRepeticion,
      fechaInicio: DateFormat('yyyy-MM-dd').format(_fechaInicio),
      completada: false,
      racha: 0,
    );

    Navigator.pop(context);
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
