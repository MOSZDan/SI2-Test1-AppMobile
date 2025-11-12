class Notificacion {
  final int id;
  final String titulo;
  final String mensaje;
  final String tipo;
  final bool leida;
  final DateTime fecha;
  final String? enlace;

  Notificacion({
    required this.id,
    required this.titulo,
    required this.mensaje,
    required this.tipo,
    required this.leida,
    required this.fecha,
    this.enlace,
  });

  factory Notificacion.fromJson(Map<String, dynamic> json) {
    return Notificacion(
      id: json['id'] as int? ?? 0,
      titulo: json['titulo'] as String? ?? '',
      mensaje: json['mensaje'] as String? ?? '',
      tipo: json['tipo'] as String? ?? 'general',
      leida: json['leida'] as bool? ?? false,
      fecha: json['fecha'] != null ? DateTime.parse(json['fecha']) : DateTime.now(),
      enlace: json['enlace'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'mensaje': mensaje,
      'tipo': tipo,
      'leida': leida,
      'fecha': fecha.toIso8601String(),
      'enlace': enlace,
    };
  }
}
