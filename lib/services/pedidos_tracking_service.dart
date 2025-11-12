import 'package:dio/dio.dart';

class PedidosTrackingService {
  static const String _baseUrl = 'https://smartosaresu.onrender.com/api';
  static const String _endpoint = '/pedidos-tracking';

  // Obtener tracking de un pedido
  static Future<Map<String, dynamic>> obtenerTracking(String pedidoId) async {
    try {
      final response = await Dio().get(
        '$_baseUrl$_endpoint/$pedidoId/',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        // Mock data para desarrollo
        return _getMockTracking(pedidoId);
      }
    } on DioException {
      // Retornar mock data en caso de error
      return _getMockTracking(pedidoId);
    }
  }

  // Obtener eventos de tracking
  static Future<List<Map<String, dynamic>>> obtenerEventos(
      String pedidoId) async {
    try {
      final response = await Dio().get(
        '$_baseUrl$_endpoint/$pedidoId/eventos/',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        if (response.data is List) {
          return List<Map<String, dynamic>>.from(response.data);
        } else if (response.data is Map && response.data['eventos'] != null) {
          return List<Map<String, dynamic>>.from(response.data['eventos']);
        }
        return [];
      } else {
        return _getMockEventos();
      }
    } on DioException {
      return _getMockEventos();
    }
  }

  // Actualizar estado del pedido
  static Future<Map<String, dynamic>> actualizarEstado({
    required String pedidoId,
    required String nuevoEstado,
    String? descripcion,
    String? ubicacion,
  }) async {
    try {
      final response = await Dio().put(
        '$_baseUrl$_endpoint/$pedidoId/estado/',
        data: {
          'estado': nuevoEstado,
          'descripcion': descripcion,
          'ubicacion': ubicacion,
          'fecha_actualizacion': DateTime.now().toIso8601String(),
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error al actualizar estado: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de red: ${e.message}');
    }
  }

  // Obtener ubicación actual del pedido
  static Future<Map<String, dynamic>> obtenerUbicacion(
      String pedidoId) async {
    try {
      final response = await Dio().get(
        '$_baseUrl$_endpoint/$pedidoId/ubicacion/',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        // Mock location
        return {
          'latitud': 12.1156,
          'longitud': -86.2362,
          'ciudad': 'San Salvador',
          'estado': 'En tránsito',
          'fecha_actualizacion': DateTime.now().toIso8601String(),
        };
      }
    } on DioException {
      // Mock location en caso de error
      return {
        'latitud': 12.1156,
        'longitud': -86.2362,
        'ciudad': 'San Salvador',
        'estado': 'En tránsito',
        'fecha_actualizacion': DateTime.now().toIso8601String(),
      };
    }
  }

  // Obtener información del transportista
  static Future<Map<String, dynamic>> obtenerTransportista(
      String pedidoId) async {
    try {
      final response = await Dio().get(
        '$_baseUrl$_endpoint/$pedidoId/transportista/',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        return _getMockTransportista();
      }
    } on DioException {
      return _getMockTransportista();
    }
  }

  // Notificar retraso en entrega
  static Future<void> notificarRetraso(
      String pedidoId, String razon) async {
    try {
      final response = await Dio().post(
        '$_baseUrl$_endpoint/$pedidoId/retraso/',
        data: {
          'razon': razon,
          'fecha': DateTime.now().toIso8601String(),
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Error al notificar retraso: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de red: ${e.message}');
    }
  }

  // Confirmar entrega
  static Future<Map<String, dynamic>> confirmarEntrega({
    required String pedidoId,
    String? firmaBase64,
    String? foto,
  }) async {
    try {
      final response = await Dio().post(
        '$_baseUrl$_endpoint/$pedidoId/confirmar-entrega/',
        data: {
          'firma': firmaBase64,
          'foto': foto,
          'fecha_entrega': DateTime.now().toIso8601String(),
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Error al confirmar entrega: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de red: ${e.message}');
    }
  }

  // ============= Mock Data para desarrollo =============

  static Map<String, dynamic> _getMockTracking(String pedidoId) {
    return {
      'id': pedidoId,
      'estado': 'En tránsito',
      'fecha_creacion': DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
      'fecha_estimada_entrega': DateTime.now().add(Duration(days: 1)).toIso8601String(),
      'fecha_entrega_actual': null,
      'direccion': '123 Calle Principal, San Salvador',
      'codigo_seguimiento': 'TRACK-${DateTime.now().millisecondsSinceEpoch}',
      'transportista': _getMockTransportista(),
      'eventos': _getMockEventos(),
    };
  }

  static List<Map<String, dynamic>> _getMockEventos() {
    final ahora = DateTime.now();
    return [
      {
        'id': '1',
        'estado': 'Entregado',
        'descripcion': 'Paquete entregado exitosamente',
        'fecha': ahora.toIso8601String(),
        'ubicacion': 'San Salvador, SV',
        'icono': 'check_circle',
      },
      {
        'id': '2',
        'estado': 'En tránsito',
        'descripcion': 'Paquete en ruta hacia destino',
        'fecha': ahora.subtract(Duration(hours: 2)).toIso8601String(),
        'ubicacion': 'En camino',
        'icono': 'local_shipping',
      },
      {
        'id': '3',
        'estado': 'Procesado',
        'descripcion': 'Paquete procesado en centro de distribución',
        'fecha': ahora.subtract(Duration(days: 1)).toIso8601String(),
        'ubicacion': 'Centro de distribución',
        'icono': 'inventory_2',
      },
      {
        'id': '4',
        'estado': 'Confirmado',
        'descripcion': 'Pedido confirmado',
        'fecha': ahora.subtract(Duration(days: 2)).toIso8601String(),
        'ubicacion': 'Sistema',
        'icono': 'thumb_up',
      },
    ];
  }

  static Map<String, dynamic> _getMockTransportista() {
    return {
      'id': '1',
      'nombre': 'Juan Pérez',
      'empresa': 'Transportes Rápidos SA',
      'telefono': '+503 7777-1234',
      'placa': 'P-123456',
      'disponible': true,
      'calificacion': 4.8,
      'foto': null,
    };
  }

  // Calcular progreso de entrega (0.0 a 1.0)
  static double calcularProgreso(List<Map<String, dynamic>> eventos) {
    const etapasTotal = 4;
    return eventos.length / etapasTotal;
  }

  // Obtener color según estado
  static int getColorEstado(String estado) {
    switch (estado) {
      case 'Entregado':
        return 0xFF4CAF50; // Green
      case 'En tránsito':
        return 0xFF2196F3; // Blue
      case 'Procesado':
        return 0xFF2196F3; // Blue
      case 'Confirmado':
        return 0xFF9C27B0; // Purple
      case 'Cancelado':
        return 0xFFf44336; // Red
      default:
        return 0xFF757575; // Grey
    }
  }

  // Obtener icono según estado
  static String getIconoEstado(String estado) {
    switch (estado) {
      case 'Entregado':
        return 'check_circle';
      case 'En tránsito':
        return 'local_shipping';
      case 'Procesado':
        return 'inventory_2';
      case 'Confirmado':
        return 'thumb_up';
      case 'Cancelado':
        return 'cancel';
      default:
        return 'info';
    }
  }
}
