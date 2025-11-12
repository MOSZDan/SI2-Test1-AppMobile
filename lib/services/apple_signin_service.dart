import 'package:dio/dio.dart';

class AppleSignInService {
  static const String _baseUrl = 'https://smartosaresu.onrender.com/api';

  // Simulamos Apple Sign-In ya que requiere setup nativo
  // En producción, usarías sign_in_with_apple package
  static Future<Map<String, dynamic>> signInWithApple(String identityToken) async {
    try {
      final response = await Dio().post(
        '$_baseUrl/usuarios/apple-signin/',
        data: {'identity_token': identityToken},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error en Apple Sign-In: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de red: ${e.message}');
    }
  }

  // Método para obtener el token de Apple (mock)
  static Future<String> getAppleIdentityToken() async {
    // En producción, aquí usarías:
    // final credential = await SignInWithApple.getAppleIDCredential(...);
    // return credential.identityToken;
    
    // Para desarrollo, retornamos un mock token
    await Future.delayed(Duration(seconds: 1));
    return 'mock_apple_identity_token_${DateTime.now().millisecondsSinceEpoch}';
  }

  // Método para logout de Apple
  static Future<void> signOutApple() async {
    try {
      // En producción:
      // SignInWithApple.performRequests([AppleIDRequest()]) ya no es necesario al logout
      
      // Para desarrollo, solo esperamos
      await Future.delayed(Duration(milliseconds: 500));
    } catch (e) {
      throw Exception('Error al cerrar sesión Apple: $e');
    }
  }

  // Verificar si Apple Sign-In está disponible (solo iOS/macOS)
  static Future<bool> isAppleSignInAvailable() async {
    try {
      // En producción:
      // return await SignInWithApple.isAvailable();
      
      // Retornamos true en iOS/macOS, false en Android
      return true; // Para desarrollo, siempre disponible
    } catch (e) {
      return false;
    }
  }

  // Obtener perfil del usuario de Apple
  static Future<Map<String, String?>> getAppleUserProfile() async {
    try {
      // En producción:
      // final credential = await SignInWithApple.getAppleIDCredential(...);
      // return {
      //   'nombre': credential.givenName + ' ' + credential.familyName,
      //   'email': credential.email,
      //   'foto': null,
      // };

      return {
        'nombre': 'Usuario Apple',
        'email': 'usuario@icloud.com',
        'foto': null,
      };
    } catch (e) {
      throw Exception('Error al obtener perfil: $e');
    }
  }

  // Revocar credenciales de Apple
  static Future<void> revokeAppleCredentials(String identityToken) async {
    try {
      // En producción:
      // await Dio().post(
      //   'https://appleid.apple.com/auth/revoke',
      //   data: {'token': identityToken},
      // );

      await Future.delayed(Duration(milliseconds: 500));
    } catch (e) {
      throw Exception('Error al revocar credenciales: $e');
    }
  }
}
