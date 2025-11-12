import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/google_signin_service.dart';
import '../services/apple_signin_service.dart';

class AuthProvider with ChangeNotifier {
  Usuario? _usuario;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  Usuario? get usuario => _usuario;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;
  bool get isAdmin => _usuario?.rol?.descripcion == AppConstants.roleAdmin;
  bool get isVendedor =>
      _usuario?.rol?.descripcion == AppConstants.roleVendedor;
  bool get isCliente => _usuario?.rol?.descripcion == AppConstants.roleCliente;

  Future<void> syncUser({
    required String stackUserId,
    required String email,
    required String displayName,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _usuario = await AuthService.syncStackAuth(
        stackUserId: stackUserId,
        email: email,
        displayName: displayName,
      );

      // Configurar email en el cliente API
      ApiService.setUserEmail(email);

      // Guardar en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.userEmailKey, email);

      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      _isAuthenticated = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _usuario = null;
    _isAuthenticated = false;
    ApiService.clearUserEmail();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.userEmailKey);
    notifyListeners();
  }

  Future<void> loadUserFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(AppConstants.userEmailKey);
    if (email != null) {
      ApiService.setUserEmail(email);
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Phase 4: Google Sign-In
  Future<void> signInWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Obtener el ID token de Google
      final idToken = await GoogleSignInService.getGoogleIdToken();
      
      // Enviar al backend
      final result = await GoogleSignInService.signInWithGoogle(idToken);
      
      if (result['email'] != null) {
        final userProfile = await GoogleSignInService.getGoogleUserProfile();
        
        // Sync con backend
        await syncUser(
          stackUserId: userProfile['id'] ?? 'google_${userProfile['email']}',
          email: userProfile['email'] ?? '',
          displayName: userProfile['nombre'] ?? 'Usuario Google',
        );

        // Guardar Google token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('google_token', idToken);
        
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error en Google Sign-In: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Phase 4: Apple Sign-In
  Future<void> signInWithApple() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Obtener el credential token de Apple
      final credentialToken = await AppleSignInService.getAppleIdentityToken();
      
      // Enviar al backend
      final result = await AppleSignInService.signInWithApple(credentialToken);
      
      if (result['email'] != null) {
        final userProfile = await AppleSignInService.getAppleUserProfile();
        
        // Sync con backend
        await syncUser(
          stackUserId: userProfile['id'] ?? 'apple_${userProfile['email']}',
          email: userProfile['email'] ?? '',
          displayName: userProfile['nombre'] ?? 'Usuario Apple',
        );

        // Guardar Apple token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('apple_token', credentialToken);
        
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error en Apple Sign-In: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Phase 4: Logout from OAuth
  Future<void> logoutFromOAuth() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Logout de Google si está disponible
      if (await GoogleSignInService.isGoogleSignInAvailable()) {
        await GoogleSignInService.signOutGoogle();
      }

      // Logout de Apple si está disponible
      if (await AppleSignInService.isAppleSignInAvailable()) {
        await AppleSignInService.signOutApple();
      }

      // Limpiar tokens
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('google_token');
      await prefs.remove('apple_token');

      await logout();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Error en logout: $e';
      _isLoading = false;
      notifyListeners();
    }
  }
}
