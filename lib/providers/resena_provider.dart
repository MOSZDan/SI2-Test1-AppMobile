import 'package:flutter/material.dart';
import '../services/resena_service.dart';

class ResenaProvider with ChangeNotifier {
  List<Map<String, dynamic>> _resenas = [];
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _estadisticas;
  double _promedioCalificacion = 0;

  List<Map<String, dynamic>> get resenas => _resenas;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get estadisticas => _estadisticas;
  double get promedioCalificacion => _promedioCalificacion;

  // Cargar reseñas de un producto
  Future<void> cargarResenas(int productoId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _resenas = await ResenaService.obtenerResenas(productoId);
      _promedioCalificacion =
          ResenaService.calcularPromedio(_resenas);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cargar reseñas paginadas
  Future<void> cargarResenasPaginadas({
    required int productoId,
    required int pagina,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final datos = await ResenaService.obtenerResenasPaginadas(
        productoId: productoId,
        pagina: pagina,
      );
      _resenas = List<Map<String, dynamic>>.from(datos['results'] ?? []);
      _promedioCalificacion =
          ResenaService.calcularPromedio(_resenas);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Crear una reseña
  Future<bool> crearResena({
    required int productoId,
    required String clienteId,
    required int calificacion,
    required String titulo,
    required String comentario,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final resultado = await ResenaService.crearResena(
        productoId: productoId,
        clienteId: clienteId,
        calificacion: calificacion,
        titulo: titulo,
        comentario: comentario,
      );

      // Agregar la nueva reseña al inicio de la lista
      _resenas.insert(0, resultado);
      _promedioCalificacion =
          ResenaService.calcularPromedio(_resenas);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Actualizar una reseña
  Future<bool> actualizarResena({
    required int resenaId,
    int? calificacion,
    String? titulo,
    String? comentario,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await ResenaService.actualizarResena(
        resenaId: resenaId,
        calificacion: calificacion,
        titulo: titulo,
        comentario: comentario,
      );

      // Actualizar en la lista local
      final index = _resenas.indexWhere((r) => r['id'] == resenaId);
      if (index != -1) {
        if (calificacion != null) _resenas[index]['calificacion'] = calificacion;
        if (titulo != null) _resenas[index]['titulo'] = titulo;
        if (comentario != null) _resenas[index]['comentario'] = comentario;
      }

      _promedioCalificacion =
          ResenaService.calcularPromedio(_resenas);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Eliminar una reseña
  Future<bool> eliminarResena(int resenaId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await ResenaService.eliminarResena(resenaId);

      // Eliminar de la lista local
      _resenas.removeWhere((r) => r['id'] == resenaId);
      _promedioCalificacion =
          ResenaService.calcularPromedio(_resenas);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Cargar estadísticas
  Future<void> cargarEstadisticas(int productoId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _estadisticas =
          await ResenaService.obtenerEstadisticasResenas(productoId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Filtrar reseñas por calificación
  void filtrarPorCalificacion(int calificacion) {
    if (calificacion == 0) {
      // Si es 0, mostrar todas
      cargarResenas(_resenas.isNotEmpty ? 1 : 1);
    } else {
      final filtradas = ResenaService.filtrarPorCalificacion(
        _resenas,
        calificacion,
      );
      _resenas = filtradas;
      notifyListeners();
    }
  }

  // Ordenar reseñas
  void ordenarPorFecha({bool descendente = true}) {
    _resenas = ResenaService.ordenarPorFecha(
      _resenas,
      descendente: descendente,
    );
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
