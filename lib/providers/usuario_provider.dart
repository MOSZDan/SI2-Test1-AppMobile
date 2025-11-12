import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/usuario_service.dart';

class UsuarioProvider with ChangeNotifier {
  List<Usuario> _usuarios = [];
  List<Rol> _roles = [];
  bool _isLoading = false;
  String? _error;

  List<Usuario> get usuarios => _usuarios;
  List<Rol> get roles => _roles;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> cargarUsuarios() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _usuarios = await UsuarioService.getUsuarios();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cargarRoles() async {
    try {
      _roles = await UsuarioService.getRoles();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> crearUsuario(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await UsuarioService.crearUsuario(data);
      await cargarUsuarios();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> actualizarUsuario(int id, Map<String, dynamic> data) async {
    try {
      await UsuarioService.actualizarUsuario(id, data);
      await cargarUsuarios();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> eliminarUsuario(int id) async {
    try {
      await UsuarioService.eliminarUsuario(id);
      await cargarUsuarios();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> cambiarRol(int usuarioId, int rolId) async {
    try {
      await UsuarioService.cambiarRol(usuarioId, rolId);
      await cargarUsuarios();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
