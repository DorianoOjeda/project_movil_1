import 'package:project_1/models/tarea.dart';

class RachasManager {
  int superracha = 0;
  bool tieneSuperracha = false;

  void actualizarRachaTarea(Tarea tarea, bool completadaHoy) {
    if (completadaHoy) {
      tarea.racha = (tarea.racha ?? 0) + 1;
    }
  }

  // Método para verificar y activar la superracha
  void verificarSuperracha(List<Tarea> tareasDelDia) {
    bool todasCompletadas =
        tareasDelDia.every((tarea) => tarea.completada == true);

    if (todasCompletadas) {
      if (!tieneSuperracha) {
        tieneSuperracha = true;
        superracha = 1;
      } else {
        superracha++;
      }
    } else {
      // Si no todas las tareas están completadas, reiniciamos la superracha
      tieneSuperracha = false;
    }
  }

  void verificarTareasDelDiaAnterior(List<Tarea> tareasDelDiaAnterior) {
    bool todasCompletadas =
        tareasDelDiaAnterior.every((tarea) => tarea.completada == true);

    if (todasCompletadas && !tieneSuperracha) {
      tieneSuperracha = true;
      superracha = 1;
    } else if (todasCompletadas) {
      superracha++;
    }
  }

  int getSuperRachaNumber() {
    return superracha;
  }
}
