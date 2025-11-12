import 'package:flutter/material.dart';
import '../models/notificacion.dart';
import '../services/notificacion_service.dart';

class NotificacionProvider with ChangeNotifier {
  List<Notificacion> _notificaciones = [];
  bool _isLoading = false;
  String? _error;
  bool _soloNoLeidas = false;

  List<Notificacion> get notificaciones => _notificaciones;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get soloNoLeidas => _soloNoLeidas;
  
  int get noLeidasCount => 
      _notificaciones.where((n) => !n.leida).length;
  
  List<Notificacion> get notificacionesFiltradas =>
      _soloNoLeidas 
        ? _notificaciones.where((n) => !n.leida).toList()
        : _notificaciones;

  // Cargar notificaciones
  Future<void> cargarNotificaciones({bool soloNoLeidas = false}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _notificaciones = await NotificacionService.getNotificaciones(
        soloNoLeidas: soloNoLeidas,
      );
      _soloNoLeidas = soloNoLeidas;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cambiar filtro
  void setSoloNoLeidas(bool value) {
    _soloNoLeidas = value;
    notifyListeners();
  }

  // Marcar como leída
  Future<void> marcarLeida(int notificacionId) async {
    try {
      // Llamar al servicio
      await NotificacionService.marcarLeida(notificacionId);
      
      // Actualizar localmente
      final index = _notificaciones
          .indexWhere((n) => n.id == notificacionId);
      if (index != -1) {
        // Crear nueva notificación con leida = true
        final notificacion = _notificaciones[index];
        _notificaciones[index] = Notificacion(
          id: notificacion.id,
          titulo: notificacion.titulo,
          mensaje: notificacion.mensaje,
          tipo: notificacion.tipo,
          leida: true,
          fecha: notificacion.fecha,
          enlace: notificacion.enlace,
        );
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Eliminar notificación
  Future<void> eliminarNotificacion(int notificacionId) async {
    try {
      await NotificacionService.eliminarNotificacion(notificacionId);
      _notificaciones.removeWhere((n) => n.id == notificacionId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Crear plantilla
  Future<void> crearPlantilla(Map<String, dynamic> data) async {
    try {
      await NotificacionService.crearPlantilla(data);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Actualizar plantilla
  Future<void> actualizarPlantilla(
    int plantillaId,
    Map<String, dynamic> data,
  ) async {
    try {
      await NotificacionService.actualizarPlantilla(plantillaId, data);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Eliminar plantilla
  Future<void> eliminarPlantilla(int plantillaId) async {
    try {
      await NotificacionService.eliminarPlantilla(plantillaId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
