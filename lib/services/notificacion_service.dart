import 'package:dio/dio.dart';
import '../models/notificacion.dart';
import 'api_service.dart';

class NotificacionService {
  // GET /notificaciones/
  static Future<List<Notificacion>> getNotificaciones({
    bool? soloNoLeidas,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (soloNoLeidas != null && soloNoLeidas) {
        queryParameters['no_leidas'] = true;
      }

      final response = await ApiService.get(
        '/notificaciones/',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data is List ? response.data : [];
        return data
            .map((item) =>
                Notificacion.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Error al obtener notificaciones');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  // PUT /notificaciones/{id}/ - Marcar como leída
  static Future<void> marcarLeida(int notificacionId) async {
    try {
      final response = await ApiService.put(
        '/notificaciones/$notificacionId/',
        data: {'leida': true},
      );

      if (response.statusCode != 200) {
        throw Exception('Error al marcar como leída');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  // DELETE /notificaciones/{id}/
  static Future<void> eliminarNotificacion(int notificacionId) async {
    try {
      final response = await ApiService.delete('/notificaciones/$notificacionId/');

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Error al eliminar notificación');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  // GET /notificaciones/plantillas/ - Obtener plantillas
  static Future<List<Map<String, dynamic>>> getPlantillas() async {
    try {
      final response = await ApiService.get('/notificaciones/plantillas/');

      if (response.statusCode == 200) {
        List<dynamic> data = response.data is List ? response.data : [];
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Error al obtener plantillas');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  // POST /notificaciones/plantillas/ - Crear plantilla
  static Future<Map<String, dynamic>> crearPlantilla(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await ApiService.post(
        '/notificaciones/plantillas/',
        data: data,
      );

      if (response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Error al crear plantilla');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  // PUT /notificaciones/plantillas/{id}/ - Actualizar plantilla
  static Future<Map<String, dynamic>> actualizarPlantilla(
    int plantillaId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await ApiService.put(
        '/notificaciones/plantillas/$plantillaId/',
        data: data,
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Error al actualizar plantilla');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  // DELETE /notificaciones/plantillas/{id}/ - Eliminar plantilla
  static Future<void> eliminarPlantilla(int plantillaId) async {
    try {
      final response = await ApiService.delete(
        '/notificaciones/plantillas/$plantillaId/',
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Error al eliminar plantilla');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  // GET /notificaciones/envios/ - Obtener envíos
  static Future<List<Map<String, dynamic>>> getEnvios({
    DateTime? fechaInicio,
    DateTime? fechaFin,
    String? tipo,
    String? estado,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (fechaInicio != null) {
        queryParameters['fecha_inicio'] = fechaInicio.toIso8601String();
      }
      if (fechaFin != null) {
        queryParameters['fecha_fin'] = fechaFin.toIso8601String();
      }
      if (tipo != null) {
        queryParameters['tipo'] = tipo;
      }
      if (estado != null) {
        queryParameters['estado'] = estado;
      }

      final response = await ApiService.get(
        '/notificaciones/envios/',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data is List ? response.data : [];
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Error al obtener envíos');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  // GET /usuarios/preferencias-notificaciones/ - Obtener preferencias
  static Future<Map<String, dynamic>> obtenerPreferencias() async {
    try {
      final response = await ApiService.get(
        '/usuarios/preferencias-notificaciones/',
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Error al obtener preferencias');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  // PUT /usuarios/preferencias-notificaciones/ - Actualizar preferencias
  static Future<void> actualizarPreferencias(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await ApiService.put(
        '/usuarios/preferencias-notificaciones/',
        data: data,
      );

      if (response.statusCode != 200) {
        throw Exception('Error al actualizar preferencias');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }
}
