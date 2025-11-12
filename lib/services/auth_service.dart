import 'package:dio/dio.dart';
import '../models/usuario.dart';
import 'api_service.dart';

class AuthService {
  // POST /sync-stack-auth/
  static Future<Usuario> syncStackAuth({
    required String stackUserId,
    required String email,
    required String displayName,
  }) async {
    try {
      final response = await ApiService.post(
        '/sync-stack-auth/',
        data: {
          'stack_user_id': stackUserId,
          'email': email,
          'display_name': displayName,
          'nombre': displayName.split(' ').first,
          'apellido': displayName.split(' ').skip(1).join(' '),
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Usuario.fromJson(response.data);
      } else {
        throw Exception('Error al sincronizar usuario: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  // GET /usuarios/{id}/
  static Future<Usuario> getUsuario(int id) async {
    try {
      final response = await ApiService.get('/usuarios/$id/');
      if (response.statusCode == 200) {
        return Usuario.fromJson(response.data);
      } else {
        throw Exception('Error al obtener usuario');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }
}
