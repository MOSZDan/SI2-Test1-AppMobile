import 'package:dio/dio.dart';
import '../models/usuario.dart';
import 'api_service.dart';

class UsuarioService {
  // GET /usuarios/
  static Future<List<Usuario>> getUsuarios() async {
    try {
      final response = await ApiService.get('/usuarios/');

      if (response.statusCode == 200) {
        List<dynamic> data = response.data is List ? response.data : [];
        return data
            .map((item) => Usuario.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Error al obtener usuarios');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  // POST /usuarios/
  static Future<Usuario> crearUsuario(Map<String, dynamic> data) async {
    try {
      final response = await ApiService.post('/usuarios/', data: data);

      if (response.statusCode == 201) {
        return Usuario.fromJson(response.data);
      } else {
        throw Exception('Error al crear usuario');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  // PUT /usuarios/{id}/
  static Future<Usuario> actualizarUsuario(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await ApiService.put('/usuarios/$id/', data: data);

      if (response.statusCode == 200) {
        return Usuario.fromJson(response.data);
      } else {
        throw Exception('Error al actualizar usuario');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  // DELETE /usuarios/{id}/
  static Future<void> eliminarUsuario(int id) async {
    try {
      final response = await ApiService.delete('/usuarios/$id/');

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Error al eliminar usuario');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  // GET /roles/
  static Future<List<Rol>> getRoles() async {
    try {
      final response = await ApiService.get('/roles/');

      if (response.statusCode == 200) {
        List<dynamic> data = response.data is List ? response.data : [];
        return data
            .map((item) => Rol.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Error al obtener roles');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  // POST /usuarios/{id}/cambiar_rol/
  static Future<void> cambiarRol(int usuarioId, int rolId) async {
    try {
      final response = await ApiService.post(
        '/usuarios/$usuarioId/cambiar_rol/',
        data: {
          'rol_id': rolId,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Error al cambiar rol');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }
}
