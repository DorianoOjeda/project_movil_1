class RachasManager {
  static void actualizarRacha(Map<String, dynamic> tarea, bool completadaHoy) {
    // Incrementar racha solo cuando la tarea es completada hoy
    if (completadaHoy) {
      tarea['racha'] = (tarea['racha'] ?? 0) + 1;
    }
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  static DateTime calcularSiguienteFecha(Map<String, dynamic> tarea) {
    DateTime fechaInicio = DateTime.parse(tarea['fechaInicio']);
    if (tarea['frecuencia'] == 'Diariamente') {
      return fechaInicio.add(Duration(days: 1));
    } else if (tarea['frecuencia'] == 'Semanalmente') {
      return fechaInicio.add(Duration(days: 7));
    } else if (tarea['frecuencia'] == 'Mensualmente') {
      return DateTime(fechaInicio.year, fechaInicio.month + 1, fechaInicio.day);
    }
    return fechaInicio; // Si no es repetitiva, retornar la fecha original
  }
}
