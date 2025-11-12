class Rol {
  final int id;
  final String descripcion;

  Rol({
    required this.id,
    required this.descripcion,
  });

  factory Rol.fromJson(Map<String, dynamic> json) {
    return Rol(
      id: json['id'] as int? ?? 0,
      descripcion: json['descripcion'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descripcion': descripcion,
    };
  }
}

class Usuario {
  final int codigo;
  final String nombre;
  final String apellido;
  final String email;
  final String? telefono;
  final String? direccion;
  final String? sexo;
  final Rol? rol;
  final DateTime fechaRegistro;

  Usuario({
    required this.codigo,
    required this.nombre,
    required this.apellido,
    required this.email,
    this.telefono,
    this.direccion,
    this.sexo,
    this.rol,
    required this.fechaRegistro,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      codigo: json['codigo'] as int? ?? 0,
      nombre: json['nombre'] as String? ?? '',
      apellido: json['apellido'] as String? ?? '',
      email: json['email'] as String? ?? '',
      telefono: json['telefono'] as String?,
      direccion: json['direccion'] as String?,
      sexo: json['sexo'] as String?,
      rol: json['rol'] != null ? Rol.fromJson(json['rol']) : null,
      fechaRegistro: json['fecha_registro'] != null
          ? DateTime.parse(json['fecha_registro'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codigo': codigo,
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'telefono': telefono,
      'direccion': direccion,
      'sexo': sexo,
      'rol': rol?.toJson(),
      'fecha_registro': fechaRegistro.toIso8601String(),
    };
  }

  String get nombreCompleto => '$nombre $apellido';
}
