import 'package:dio/dio.dart';

class ResenaService {
  static const String _baseUrl = 'https://smartosaresu.onrender.com/api';
  static const String _endpoint = '/resenas';

  // Crear una nueva reseña
  static Future<Map<String, dynamic>> crearResena({
    required int productoId,
    required String clienteId,
    required int calificacion, // 1-5 stars
    required String titulo,
    required String comentario,
  }) async {
    try {
      final response = await Dio().post(
        '$_baseUrl$_endpoint/',
        data: {
          'producto_id': productoId,
          'cliente_id': clienteId,
          'calificacion': calificacion,
          'titulo': titulo,
          'comentario': comentario,
          'fecha_creacion': DateTime.now().toIso8601String(),
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error al crear reseña: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de red: ${e.message}');
    }
  }

  // Obtener todas las reseñas de un producto
  static Future<List<Map<String, dynamic>>> obtenerResenas(
      int productoId) async {
    try {
      final response = await Dio().get(
        '$_baseUrl$_endpoint/?producto_id=$productoId',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        if (response.data is List) {
          return List<Map<String, dynamic>>.from(response.data);
        } else if (response.data is Map && response.data['results'] != null) {
          return List<Map<String, dynamic>>.from(response.data['results']);
        } else {
          return [];
        }
      } else {
        throw Exception('Error al obtener reseñas: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de red: ${e.message}');
    }
  }

  // Obtener reseñas paginadas
  static Future<Map<String, dynamic>> obtenerResenasPaginadas({
    required int productoId,
    required int pagina,
    int porPagina = 10,
  }) async {
    try {
      final skip = (pagina - 1) * porPagina;
      final response = await Dio().get(
        '$_baseUrl$_endpoint/?producto_id=$productoId&skip=$skip&limit=$porPagina',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data ?? {'results': [], 'total': 0};
      } else {
        throw Exception('Error al obtener reseñas: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de red: ${e.message}');
    }
  }

  // Obtener una reseña específica
  static Future<Map<String, dynamic>> obtenerResena(int resenaId) async {
    try {
      final response = await Dio().get(
        '$_baseUrl$_endpoint/$resenaId/',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error al obtener reseña: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de red: ${e.message}');
    }
  }

  // Actualizar una reseña
  static Future<Map<String, dynamic>> actualizarResena({
    required int resenaId,
    int? calificacion,
    String? titulo,
    String? comentario,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (calificacion != null) data['calificacion'] = calificacion;
      if (titulo != null) data['titulo'] = titulo;
      if (comentario != null) data['comentario'] = comentario;
      data['fecha_actualizacion'] = DateTime.now().toIso8601String();

      final response = await Dio().put(
        '$_baseUrl$_endpoint/$resenaId/',
        data: data,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error al actualizar reseña: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de red: ${e.message}');
    }
  }

  // Eliminar una reseña
  static Future<void> eliminarResena(int resenaId) async {
    try {
      final response = await Dio().delete(
        '$_baseUrl$_endpoint/$resenaId/',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Error al eliminar reseña: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de red: ${e.message}');
    }
  }

  // Obtener estadísticas de reseñas para un producto
  static Future<Map<String, dynamic>> obtenerEstadisticasResenas(
      int productoId) async {
    try {
      final response = await Dio().get(
        '$_baseUrl$_endpoint/estadisticas/$productoId/',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        // Mock data si el endpoint no existe
        return {
          'promedio': 4.5,
          'total': 0,
          'distribucion': {
            '5': 0,
            '4': 0,
            '3': 0,
            '2': 0,
            '1': 0,
          },
        };
      }
    } on DioException catch (e) {
      throw Exception('Error de red: ${e.message}');
    }
  }

  // Marcar reseña como útil
  static Future<void> marcarResenaComoUtil(int resenaId) async {
    try {
      final response = await Dio().post(
        '$_baseUrl$_endpoint/$resenaId/util/',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Error al marcar como útil: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de red: ${e.message}');
    }
  }

  // Filtrar reseñas por calificación
  static List<Map<String, dynamic>> filtrarPorCalificacion(
    List<Map<String, dynamic>> resenas,
    int calificacion,
  ) {
    return resenas
        .where((r) => r['calificacion'] == calificacion)
        .toList();
  }

  // Ordenar reseñas (más recientes primero)
  static List<Map<String, dynamic>> ordenarPorFecha(
    List<Map<String, dynamic>> resenas, {
    bool descendente = true,
  }) {
    final sorted = List<Map<String, dynamic>>.from(resenas);
    sorted.sort((a, b) {
      final fechaA = DateTime.parse(a['fecha_creacion'] ?? '');
      final fechaB = DateTime.parse(b['fecha_creacion'] ?? '');
      return descendente
          ? fechaB.compareTo(fechaA)
          : fechaA.compareTo(fechaB);
    });
    return sorted;
  }

  // Calcular promedio de calificación
  static double calcularPromedio(
      List<Map<String, dynamic>> resenas) {
    if (resenas.isEmpty) return 0;
    final suma = resenas
        .fold<int>(0, (sum, r) => sum + (r['calificacion'] as int? ?? 0));
    return suma / resenas.length;
  }
}
