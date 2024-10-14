class RachasManager {
  static void actualizarRacha(Map<String, dynamic> tarea, bool completadaHoy) {
    if (completadaHoy) {
      tarea['racha'] = (tarea['racha'] ?? 0) + 1;
    }
  }
}
