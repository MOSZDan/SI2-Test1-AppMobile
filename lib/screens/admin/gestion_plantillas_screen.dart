import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/notificacion_provider.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_widget.dart' as error_widget;

class GestionPlantillasScreen extends StatefulWidget {
  @override
  State<GestionPlantillasScreen> createState() =>
      _GestionPlantillasScreenState();
}

class _GestionPlantillasScreenState extends State<GestionPlantillasScreen> {
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _plantillas = [];
  bool _isLoading = false;
  String? _error;

  final List<String> _tipos = ['Pedido', 'Promoción', 'Alerta', 'Novedad'];

  @override
  void initState() {
    super.initState();
    _cargarPlantillas();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _cargarPlantillas() async {
    setState(() => _isLoading = true);
    try {
      // Aquí iría la llamada real al servicio
      // Por ahora usamos datos de ejemplo
      _plantillas = [
        {
          'id': 1,
          'tipo': 'Pedido',
          'titulo': 'Tu pedido ha sido confirmado',
          'mensaje':
              'Tu pedido #{{orden_id}} por \${{monto}} ha sido confirmado',
          'estado': true,
          'fecha_creacion': DateTime.now(),
        },
        {
          'id': 2,
          'tipo': 'Envío',
          'titulo': 'Tu pedido está en camino',
          'mensaje':
              'Tu pedido {{orden_id}} está siendo enviado. Seguimiento: {{tracking}}',
          'estado': true,
          'fecha_creacion': DateTime.now().subtract(Duration(days: 5)),
        },
        {
          'id': 3,
          'tipo': 'Promoción',
          'titulo': '¡Descuento especial!',
          'mensaje': '{{nombre}}, tienes un {{descuento}}% de descuento',
          'estado': false,
          'fecha_creacion': DateTime.now().subtract(Duration(days: 10)),
        },
      ];
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _getPlantillasFiltradas() {
    if (_searchController.text.isEmpty) {
      return _plantillas;
    }

    final busqueda = _searchController.text.toLowerCase();
    return _plantillas.where((p) {
      return p['titulo'].toString().toLowerCase().contains(busqueda) ||
          p['tipo'].toString().toLowerCase().contains(busqueda);
    }).toList();
  }

  void _showCrearEditarModal({Map<String, dynamic>? plantilla}) {
    final formKey = GlobalKey<FormState>();
    // ignore: unused_local_variable
    late String titulo;
    // ignore: unused_local_variable
    late String mensaje;
    // ignore: unused_local_variable
    late String tipo;
    // ignore: unused_local_variable
    bool activa = true;

    if (plantilla != null) {
      titulo = plantilla['titulo'];
      mensaje = plantilla['mensaje'];
      tipo = plantilla['tipo'];
      activa = plantilla['estado'] ?? true;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            plantilla == null ? 'Crear Plantilla' : 'Editar Plantilla',
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: tipo.isNotEmpty ? tipo : null,
                    decoration: InputDecoration(labelText: 'Tipo'),
                    items: _tipos
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    validator: (v) => v == null ? 'Requerido' : null,
                    onChanged: (v) => tipo = v ?? '',
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    initialValue: plantilla != null ? plantilla['titulo'] ?? '' : '',
                    decoration: InputDecoration(labelText: 'Título'),
                    validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
                    onSaved: (v) => titulo = v ?? '',
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    initialValue: plantilla != null ? plantilla['mensaje'] ?? '' : '',
                    decoration: InputDecoration(
                      labelText: 'Mensaje',
                      helperText:
                          'Usa {{variable}} para variables dinámicas',
                    ),
                    maxLines: 4,
                    validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
                    onSaved: (v) => mensaje = v ?? '',
                  ),
                  SizedBox(height: 12),
                  CheckboxListTile(
                    value: activa,
                    onChanged: (v) => activa = v ?? true,
                    title: Text('Plantilla Activa'),
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
                    if (plantilla == null) {
                      await context.read<NotificacionProvider>()
                          .crearPlantilla({
                        'tipo': tipo,
                        'titulo': titulo,
                        'mensaje': mensaje,
                        'estado': activa,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Plantilla creada exitosamente'),
                        ),
                      );
                    } else {
                      await context
                          .read<NotificacionProvider>()
                          .actualizarPlantilla(plantilla['id'], {
                        'tipo': tipo,
                        'titulo': titulo,
                        'mensaje': mensaje,
                        'estado': activa,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Plantilla actualizada exitosamente'),
                        ),
                      );
                    }
                    Navigator.pop(dialogContext);
                    _cargarPlantillas();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
              child: Text(plantilla == null ? 'Crear' : 'Actualizar'),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmDelete(Map<String, dynamic> plantilla) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Eliminar Plantilla'),
          content: Text(
            '¿Estás seguro que deseas eliminar la plantilla "${plantilla['titulo']}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await context.read<NotificacionProvider>()
                      .eliminarPlantilla(plantilla['id']);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Plantilla eliminada exitosamente')),
                  );
                  Navigator.pop(dialogContext);
                  _cargarPlantillas();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Eliminar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final plantillasFiltradas = _getPlantillasFiltradas();

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Plantillas'),
        elevation: 0,
      ),
      body: _isLoading
          ? LoadingIndicator(message: 'Cargando plantillas...')
          : _error != null
              ? error_widget.ErrorWidget(
                  message: _error ?? 'Error desconocido',
                  onRetry: _cargarPlantillas,
                )
              : Column(
                  children: [
                    // Buscador
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Buscar plantillas...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    // Tabla
                    Expanded(
                      child: plantillasFiltradas.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.mail_outline,
                                      size: 64, color: Colors.grey),
                                  SizedBox(height: 16),
                                  Text('No hay plantillas',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                ],
                              ),
                            )
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columns: [
                                  DataColumn(label: Text('Tipo')),
                                  DataColumn(label: Text('Título')),
                                  DataColumn(label: Text('Mensaje')),
                                  DataColumn(label: Text('Estado')),
                                  DataColumn(label: Text('Acciones')),
                                ],
                                rows: plantillasFiltradas
                                    .map((plantilla) => DataRow(cells: [
                                          DataCell(
                                            Chip(
                                              label: Text(
                                                plantilla['tipo'],
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              backgroundColor:
                                                  _getTipoColor(plantilla['tipo']),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              plantilla['titulo'],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          DataCell(
                                            Tooltip(
                                              message: plantilla['mensaje'],
                                              child: Text(
                                                plantilla['mensaje'],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Icon(
                                              plantilla['estado']
                                                  ? Icons.check_circle
                                                  : Icons.cancel,
                                              color: plantilla['estado']
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                          ),
                                          DataCell(
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.edit),
                                                  onPressed: () =>
                                                      _showCrearEditarModal(
                                                        plantilla: plantilla,
                                                      ),
                                                  tooltip: 'Editar',
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.delete,
                                                      color: Colors.red),
                                                  onPressed: () =>
                                                      _showConfirmDelete(
                                                          plantilla),
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
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCrearEditarModal(),
        label: Text('Nueva Plantilla'),
        icon: Icon(Icons.add),
      ),
    );
  }

  Color _getTipoColor(String tipo) {
    switch (tipo) {
      case 'Pedido':
        return Colors.blue;
      case 'Envío':
        return Colors.orange;
      case 'Promoción':
        return Colors.green;
      case 'Alerta':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
