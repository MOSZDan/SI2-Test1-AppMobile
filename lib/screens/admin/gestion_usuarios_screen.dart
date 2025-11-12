import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/usuario.dart';
import '../../providers/usuario_provider.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_widget.dart' as error_widget;

class GestionUsuariosScreen extends StatefulWidget {
  @override
  State<GestionUsuariosScreen> createState() => _GestionUsuariosScreenState();
}

class _GestionUsuariosScreenState extends State<GestionUsuariosScreen> {
  final _searchController = TextEditingController();
  String _filtroRol = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<UsuarioProvider>().cargarUsuarios();
      context.read<UsuarioProvider>().cargarRoles();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Usuario> _getUsuariosFiltrados(List<Usuario> usuarios) {
    var filtrados = usuarios;

    // Filtro por búsqueda
    if (_searchController.text.isNotEmpty) {
      final busqueda = _searchController.text.toLowerCase();
      filtrados = filtrados.where((u) {
        return u.nombre.toLowerCase().contains(busqueda) ||
            u.apellido.toLowerCase().contains(busqueda) ||
            u.email.toLowerCase().contains(busqueda) ||
            u.codigo.toString().contains(busqueda);
      }).toList();
    }

    // Filtro por rol
    if (_filtroRol.isNotEmpty) {
      filtrados = filtrados
          .where((u) => u.rol?.descripcion == _filtroRol)
          .toList();
    }

    return filtrados;
  }

  void _showCrearEditarModal(BuildContext context, {Usuario? usuario}) {
    final formKey = GlobalKey<FormState>();
    late String nombre;
    late String apellido;
    late String email;
    String? telefono;
    String? direccion;
    String? sexo;

    if (usuario != null) {
      nombre = usuario.nombre;
      apellido = usuario.apellido;
      email = usuario.email;
      telefono = usuario.telefono;
      direccion = usuario.direccion;
      sexo = usuario.sexo;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(usuario == null ? 'Crear Usuario' : 'Editar Usuario'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: usuario?.nombre ?? '',
                    decoration: InputDecoration(labelText: 'Nombre'),
                    validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
                    onSaved: (v) => nombre = v ?? '',
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    initialValue: usuario?.apellido ?? '',
                    decoration: InputDecoration(labelText: 'Apellido'),
                    validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
                    onSaved: (v) => apellido = v ?? '',
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    initialValue: usuario?.email ?? '',
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
                    onSaved: (v) => email = v ?? '',
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    initialValue: usuario?.telefono ?? '',
                    decoration: InputDecoration(labelText: 'Teléfono'),
                    onSaved: (v) => telefono = v,
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    initialValue: usuario?.direccion ?? '',
                    decoration: InputDecoration(labelText: 'Dirección'),
                    onSaved: (v) => direccion = v,
                  ),
                  SizedBox(height: 12),
                  Consumer<UsuarioProvider>(
                    builder: (context, provider, _) {
                      return DropdownButtonFormField<String>(
                        value: sexo,
                        decoration: InputDecoration(labelText: 'Sexo'),
                        items: ['M', 'F', 'Otro']
                            .map((s) => DropdownMenuItem(
                                  value: s,
                                  child: Text(s),
                                ))
                            .toList(),
                        onChanged: (v) => sexo = v,
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

                  final data = {
                    'nombre': nombre,
                    'apellido': apellido,
                    'email': email,
                    'telefono': telefono,
                    'direccion': direccion,
                    'sexo': sexo,
                  };

                  try {
                    if (usuario == null) {
                      await context.read<UsuarioProvider>().crearUsuario(data);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Usuario creado exitosamente')),
                      );
                    } else {
                      await context
                          .read<UsuarioProvider>()
                          .actualizarUsuario(usuario.codigo, data);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Usuario actualizado exitosamente')),
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
              child: Text(usuario == null ? 'Crear' : 'Actualizar'),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmDelete(BuildContext context, Usuario usuario) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Eliminar Usuario'),
          content: Text(
              '¿Estás seguro que deseas eliminar a ${usuario.nombre} ${usuario.apellido}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await context
                      .read<UsuarioProvider>()
                      .eliminarUsuario(usuario.codigo);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Usuario eliminado exitosamente')),
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

  void _showCambiarRolModal(BuildContext context, Usuario usuario) {
    String? rolSeleccionado;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Cambiar Rol de ${usuario.nombre}'),
          content: Consumer<UsuarioProvider>(
            builder: (context, provider, _) {
              return DropdownButton<String>(
                isExpanded: true,
                hint: Text('Seleccionar rol'),
                value: rolSeleccionado,
                items: provider.roles
                    .map((rol) => DropdownMenuItem(
                          value: rol.id.toString(),
                          child: Text(rol.descripcion),
                        ))
                    .toList(),
                onChanged: (v) {
                  rolSeleccionado = v;
                  (dialogContext as Element).markNeedsBuild();
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: rolSeleccionado == null
                  ? null
                  : () async {
                      try {
                        await context.read<UsuarioProvider>().cambiarRol(
                              usuario.codigo,
                              int.parse(rolSeleccionado!),
                            );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Rol actualizado exitosamente')),
                        );
                        Navigator.pop(dialogContext);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    },
              child: Text('Cambiar'),
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
        title: Text('Gestión de Usuarios'),
        elevation: 0,
      ),
      body: Consumer<UsuarioProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return LoadingIndicator(message: 'Cargando usuarios...');
          }

          if (provider.error != null) {
            return error_widget.ErrorWidget(
              message: provider.error ?? 'Error desconocido',
              onRetry: () => provider.cargarUsuarios(),
            );
          }

          final usuariosFiltrados =
              _getUsuariosFiltrados(provider.usuarios);

          return Column(
            children: [
              // Buscador
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Buscar por nombre, email o código...',
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
                            label: Text('Todos'),
                            selected: _filtroRol.isEmpty,
                            onSelected: (_) => setState(() => _filtroRol = ''),
                          ),
                          SizedBox(width: 8),
                          ...provider.roles
                              .map(
                                (rol) => FilterChip(
                                  label: Text(rol.descripcion),
                                  selected: _filtroRol == rol.descripcion,
                                  onSelected: (_) => setState(
                                    () => _filtroRol = rol.descripcion,
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
              // Tabla de usuarios
              Expanded(
                child: usuariosFiltrados.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.people_outline,
                                size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text('No hay usuarios',
                                style: Theme.of(context).textTheme.titleMedium),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text('Código')),
                            DataColumn(label: Text('Nombre')),
                            DataColumn(label: Text('Email')),
                            DataColumn(label: Text('Teléfono')),
                            DataColumn(label: Text('Rol')),
                            DataColumn(label: Text('Acciones')),
                          ],
                          rows: usuariosFiltrados
                              .map((usuario) => DataRow(cells: [
                                    DataCell(
                                      Text(usuario.codigo.toString()),
                                    ),
                                    DataCell(
                                      Text(
                                        '${usuario.nombre} ${usuario.apellido}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        usuario.email,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    DataCell(
                                      Text(usuario.telefono ?? '-'),
                                    ),
                                    DataCell(
                                      Chip(
                                        label: Text(
                                          usuario.rol?.descripcion ?? '-',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                        backgroundColor: _getRolColor(
                                          usuario.rol?.descripcion ?? '',
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
                                                    usuario: usuario),
                                            tooltip: 'Editar',
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.admin_panel_settings),
                                            onPressed: () =>
                                                _showCambiarRolModal(
                                                    context, usuario),
                                            tooltip: 'Cambiar rol',
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () =>
                                                _showConfirmDelete(
                                                    context, usuario),
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
        label: Text('Nuevo Usuario'),
        icon: Icon(Icons.add),
      ),
    );
  }

  Color _getRolColor(String rol) {
    switch (rol) {
      case 'Administrador':
        return Colors.red;
      case 'Vendedor':
        return Colors.orange;
      case 'Cliente':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
