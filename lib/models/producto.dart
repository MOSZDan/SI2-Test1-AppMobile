class Categoria {
  final int id;
  final String nombre;
  final String? descripcion;
  final DateTime? fechaCreacion;

  Categoria({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.fechaCreacion,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'] as int? ?? 0,
      nombre: json['nombre'] as String? ?? '',
      descripcion: json['descripcion'] as String?,
      fechaCreacion: json['fecha_creacion'] != null
          ? DateTime.parse(json['fecha_creacion'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'fecha_creacion': fechaCreacion?.toIso8601String(),
    };
  }
}

class Producto {
  final int id;
  final String nombre;
  final String descripcion;
  final double precio;
  final int stock;
  final String? imagen;
  final Categoria categoria;
  final DateTime fechaCreacion;

  Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.stock,
    this.imagen,
    required this.categoria,
    required this.fechaCreacion,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'] as int? ?? 0,
      nombre: json['nombre'] as String? ?? '',
      descripcion: json['descripcion'] as String? ?? '',
      precio: (json['precio'] as num?)?.toDouble() ?? 0.0,
      stock: json['stock'] as int? ?? 0,
      imagen: json['imagen'] as String?,
      categoria: json['categoria'] != null
          ? Categoria.fromJson(json['categoria'])
          : Categoria(id: 0, nombre: 'Sin categoría'),
      fechaCreacion: json['fecha_creacion'] != null
          ? DateTime.parse(json['fecha_creacion'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'stock': stock,
      'imagen': imagen,
      'categoria': categoria.toJson(),
      'fecha_creacion': fechaCreacion.toIso8601String(),
    };
  }
}
