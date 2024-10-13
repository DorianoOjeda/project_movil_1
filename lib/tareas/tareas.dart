class Tarea {
  String titulo;
  String descripcion;
  String tipo;
  int cantidad;
  int cantidadProgreso;
  String frecuencia;
  String fechaInicio;
  String fechaSiguiente;
  bool completada;

  Tarea({
    required this.titulo,
    required this.descripcion,
    required this.tipo,
    required this.cantidad,
    required this.cantidadProgreso,
    required this.frecuencia,
    required this.fechaInicio,
    required this.fechaSiguiente,
    required this.completada,
  });

  factory Tarea.fromMap(Map<String, dynamic> map) {
    return Tarea(
      titulo: map['titulo'],
      descripcion: map['descripcion'],
      tipo: map['tipo'],
      cantidad: map['cantidad'],
      cantidadProgreso: map['cantidadProgreso'],
      frecuencia: map['frecuencia'],
      fechaInicio: map['fechaInicio'],
      fechaSiguiente: map['fechaSiguiente'],
      completada: map['completada'],
    );
  }

  Map<String, dynamic> toMap() {
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
}
