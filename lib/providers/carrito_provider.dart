import 'package:flutter/material.dart';
import '../models/carrito.dart';
import '../services/carrito_service.dart';

class CarritoProvider with ChangeNotifier {
  Carrito? _carrito;
  bool _isLoading = false;
  String? _error;

  Carrito? get carrito => _carrito;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get itemCount => _carrito?.items.length ?? 0;
  double get total => _carrito?.total ?? 0.0;

  Future<void> cargarCarrito() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _carrito = await CarritoService.getCarrito();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> agregarItem(int productoId, int cantidad) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await CarritoService.agregarItem(
        productoId: productoId,
        cantidad: cantidad,
      );
      await cargarCarrito();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> actualizarItem(int itemId, int cantidad) async {
    try {
      await CarritoService.actualizarItem(itemId, cantidad);
      await cargarCarrito();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> eliminarItem(int itemId) async {
    try {
      await CarritoService.eliminarItem(itemId);
      await cargarCarrito();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> vaciarCarrito() async {
    try {
      await CarritoService.vaciarCarrito();
      await cargarCarrito();
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
