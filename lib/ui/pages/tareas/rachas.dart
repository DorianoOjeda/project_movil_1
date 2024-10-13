class RachasManager {
  static void actualizarRacha(Map<String, dynamic> tarea, bool completadaHoy) {
    // Incrementar racha solo cuando la tarea es completada hoy
    if (completadaHoy) {
      tarea['racha'] = (tarea['racha'] ?? 0) + 1;
    }
  }
}
