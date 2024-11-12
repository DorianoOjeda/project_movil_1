class Tarea {
  String? id;
  String titulo;
  String descripcion;
  String tipo;
  int cantidad;
  int cantidadProgreso;
  String frecuencia;
  String fechaInicio;
  bool completada;
  int racha;

  Tarea(
      {required this.titulo,
      required this.descripcion,
      required this.tipo,
      required this.cantidad,
      required this.cantidadProgreso,
      required this.frecuencia,
      required this.fechaInicio,
      required this.completada,
      required this.racha});

  void setId(String id) {
    this.id = id;
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
      'completada': completada,
      'racha': racha
    };
  }

  factory Tarea.fromMap(Map<String, dynamic> map) {
    return Tarea(
      titulo: map['titulo'],
      descripcion: map['descripcion'],
      tipo: map['tipo'],
      cantidad: map['cantidad'],
      cantidadProgreso: map['cantidadProgreso'],
      frecuencia: map['frecuencia'],
      fechaInicio: map['fechaInicio'],
      completada: map['completada'],
      racha: map['racha'],
    );
  }
}
