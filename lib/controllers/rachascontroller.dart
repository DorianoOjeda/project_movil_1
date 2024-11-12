import 'package:flutter/material.dart';
import 'package:project_1/entities/tarea.dart';

class RachasController extends ChangeNotifier {
  RachasController._privateConstructor();
  static final RachasController instance =
      RachasController._privateConstructor();

  int _superracha = 0;

  int get superRachaNumber => _superracha;

  bool _tieneSuperracha = false;

  // Método para verificar y activar la superracha
  void verificarSuperracha(List<Tarea> tareasDelDia, bool isSameDay) {
    bool todasCompletadas =
        tareasDelDia.every((tarea) => tarea.completada == true);

    if (todasCompletadas) {
      if (!_tieneSuperracha) {
        _superracha = 1;
      } else if (!isSameDay) {
        _superracha++;
      }
    }
    notifyListeners();
  }

  void setSuperracha(bool value) {
    _tieneSuperracha = value;
    notifyListeners();
  }

  void resetSuperracha() {
    _superracha = 0;
    notifyListeners();
  }
}
