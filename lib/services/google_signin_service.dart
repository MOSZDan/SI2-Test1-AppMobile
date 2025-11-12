import 'package:dio/dio.dart';

class GoogleSignInService {
  static const String _baseUrl = 'https://smartosaresu.onrender.com/api';

  // Simulamos Google Sign-In ya que requiere setup nativo
  // En producción, usarías google_sign_in package
  static Future<Map<String, dynamic>> signInWithGoogle(String idToken) async {
    try {
      final response = await Dio().post(
        '$_baseUrl/usuarios/google-signin/',
        data: {'id_token': idToken},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error en Google Sign-In: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de red: ${e.message}');
    }
  }

  // Método para obtener el token de Google (mock)
  static Future<String> getGoogleIdToken() async {
    // En producción, aquí usarías:
    // final result = await GoogleSignIn().signIn();
    // return await result?.authentication.idToken;
    
    // Para desarrollo, retornamos un mock token
    await Future.delayed(Duration(seconds: 1));
    return 'mock_google_id_token_${DateTime.now().millisecondsSinceEpoch}';
  }

  // Método para logout de Google
  static Future<void> signOutGoogle() async {
    try {
      // En producción:
      // await GoogleSignIn().signOut();
      
      // Para desarrollo, solo esperamos
      await Future.delayed(Duration(milliseconds: 500));
    } catch (e) {
      throw Exception('Error al cerrar sesión Google: $e');
    }
  }

  // Verificar si Google Sign-In está disponible
  static Future<bool> isGoogleSignInAvailable() async {
    try {
      // En producción:
      // return await GoogleSignIn().isSignedIn();
      
      return true; // Siempre disponible en desarrollo
    } catch (e) {
      return false;
    }
  }

  // Obtener perfil del usuario de Google
  static Future<Map<String, String?>> getGoogleUserProfile() async {
    try {
      // En producción:
      // final user = await GoogleSignIn().currentUser;
      // return {
      //   'nombre': user?.displayName,
      //   'email': user?.email,
      //   'foto': user?.photoUrl,
      // };

      return {
        'nombre': 'Usuario Google',
        'email': 'usuario@gmail.com',
        'foto': null,
      };
    } catch (e) {
      throw Exception('Error al obtener perfil: $e');
    }
  }
}
