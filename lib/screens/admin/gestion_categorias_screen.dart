import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/producto.dart';
import '../../providers/producto_provider.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_widget.dart' as error_widget;

class GestionCategoriasScreen extends StatefulWidget {
  @override
  State<GestionCategoriasScreen> createState() => _GestionCategoriasScreenState();
}

class _GestionCategoriasScreenState extends State<GestionCategoriasScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ProductoProvider>().cargarCategorias();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Categoria> _getCategoriasFiltradas(List<Categoria> categorias) {
    if (_searchController.text.isEmpty) {
      return categorias;
    }

    final busqueda = _searchController.text.toLowerCase();
    return categorias.where((c) {
      return c.nombre.toLowerCase().contains(busqueda) ||
          (c.descripcion?.toLowerCase().contains(busqueda) ?? false) ||
          c.id.toString().contains(busqueda);
    }).toList();
  }

  void _showCrearEditarModal(BuildContext context, {Categoria? categoria}) {
    final formKey = GlobalKey<FormState>();
    // ignore: unused_local_variable
    late String nombre;
    // ignore: unused_local_variable
    late String descripcion;

    if (categoria != null) {
      nombre = categoria.nombre;
      descripcion = categoria.descripcion ?? '';
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(categoria == null ? 'Crear Categoría' : 'Editar Categoría'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: categoria?.nombre ?? '',
                    decoration: InputDecoration(labelText: 'Nombre'),
                    validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
                    onSaved: (v) => nombre = v ?? '',
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    initialValue: categoria?.descripcion ?? '',
                    decoration: InputDecoration(labelText: 'Descripción'),
                    maxLines: 3,
                    validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
                    onSaved: (v) => descripcion = v ?? '',
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
                    if (categoria == null) {
                      await context.read<ProductoProvider>().crearCategoria({
                            'nombre': nombre,
                            'descripcion': descripcion,
                          });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Categoría creada exitosamente')),
                      );
                    } else {
                      await context
                          .read<ProductoProvider>()
                          .actualizarCategoria(
                            categoria.id,
                            {
                              'nombre': nombre,
                              'descripcion': descripcion,
                            },
                          );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Categoría actualizada exitosamente')),
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
              child: Text(categoria == null ? 'Crear' : 'Actualizar'),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmDelete(BuildContext context, Categoria categoria) {
    // Verificar si tiene productos asociados
    final productos = context.read<ProductoProvider>().productos;
    final productosEnCategoria = productos
        .where((p) => p.categoria.id == categoria.id)
        .toList();

    if (productosEnCategoria.isNotEmpty) {
      showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text('No se puede eliminar'),
            content: Text(
              'Esta categoría tiene ${productosEnCategoria.length} producto(s) asociado(s). '
              'Elimina los productos primero.',
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text('Entendido'),
              ),
            ],
          );
        },
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Eliminar Categoría'),
          content: Text(
              '¿Estás seguro que deseas eliminar "${categoria.nombre}"?'),
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
                      .eliminarCategoria(categoria.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Categoría eliminada exitosamente')),
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
        title: Text('Gestión de Categorías'),
        elevation: 0,
      ),
      body: Consumer<ProductoProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return LoadingIndicator(message: 'Cargando categorías...');
          }

          if (provider.error != null) {
            return error_widget.ErrorWidget(
              message: provider.error ?? 'Error desconocido',
              onRetry: () => provider.cargarCategorias(),
            );
          }

          final categoriasFiltradas =
              _getCategoriasFiltradas(provider.categorias);

          return Column(
            children: [
              // Buscador
              Padding(
                padding: EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre o descripción...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              // Tabla de categorías
              Expanded(
                child: categoriasFiltradas.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.category_outlined,
                                size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text('No hay categorías',
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
                            DataColumn(label: Text('Descripción')),
                            DataColumn(label: Text('Productos')),
                            DataColumn(label: Text('Acciones')),
                          ],
                          rows: categoriasFiltradas
                              .map((categoria) {
                                final productosEnCat = provider.productos
                                    .where((p) => p.categoria.id == categoria.id)
                                    .length;
                                return DataRow(cells: [
                                  DataCell(
                                    Text(categoria.id.toString()),
                                  ),
                                  DataCell(
                                    Text(categoria.nombre),
                                  ),
                                  DataCell(
                                    Tooltip(
                                      message: categoria.descripcion ?? '',
                                      child: Text(
                                        categoria.descripcion ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue[100],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '$productosEnCat',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue[800],
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
                                                  categoria: categoria),
                                          tooltip: 'Editar',
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () => _showConfirmDelete(
                                              context, categoria),
                                          tooltip: 'Eliminar',
                                        ),
                                      ],
                                    ),
                                  ),
                                ]);
                              })
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
        label: Text('Nueva Categoría'),
        icon: Icon(Icons.add),
      ),
    );
  }
}
