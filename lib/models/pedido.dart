import 'producto.dart';

class Pedido {
  final int id;
  final String numero;
  final DateTime fecha;
  final double total;
  final String estado;
  final String metodoPago;
  final String direccionEnvio;
  final List<ItemPedido> items;
  final DateTime? fechaEntrega;

  Pedido({
    required this.id,
    required this.numero,
    required this.fecha,
    required this.total,
    required this.estado,
    required this.metodoPago,
    required this.direccionEnvio,
    required this.items,
    this.fechaEntrega,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List<dynamic>? ?? [];
    return Pedido(
      id: json['id'] as int? ?? 0,
      numero: json['numero'] as String? ?? '',
      fecha: json['fecha'] != null ? DateTime.parse(json['fecha']) : DateTime.now(),
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      estado: json['estado'] as String? ?? 'PENDIENTE',
      metodoPago: json['metodo_pago'] as String? ?? '',
      direccionEnvio: json['direccion_envio'] as String? ?? '',
      items: itemsList
          .map((item) => ItemPedido.fromJson(item as Map<String, dynamic>))
          .toList(),
      fechaEntrega: json['fecha_entrega'] != null
          ? DateTime.parse(json['fecha_entrega'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numero': numero,
      'fecha': fecha.toIso8601String(),
      'total': total,
      'estado': estado,
      'metodo_pago': metodoPago,
      'direccion_envio': direccionEnvio,
      'items': items.map((item) => item.toJson()).toList(),
      'fecha_entrega': fechaEntrega?.toIso8601String(),
    };
  }
}

class ItemPedido {
  final int id;
  final Producto producto;
  final int cantidad;
  final double precioUnitario;
  final double precioTotal;

  ItemPedido({
    required this.id,
    required this.producto,
    required this.cantidad,
    required this.precioUnitario,
    required this.precioTotal,
  });

  factory ItemPedido.fromJson(Map<String, dynamic> json) {
    return ItemPedido(
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
      precioUnitario: (json['precio_unitario'] as num?)?.toDouble() ?? 0.0,
      precioTotal: (json['precio_total'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'producto': producto.toJson(),
      'cantidad': cantidad,
      'precio_unitario': precioUnitario,
      'precio_total': precioTotal,
    };
  }
}
