import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario.dart';
import 'api_service.dart';

class AuthService {
  static const String _baseUrl = 'https://smartosaresu.onrender.com/api';

  // LOGIN: POST /usuarios/login/
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        '$_baseUrl/usuarios/login/',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        // Guardar token y email en SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', data['token'] ?? data['access_token'] ?? '');
        await prefs.setString('user_email', email);
        
        // Configurar email en ApiService
        ApiService.setUserEmail(email);
        
        return data;
      } else {
        throw Exception('Credenciales inválidas');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Email o contraseña incorrectos');
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  // REGISTER: POST /usuarios/register/
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String nombre,
    required String apellido,
  }) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        '$_baseUrl/usuarios/register/',
        data: {
          'email': email,
          'password': password,
          'nombre': nombre,
          'apellido': apellido,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error al registrar usuario');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('El email ya está registrado');
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  // LOGOUT
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_email');
    ApiService.clearUserEmail();
  }

  // Verificar si el usuario está autenticado
  static Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token != null && token.isNotEmpty;
  }

  // Obtener el token guardado
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

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
