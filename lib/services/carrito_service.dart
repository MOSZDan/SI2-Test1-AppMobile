import 'package:dio/dio.dart';
import '../models/carrito.dart';
import 'api_service.dart';

class CarritoService {
  // GET /carrito/mi_carrito/
  static Future<Carrito> getCarrito() async {
    try {
      final response = await ApiService.get('/carrito/mi_carrito/');

      if (response.statusCode == 200) {
        return Carrito.fromJson(response.data);
      } else {
        throw Exception('Error al obtener carrito');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  // POST /carrito/agregar_item/
  static Future<void> agregarItem({
    required int productoId,
    required int cantidad,
  }) async {
    try {
      final response = await ApiService.post(
        '/carrito/agregar_item/',
        data: {
          'producto_id': productoId,
          'cantidad': cantidad,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Error al agregar item');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  // PUT /carrito/{id}/actualizar_item/
  static Future<void> actualizarItem(int itemId, int cantidad) async {
    try {
      final response = await ApiService.put(
        '/carrito/$itemId/actualizar_item/',
        data: {
          'cantidad': cantidad,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Error al actualizar item');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  // DELETE /carrito/{id}/eliminar_item/
  static Future<void> eliminarItem(int itemId) async {
    try {
      final response = await ApiService.delete('/carrito/$itemId/eliminar_item/');

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Error al eliminar item');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  // POST /carrito/vaciar_carrito/
  static Future<void> vaciarCarrito() async {
    try {
      final response = await ApiService.post('/carrito/vaciar_carrito/');

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Error al vaciar carrito');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }
}
