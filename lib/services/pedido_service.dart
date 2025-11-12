import 'package:dio/dio.dart';
import '../models/pedido.dart';
import 'api_service.dart';

class PedidoService {
  // GET /pedidos/mis-pedidos/
  static Future<List<Pedido>> getMisPedidos() async {
    try {
      final response = await ApiService.get('/pedidos/mis-pedidos/');

      if (response.statusCode == 200) {
        List<dynamic> data = response.data is List ? response.data : [];
        return data
            .map((item) => Pedido.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Error al obtener pedidos');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  // POST /pedidos/create-checkout-session/
  static Future<Map<String, dynamic>> crearCheckoutSession({
    required List<Map<String, dynamic>> items,
    required String direccionEnvio,
  }) async {
    try {
      final response = await ApiService.post(
        '/pedidos/create-checkout-session/',
        data: {
          'items': items,
          'direccion_envio': direccionEnvio,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Error al crear sesión de pago');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  // GET /pedidos/historial-ventas/
  static Future<List<Pedido>> getHistorialVentas({
    DateTime? fechaInicio,
    DateTime? fechaFin,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (fechaInicio != null) {
        queryParameters['fecha_inicio'] = fechaInicio.toIso8601String();
      }
      if (fechaFin != null) {
        queryParameters['fecha_fin'] = fechaFin.toIso8601String();
      }

      final response = await ApiService.get(
        '/pedidos/historial-ventas/',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data is List ? response.data : [];
        return data
            .map((item) => Pedido.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Error al obtener historial');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  // GET /pedidos/pedidos-pendientes/
  static Future<List<Pedido>> getPedidosPendientes() async {
    try {
      final response = await ApiService.get('/pedidos/pedidos-pendientes/');

      if (response.statusCode == 200) {
        List<dynamic> data = response.data is List ? response.data : [];
        return data
            .map((item) => Pedido.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Error al obtener pedidos pendientes');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }
}
