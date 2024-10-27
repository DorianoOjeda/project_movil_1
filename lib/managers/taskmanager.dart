import 'package:intl/intl.dart';
import 'package:project_1/managers/rachasmanager.dart';

class TaskManager {
  TaskManager._privateConstructor();

  RachasManager rachasManager = RachasManager();

  static final TaskManager instance = TaskManager._privateConstructor();

  List<Map<String, dynamic>> listOfTask = [];

  List<Map<String, dynamic>> getTareas() {
    return listOfTask;
  }

  int getSuperRacha() {
    return rachasManager.getSuperRachaNumber();
  }

  void addToList(Map<String, dynamic> tarea) {
    listOfTask.add(tarea);
    // Verificamos si todas las tareas del día están completadas después de agregar una nueva
    List<Map<String, dynamic>> tareasDelDia = getTareasDelDia(DateTime.now());
    rachasManager.verificarSuperracha(tareasDelDia);
  }

  List<Map<String, dynamic>> getTareasDelDia(DateTime fecha) {
    print(listOfTask);
    return listOfTask.where((tarea) {
      DateTime tareaFormat = DateTime.parse(tarea['fechaInicio']);

      if (isSameDay(tareaFormat, fecha)) {
        return true;
      }

      if (tarea['frecuencia'] == 'Diariamente') {
        tarea['completada'] = false;
        tarea['cantidadProgreso'] = 0;
        return true;
      }

      bool esDiaValido = false;

      String dayOfTask = DateFormat('EEEE').format(tareaFormat);
      String dayOfToday = DateFormat('EEEE').format(fecha);

      if (tarea['frecuencia'] == 'Semanalmente' && dayOfTask == dayOfToday) {
        tarea['completada'] = false;
        esDiaValido = true;
        tarea['cantidadProgreso'] = 0;
      }

      if (tarea['frecuencia'] == 'Mensualmente') {
        int day = tareaFormat.day;

        if (day == 31 && [4, 6, 9, 11].contains(fecha.month)) {
          day = 30;
        }
        if (day == 31 && fecha.month == 2) {
          if (fecha.year % 4 == 0) {
            day = 29;
          } else {
            day = 28;
          }
        }
        if (day == fecha.day) {
          tarea['completada'] = false;
          esDiaValido = true;
          tarea['cantidadProgreso'] = 0;
        }
      }

      return esDiaValido;
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
      required bool completada,
      required int racha}) {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'tipo': tipo,
      'cantidad': cantidad,
      'cantidadProgreso': cantidadProgreso,
      'frecuencia': frecuencia,
      'fechaInicio': fechaInicio,
      'completada': completada,
      'racha': racha,
    };
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
    rachasManager.actualizarRachaTarea(tarea, true);

    // Verifica si se debe activar la superracha después de marcar como completada
    List<Map<String, dynamic>> tareasDelDia = getTareasDelDia(DateTime.now());
    rachasManager.verificarSuperracha(tareasDelDia);
    return tarea;
  }

  Map<String, dynamic> incrementarCantidadProgreso(
      Map<String, dynamic> tarea, int cantidad) {
    if (tarea['completada']) return tarea;
    if (tarea['cantidadProgreso'] < tarea['cantidad']) {
      tarea['cantidadProgreso'] += cantidad;
      if (tarea['cantidadProgreso'] == tarea['cantidad']) {
        tarea = marcarTareaComoCompletada(tarea);
      }
      return tarea;
    }
    tarea['cantidadProgreso'] = tarea['cantidad'];
    return tarea;
  }

  Map<String, dynamic> decrementarCantidadProgreso(
      Map<String, dynamic> tarea, int cantidad) {
    if (tarea['completada']) return tarea;
    tarea['cantidadProgreso'] -= cantidad;
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
}
