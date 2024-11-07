import 'package:intl/intl.dart';
import 'package:project_1/managers/rachasmanager.dart';
import 'package:project_1/models/tarea.dart';

class TaskManager {
  TaskManager._privateConstructor();

  RachasManager rachasManager = RachasManager();

  static final TaskManager instance = TaskManager._privateConstructor();

  List<Tarea> _listOfTask = [];

  List<Tarea> getTareas() {
    return _listOfTask;
  }

  int getSuperRacha() {
    return rachasManager.getSuperRachaNumber();
  }

  void addToList(Tarea tarea) {
    _listOfTask.add(tarea);
    // Verificamos si todas las tareas del día están completadas después de agregar una nueva
    List<Tarea> tareasDelDia = getTareasDelDia(DateTime.now());
    rachasManager.verificarSuperracha(tareasDelDia.toList());
  }

  List<Tarea> getTareasDelDia(DateTime fecha) {
    print(_listOfTask);
    return _listOfTask.where((tarea) {
      DateTime tareaFormat = DateTime.parse(tarea.fechaInicio);

      if (isSameDay(tareaFormat, fecha)) {
        return true;
      }

      if (tarea.frecuencia == 'Diariamente') {
        tarea.completada = false;
        tarea.cantidadProgreso = 0;
        return true;
      }

      bool esDiaValido = false;

      String dayOfTask = DateFormat('EEEE').format(tareaFormat);
      String dayOfToday = DateFormat('EEEE').format(fecha);

      if (tarea.frecuencia == 'Semanalmente' && dayOfTask == dayOfToday) {
        tarea.completada = false;
        esDiaValido = true;
        tarea.cantidadProgreso = 0;
      }

      if (tarea.frecuencia == 'Mensualmente') {
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
          tarea.completada = false;
          esDiaValido = true;
          tarea.cantidadProgreso = 0;
        }
      }

      return esDiaValido;
    }).toList();
  }

  Tarea createNewTarea({
    required String titulo,
    required String descripcion,
    required String tipo,
    required int? cantidad,
    required int? cantidadProgreso,
    required String frecuencia,
    required String fechaInicio,
    required bool completada,
    required int racha,
  }) {
    return Tarea(
      titulo: titulo,
      descripcion: descripcion,
      tipo: tipo,
      cantidad: cantidad,
      cantidadProgreso: cantidadProgreso,
      frecuencia: frecuencia,
      fechaInicio: fechaInicio,
      completada: completada,
      racha: racha,
    );
  }

  Tarea marcarTareaComoCompletada(Tarea tarea) {
    tarea.completada = true;
    rachasManager.actualizarRachaTarea(tarea, true);

    // Verifica si se debe activar la superracha después de marcar como completada
    List<Tarea> tareasDelDia = getTareasDelDia(DateTime.now());
    rachasManager.verificarSuperracha(tareasDelDia.toList());
    return tarea;
  }

  Tarea incrementarCantidadProgreso(Tarea tarea, int cantidad) {
    if (tarea.completada) return tarea;
    if (tarea.cantidadProgreso! < tarea.cantidad!) {
      tarea.cantidadProgreso = tarea.cantidadProgreso! + cantidad;
      if (tarea.cantidadProgreso == tarea.cantidad) {
        tarea = marcarTareaComoCompletada(tarea);
      }
    }
    if (tarea.cantidadProgreso! >= tarea.cantidad!) {
      tarea.cantidadProgreso = tarea.cantidad;
    }
    return tarea;
  }

  Tarea decrementarCantidadProgreso(Tarea tarea, int cantidad) {
    if (tarea.completada) return tarea;
    tarea.cantidadProgreso = tarea.cantidadProgreso! - cantidad;
    if (tarea.cantidadProgreso! < 0) {
      tarea.cantidadProgreso = 0;
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
    return today.isBefore(fechaInicio)
        ? false
        : (isSameDay(today, fechaInicio) || isSameDay(today, fechaSiguiente));
  }
}
