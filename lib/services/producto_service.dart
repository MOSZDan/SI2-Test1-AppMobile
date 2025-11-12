import 'package:dio/dio.dart';
import '../models/producto.dart';
import 'api_service.dart';

class ProductoService {
  // GET /productos/
  static Future<List<Producto>> getProductos({
    int? categoriaId,
    String? busqueda,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (categoriaId != null) {
        queryParameters['categoria'] = categoriaId;
      }
      if (busqueda != null && busqueda.isNotEmpty) {
        queryParameters['busqueda'] = busqueda;
      }

      final response =
          await ApiService.get('/productos/', queryParameters: queryParameters);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data is List ? response.data : [];
        return data
            .map((item) => Producto.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Error al obtener productos');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  // GET /productos/dashboard/
  static Future<Map<String, dynamic>> getDashboard({
    String? busqueda,
    int? categoriaId,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (categoriaId != null) {
        queryParameters['categoria'] = categoriaId;
      }
      if (busqueda != null && busqueda.isNotEmpty) {
        queryParameters['busqueda'] = busqueda;
      }

      final response = await ApiService.get(
        '/productos/dashboard/',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Error al obtener dashboard');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  // POST /productos/
  static Future<Producto> crearProducto(Map<String, dynamic> data) async {
    try {
      final response = await ApiService.post('/productos/', data: data);

      if (response.statusCode == 201) {
        return Producto.fromJson(response.data);
      } else {
        throw Exception('Error al crear producto');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  // PUT /productos/{id}/
  static Future<Producto> actualizarProducto(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await ApiService.put('/productos/$id/', data: data);

      if (response.statusCode == 200) {
        return Producto.fromJson(response.data);
      } else {
        throw Exception('Error al actualizar producto');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  // DELETE /productos/{id}/
  static Future<void> eliminarProducto(int id) async {
    try {
      final response = await ApiService.delete('/productos/$id/');

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Error al eliminar producto');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  // GET /categorias/
  static Future<List<Categoria>> getCategorias() async {
    try {
      final response = await ApiService.get('/categorias/');

      if (response.statusCode == 200) {
        List<dynamic> data = response.data is List ? response.data : [];
        return data
            .map((item) => Categoria.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Error al obtener categorías');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  // POST /categorias/
  static Future<Categoria> crearCategoria(Map<String, dynamic> data) async {
    try {
      final response = await ApiService.post('/categorias/', data: data);

      if (response.statusCode == 201) {
        return Categoria.fromJson(response.data);
      } else {
        throw Exception('Error al crear categoría');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  // PUT /categorias/{id}/
  static Future<Categoria> actualizarCategoria(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await ApiService.put('/categorias/$id/', data: data);

      if (response.statusCode == 200) {
        return Categoria.fromJson(response.data);
      } else {
        throw Exception('Error al actualizar categoría');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  // DELETE /categorias/{id}/
  static Future<void> eliminarCategoria(int id) async {
    try {
      final response = await ApiService.delete('/categorias/$id/');

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Error al eliminar categoría');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }
}
