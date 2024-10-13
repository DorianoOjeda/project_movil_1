import 'package:intl/intl.dart';
import 'package:project_1/ui/pages/tareas/rachas.dart';

class TaskManager {
  TaskManager._privateConstructor();

  static final TaskManager instance = TaskManager._privateConstructor();

  List<Map<String, dynamic>> listOfTask = [];

  List<Map<String, dynamic>> getTareas() {
    return listOfTask;
  }

  void addToList(Map<String, dynamic> tarea) {
    listOfTask.add(tarea);
  }

  List<Map<String, dynamic>> getTareasDelDia() {
    DateTime today = DateTime.now();
    return listOfTask.where((tarea) {
      return isSameDay(DateTime.parse(tarea['fechaInicio']), today) ||
          isSameDay(DateTime.parse(tarea['fechaSiguiente']), today);
    }).toList();
  }

  Map<String, dynamic> createNewTarea(
      {required String titulo,
      required String descripcion,
      required String tipo,
      required int? cantidad,
      required int? cantidadProgreso,
      required String frecuencia,
      required String fechaInicio,
      required String? fechaSiguiente,
      required bool completada}) {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'tipo': tipo,
      'cantidad': cantidad,
      'cantidadProgreso': cantidadProgreso,
      'frecuencia': frecuencia,
      'fechaInicio': fechaInicio,
      'fechaSiguiente': fechaSiguiente,
      'completada': completada,
    };
  }

  Map<String, dynamic> setFechaSiguiente(Map<String, dynamic> tarea) {
    DateTime fechaSiguiente = DateTime.parse(tarea['fechaInicio']);
    String frecuencia = tarea['frecuencia'];

    if (frecuencia == 'Diariamente') {
      fechaSiguiente = fechaSiguiente.add(const Duration(days: 1));
    } else if (frecuencia == 'Semanalmente') {
      fechaSiguiente = fechaSiguiente.add(const Duration(days: 7));
    } else if (frecuencia == 'Mensualmente') {
      int year = fechaSiguiente.year;
      int month = fechaSiguiente.month + 1;

      if (month > 12) {
        month = 1;
        year += 1;
      }

      int day = fechaSiguiente.day;
      int lastDayOfMonth = DateTime(year, month + 1, 0)
          .day; // Día 0 del siguiente mes es el último día del mes actual

      // Si el día original no existe en el nuevo mes, establece el último día del mes
      day = (day > lastDayOfMonth) ? lastDayOfMonth : day;
      fechaSiguiente = DateTime(year, month, day);
    }

    tarea['fechaSiguiente'] = DateFormat('yyyy-MM-dd').format(fechaSiguiente);
    return tarea;
  }

  String getFechaSiguiente(Map<String, dynamic> tarea) {
    if (tarea['fechaSiguiente'] == null) {
      return "No hay fecha siguiente";
    } else if (isSameDay(DateTime.parse(tarea['fechaSiguiente']),
        DateTime.now().add(const Duration(days: 1)))) {
      return "Mañana";
    }
    return tarea['fechaSiguiente'];
  }

  Map<String, dynamic> marcarTareaComoCompletada(Map<String, dynamic> tarea) {
    tarea['completada'] = true;
    RachasManager.actualizarRacha(tarea, true);
    if (tarea['frecuencia'] != 'Nunca') {
      tarea = setFechaSiguiente(tarea);
    }
    return tarea;
  }

  Map<String, dynamic> incrementarCantidadProgreso(
      Map<String, dynamic> tarea, int cantidad) {
    if (tarea['completada']) {
      return tarea;
    }
    if (tarea['cantidadProgreso'] < tarea['cantidad']) {
      tarea['cantidadProgreso'] = tarea['cantidadProgreso'] + cantidad;
      return tarea;
    }
    tarea['cantidadProgreso'] = tarea['cantidad'];
    tarea = marcarTareaComoCompletada(tarea);
    return tarea;
  }

  Map<String, dynamic> decrementarCantidadProgreso(
      Map<String, dynamic> tarea, int cantidad) {
    if (tarea['completada']) {
      return tarea;
    }
    tarea['cantidadProgreso'] = tarea['cantidadProgreso'] - cantidad;
    if (tarea['cantidadProgreso'] < 0) {
      tarea['cantidadProgreso'] = 0;
    }
    return tarea;
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool desbloquearTarea(DateTime fechaInicio, DateTime fechaSiguiente) {
    DateTime today = DateTime.now();
    return (isSameDay(today, fechaInicio) || isSameDay(today, fechaSiguiente));
  }

  bool mostrarTarea(DateTime fechaInicio, DateTime fechaSiguiente) {
    DateTime today = DateTime.now();
    if (today.isBefore(fechaInicio)) {
      return false;
    }
    return (isSameDay(today, fechaInicio) || isSameDay(today, fechaSiguiente));
  }
}
