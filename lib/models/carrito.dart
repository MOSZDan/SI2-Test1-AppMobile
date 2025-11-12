import 'producto.dart';

class ItemCarrito {
  final int id;
  final Producto producto;
  final int cantidad;
  final double precioTotal;

  ItemCarrito({
    required this.id,
    required this.producto,
    required this.cantidad,
    required this.precioTotal,
  });

  factory ItemCarrito.fromJson(Map<String, dynamic> json) {
    return ItemCarrito(
      id: json['id'] as int? ?? 0,
      producto: json['producto'] != null
          ? Producto.fromJson(json['producto'])
          : Producto(
              id: 0,
              nombre: '',
              descripcion: '',
              precio: 0,
              stock: 0,
              categoria: Categoria(id: 0, nombre: 'N/A'),
              fechaCreacion: DateTime.now(),
            ),
      cantidad: json['cantidad'] as int? ?? 1,
      precioTotal: (json['precio_total'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'producto': producto.toJson(),
      'cantidad': cantidad,
      'precio_total': precioTotal,
    };
  }
}

class Carrito {
  final int id;
  final List<ItemCarrito> items;
  final double total;

  Carrito({
    required this.id,
    required this.items,
    required this.total,
  });

  factory Carrito.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List<dynamic>? ?? [];
    return Carrito(
      id: json['id'] as int? ?? 0,
      items: itemsList
          .map((item) => ItemCarrito.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'total': total,
    };
  }
}
