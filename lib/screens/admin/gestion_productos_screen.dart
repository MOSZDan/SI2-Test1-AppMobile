import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/producto.dart';
import '../../providers/producto_provider.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_widget.dart' as error_widget;

class GestionProductosScreen extends StatefulWidget {
  @override
  State<GestionProductosScreen> createState() => _GestionProductosScreenState();
}

class _GestionProductosScreenState extends State<GestionProductosScreen> {
  final _searchController = TextEditingController();
  String _filtroCategoria = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ProductoProvider>().cargarProductos();
      context.read<ProductoProvider>().cargarCategorias();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Producto> _getProductosFiltrados(List<Producto> productos) {
    var filtrados = productos;

    // Filtro por búsqueda
    if (_searchController.text.isNotEmpty) {
      final busqueda = _searchController.text.toLowerCase();
      filtrados = filtrados.where((p) {
        return p.nombre.toLowerCase().contains(busqueda) ||
            p.descripcion.toLowerCase().contains(busqueda) ||
            p.id.toString().contains(busqueda);
      }).toList();
    }

    // Filtro por categoría
    if (_filtroCategoria.isNotEmpty) {
      filtrados = filtrados
          .where((p) => p.categoria.nombre == _filtroCategoria)
          .toList();
    }

    return filtrados;
  }

  void _showCrearEditarModal(BuildContext context, {Producto? producto}) {
    final formKey = GlobalKey<FormState>();
    // ignore: unused_local_variable
    late String nombre;
    // ignore: unused_local_variable
    late String descripcion;
    // ignore: unused_local_variable
    late double precio;
    // ignore: unused_local_variable
    late int stock;
    // ignore: unused_local_variable
    String? imagen;
    // ignore: unused_local_variable
    late int categoriaId;

    if (producto != null) {
      nombre = producto.nombre;
      descripcion = producto.descripcion;
      precio = producto.precio;
      stock = producto.stock;
      imagen = producto.imagen;
      categoriaId = producto.categoria.id;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(producto == null ? 'Crear Producto' : 'Editar Producto'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: producto?.nombre ?? '',
                    decoration: InputDecoration(labelText: 'Nombre'),
                    validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
                    onSaved: (v) => nombre = v ?? '',
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    initialValue: producto?.descripcion ?? '',
                    decoration: InputDecoration(labelText: 'Descripción'),
                    maxLines: 3,
                    validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
                    onSaved: (v) => descripcion = v ?? '',
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    initialValue: producto?.precio.toString() ?? '',
                    decoration: InputDecoration(labelText: 'Precio'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
                    onSaved: (v) => precio = double.tryParse(v ?? '0') ?? 0,
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    initialValue: producto?.stock.toString() ?? '',
                    decoration: InputDecoration(labelText: 'Stock'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
                    onSaved: (v) => stock = int.tryParse(v ?? '0') ?? 0,
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    initialValue: producto?.imagen ?? '',
                    decoration: InputDecoration(
                      labelText: 'URL de Imagen',
                      helperText: 'URL completa de la imagen',
                    ),
                    onSaved: (v) => imagen = v,
                  ),
                  SizedBox(height: 12),
                  Consumer<ProductoProvider>(
                    builder: (context, provider, _) {
                      return DropdownButtonFormField<int>(
                        value: producto != null ? categoriaId : null,
                        decoration: InputDecoration(labelText: 'Categoría'),
                        items: provider.categorias
                            .map((cat) => DropdownMenuItem(
                                  value: cat.id,
                                  child: Text(cat.nombre),
                                ))
                            .toList(),
                        validator: (v) => v == null ? 'Requerido' : null,
                        onChanged: (v) => categoriaId = v ?? 0,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  formKey.currentState!.save();

                  try {
                    if (producto == null) {
                      await context.read<ProductoProvider>().crearProducto({
                            'nombre': nombre,
                            'descripcion': descripcion,
                            'precio': precio,
                            'stock': stock,
                            'imagen': imagen,
                            'categoria_id': categoriaId,
                          });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Producto creado exitosamente')),
                      );
                    } else {
                      await context
                          .read<ProductoProvider>()
                          .actualizarProducto(
                            producto.id,
                            {
                              'nombre': nombre,
                              'descripcion': descripcion,
                              'precio': precio,
                              'stock': stock,
                              'imagen': imagen,
                              'categoria_id': categoriaId,
                            },
                          );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Producto actualizado exitosamente')),
                      );
                    }
                    Navigator.pop(dialogContext);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
              child: Text(producto == null ? 'Crear' : 'Actualizar'),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmDelete(BuildContext context, Producto producto) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Eliminar Producto'),
          content: Text(
              '¿Estás seguro que deseas eliminar "${producto.nombre}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await context
                      .read<ProductoProvider>()
                      .eliminarProducto(producto.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Producto eliminado exitosamente')),
                  );
                  Navigator.pop(dialogContext);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text('Eliminar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Productos'),
        elevation: 0,
      ),
      body: Consumer<ProductoProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return LoadingIndicator(message: 'Cargando productos...');
          }

          if (provider.error != null) {
            return error_widget.ErrorWidget(
              message: provider.error ?? 'Error desconocido',
              onRetry: () => provider.cargarProductos(),
            );
          }

          final productosFiltrados = _getProductosFiltrados(provider.productos);

          return Column(
            children: [
              // Buscador y filtros
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Buscar por nombre, descripción...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FilterChip(
                            label: Text('Todas'),
                            selected: _filtroCategoria.isEmpty,
                            onSelected: (_) =>
                                setState(() => _filtroCategoria = ''),
                          ),
                          SizedBox(width: 8),
                          ...provider.categorias
                              .map(
                                (cat) => FilterChip(
                                  label: Text(cat.nombre),
                                  selected: _filtroCategoria == cat.nombre,
                                  onSelected: (_) => setState(
                                    () => _filtroCategoria = cat.nombre,
                                  ),
                                ),
                              )
                              .toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Tabla de productos
              Expanded(
                child: productosFiltrados.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_bag_outlined,
                                size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text('No hay productos',
                                style: Theme.of(context).textTheme.titleMedium),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text('ID')),
                            DataColumn(label: Text('Nombre')),
                            DataColumn(label: Text('Categoría')),
                            DataColumn(label: Text('Precio')),
                            DataColumn(label: Text('Stock')),
                            DataColumn(label: Text('Acciones')),
                          ],
                          rows: productosFiltrados
                              .map((producto) => DataRow(cells: [
                                    DataCell(
                                      Text(producto.id.toString()),
                                    ),
                                    DataCell(
                                      Tooltip(
                                        message: producto.nombre,
                                        child: Text(
                                          producto.nombre,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Chip(
                                        label: Text(producto.categoria.nombre),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        '\$${producto.precio.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: producto.stock > 0
                                              ? Colors.green[100]
                                              : Colors.red[100],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          producto.stock.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: producto.stock > 0
                                                ? Colors.green[800]
                                                : Colors.red[800],
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () =>
                                                _showCrearEditarModal(context,
                                                    producto: producto),
                                            tooltip: 'Editar',
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () =>
                                                _showConfirmDelete(
                                                    context, producto),
                                            tooltip: 'Eliminar',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]))
                              .toList(),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCrearEditarModal(context),
        label: Text('Nuevo Producto'),
        icon: Icon(Icons.add),
      ),
    );
  }
}
