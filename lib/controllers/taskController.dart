import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_1/controllers/rachascontroller.dart';
import 'package:project_1/entities/tarea.dart';
import 'package:provider/provider.dart';

class TaskController extends ChangeNotifier {
  TaskController._privateConstructor();
  static final TaskController instance = TaskController._privateConstructor();

  bool _isSameDay = false;

  final List<Tarea> _listOfTask = [];
  List<Tarea> _tareasDelDia = [];
  List<Tarea> _tareasDelDiaSelected = []; // To use in calendar

  List<Tarea> get listOfTask => _listOfTask;
  List<Tarea> get tareasDelDia => _tareasDelDia;
  List<Tarea> get tareasDelDiaSelected => _tareasDelDiaSelected;

  UnmodifiableListView<Tarea> get listOfTaskUnmodifiable =>
      UnmodifiableListView(_listOfTask);
  UnmodifiableListView<Tarea> get tareasDelDiaUnmodifiable =>
      UnmodifiableListView(_tareasDelDia);
  UnmodifiableListView<Tarea> get tareasDelDiaSelectedUnmodifiable =>
      UnmodifiableListView(_tareasDelDiaSelected);

  void addToList(Tarea tarea) {
    _listOfTask.add(tarea);
    if (tarea.fechaInicio == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
      _isSameDay = true;
      _tareasDelDia.add(tarea);
      notifyListeners();
    }
  }

  void createTareasDelDia(DateTime fecha, bool? isCalendar) {
    List<Tarea> t = _listOfTask.where((tarea) {
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

    if (isCalendar != null && isCalendar) {
      _tareasDelDiaSelected = t;
    } else {
      _tareasDelDia = t;
    }
  }

  void createTareasByDate(DateTime fecha) {
    createTareasDelDia(fecha, true);
  }

  void createNewTarea({
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
    addToList(Tarea(
      titulo: titulo,
      descripcion: descripcion,
      tipo: tipo,
      cantidad: cantidad,
      cantidadProgreso: cantidadProgreso,
      frecuencia: frecuencia,
      fechaInicio: fechaInicio,
      completada: completada,
      racha: racha,
    ));
  }

  void marcarTareaComoCompletada(Tarea tarea, BuildContext context) {
    tarea.completada = true;
    tarea.racha = tarea.racha! + 1;
    Provider.of<RachasController>(context, listen: false)
        .verificarSuperracha(_listOfTask, _isSameDay);
    notifyListeners();
  }

  void incrementarCantidadProgreso(
      Tarea tarea, int cantidad, BuildContext context) {
    if (tarea.cantidadProgreso! < tarea.cantidad!) {
      tarea.cantidadProgreso = tarea.cantidadProgreso! + cantidad;
      if (tarea.cantidadProgreso == tarea.cantidad) {
        marcarTareaComoCompletada(tarea, context);
      }
    }
    if (tarea.cantidadProgreso! >= tarea.cantidad!) {
      tarea.cantidadProgreso = tarea.cantidad;
    }
    notifyListeners();
  }

  void decrementarCantidadProgreso(Tarea tarea, int cantidad) {
    tarea.cantidadProgreso = tarea.cantidadProgreso! - cantidad;
    if (tarea.cantidadProgreso! < 0) {
      tarea.cantidadProgreso = 0;
    }
    notifyListeners();
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool isDairyTaskEmpty() {
    return _tareasDelDia.isEmpty;
  }

  void restartTareasDelDia(context) {
    bool isAllCompleted =
        _tareasDelDia.every((tarea) => tarea.completada == true);
    if (!isAllCompleted) {
      Provider.of<RachasController>(context, listen: false)
          .setSuperracha(false);
      Provider.of<RachasController>(context, listen: false).resetSuperracha();
      for (var tarea in _tareasDelDia) {
        if (!tarea.completada) {
          tarea.racha = 0;
        }
      }
    } else {
      Provider.of<RachasController>(context, listen: false).setSuperracha(true);
    }
    _tareasDelDia.removeRange(0, _tareasDelDia.length);
    _isSameDay = false;
    notifyListeners();
  }
}
