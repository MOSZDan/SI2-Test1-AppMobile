import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../services/producto_service.dart';

class ProductoProvider with ChangeNotifier {
  List<Producto> _productos = [];
  List<Categoria> _categorias = [];
  bool _isLoading = false;
  String? _error;
  String? _filtroCategoria;

  List<Producto> get productos => _productos;
  List<Categoria> get categorias => _categorias;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get filtroCategoria => _filtroCategoria;

  Future<void> cargarProductos({int? categoriaId, String? busqueda}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _productos = await ProductoService.getProductos(
        categoriaId: categoriaId,
        busqueda: busqueda,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cargarCategorias() async {
    try {
      _categorias = await ProductoService.getCategorias();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> cargarDashboard({int? categoriaId, String? busqueda}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await ProductoService.getDashboard(
        categoriaId: categoriaId,
        busqueda: busqueda,
      );

      if (data['productos'] != null) {
        _productos = (data['productos'] as List)
            .map((item) => Producto.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void setFiltroCategoria(String? categoriaId) {
    _filtroCategoria = categoriaId;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Métodos CRUD para Productos (Admin)
  Future<void> crearProducto(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final nuevoProducto = await ProductoService.crearProducto(data);
      _productos.add(nuevoProducto);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> actualizarProducto(int id, Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final productoActualizado = await ProductoService.actualizarProducto(id, data);
      final index = _productos.indexWhere((p) => p.id == id);
      if (index != -1) {
        _productos[index] = productoActualizado;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> eliminarProducto(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await ProductoService.eliminarProducto(id);
      _productos.removeWhere((p) => p.id == id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Métodos CRUD para Categorías (Admin)
  Future<void> crearCategoria(Map<String, dynamic> data) async {
    try {
      final nuevaCategoria = await ProductoService.crearCategoria(data);
      _categorias.add(nuevaCategoria);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> actualizarCategoria(int id, Map<String, dynamic> data) async {
    try {
      final categoriaActualizada = await ProductoService.actualizarCategoria(id, data);
      final index = _categorias.indexWhere((c) => c.id == id);
      if (index != -1) {
        _categorias[index] = categoriaActualizada;
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> eliminarCategoria(int id) async {
    try {
      await ProductoService.eliminarCategoria(id);
      _categorias.removeWhere((c) => c.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
