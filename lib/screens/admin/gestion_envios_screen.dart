import 'package:flutter/material.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_widget.dart' as error_widget;

class GestionEnviosScreen extends StatefulWidget {
  @override
  State<GestionEnviosScreen> createState() => _GestionEnviosScreenState();
}

class _GestionEnviosScreenState extends State<GestionEnviosScreen> {
  final _searchController = TextEditingController();
  String _filtroEstado = '';
  String _filtroTipo = '';

  List<Map<String, dynamic>> _envios = [];
  bool _isLoading = false;
  String? _error;

  final List<String> _estados = ['Enviada', 'Leída', 'Error', 'Pendiente'];
  final List<String> _tipos = ['Pedido', 'Promoción', 'Alerta', 'Novedad'];

  @override
  void initState() {
    super.initState();
    _cargarEnvios();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _cargarEnvios() async {
    setState(() => _isLoading = true);
    try {
      // Aquí iría la llamada real al servicio
      // Por ahora usamos datos de ejemplo
      _envios = [
        {
          'id': 1,
          'fecha': DateTime.now(),
          'destinatario': 'juan@example.com',
          'plantilla': 'Tu pedido ha sido confirmado',
          'tipo': 'Pedido',
          'estado': 'Leída',
          'detalles': 'Enviado a Juan Pérez',
        },
        {
          'id': 2,
          'fecha': DateTime.now().subtract(Duration(hours: 2)),
          'destinatario': 'maria@example.com',
          'plantilla': 'Tu pedido está en camino',
          'tipo': 'Pedido',
          'estado': 'Enviada',
          'detalles': 'Enviado a María García',
        },
        {
          'id': 3,
          'fecha': DateTime.now().subtract(Duration(days: 1)),
          'destinatario': 'carlos@example.com',
          'plantilla': '¡Descuento especial!',
          'tipo': 'Promoción',
          'estado': 'Leída',
          'detalles': 'Enviado a Carlos López',
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

  List<Map<String, dynamic>> _getEnviosFiltrados() {
    var filtrados = _envios;

    // Filtro búsqueda
    if (_searchController.text.isNotEmpty) {
      final busqueda = _searchController.text.toLowerCase();
      filtrados = filtrados.where((e) {
        return e['destinatario'].toString().toLowerCase().contains(busqueda) ||
            e['plantilla'].toString().toLowerCase().contains(busqueda);
      }).toList();
    }

    // Filtro estado
    if (_filtroEstado.isNotEmpty) {
      filtrados = filtrados
          .where((e) => e['estado'] == _filtroEstado)
          .toList();
    }

    // Filtro tipo
    if (_filtroTipo.isNotEmpty) {
      filtrados = filtrados.where((e) => e['tipo'] == _filtroTipo).toList();
    }

    return filtrados;
  }

  void _showDetalles(Map<String, dynamic> envio) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Detalles del Envío'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetalleItem(
                  label: 'Fecha',
                  valor:
                      '${envio['fecha'].day}/${envio['fecha'].month}/${envio['fecha'].year}',
                ),
                SizedBox(height: 12),
                _DetalleItem(
                  label: 'Destinatario',
                  valor: envio['destinatario'],
                ),
                SizedBox(height: 12),
                _DetalleItem(
                  label: 'Plantilla',
                  valor: envio['plantilla'],
                ),
                SizedBox(height: 12),
                _DetalleItem(
                  label: 'Tipo',
                  valor: envio['tipo'],
                ),
                SizedBox(height: 12),
                _DetalleItem(
                  label: 'Estado',
                  valor: envio['estado'],
                ),
                SizedBox(height: 12),
                _DetalleItem(
                  label: 'Detalles',
                  valor: envio['detalles'],
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final enviosFiltrados = _getEnviosFiltrados();

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Envíos'),
        elevation: 0,
      ),
      body: _isLoading
          ? LoadingIndicator(message: 'Cargando envíos...')
          : _error != null
              ? error_widget.ErrorWidget(
                  message: _error ?? 'Error desconocido',
                  onRetry: _cargarEnvios,
                )
              : Column(
                  children: [
                    // Filtros
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Búsqueda
                          TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText:
                                  'Buscar por destinatario o plantilla...',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                          SizedBox(height: 12),
                          // Filtros por estado y tipo
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  hint: Text('Estado'),
                                  value: _filtroEstado.isEmpty
                                      ? null
                                      : _filtroEstado,
                                  items: [
                                    DropdownMenuItem(
                                      value: '',
                                      child: Text('Todos'),
                                    ),
                                    ..._estados
                                        .map((e) => DropdownMenuItem(
                                              value: e,
                                              child: Text(e),
                                            ))
                                        .toList(),
                                  ],
                                  onChanged: (v) {
                                    setState(() => _filtroEstado = v ?? '');
                                  },
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  hint: Text('Tipo'),
                                  value:
                                      _filtroTipo.isEmpty ? null : _filtroTipo,
                                  items: [
                                    DropdownMenuItem(
                                      value: '',
                                      child: Text('Todos'),
                                    ),
                                    ..._tipos
                                        .map((t) => DropdownMenuItem(
                                              value: t,
                                              child: Text(t),
                                            ))
                                        .toList(),
                                  ],
                                  onChanged: (v) {
                                    setState(() => _filtroTipo = v ?? '');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Tabla
                    Expanded(
                      child: enviosFiltrados.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.mail_outline,
                                      size: 64, color: Colors.grey),
                                  SizedBox(height: 16),
                                  Text('No hay envíos',
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
                                  DataColumn(label: Text('Fecha')),
                                  DataColumn(label: Text('Destinatario')),
                                  DataColumn(label: Text('Plantilla')),
                                  DataColumn(label: Text('Tipo')),
                                  DataColumn(label: Text('Estado')),
                                  DataColumn(label: Text('Acciones')),
                                ],
                                rows: enviosFiltrados
                                    .map((envio) => DataRow(cells: [
                                          DataCell(
                                            Text(
                                              '${envio['fecha'].day}/${envio['fecha'].month}/${envio['fecha'].year}',
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              envio['destinatario'],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          DataCell(
                                            Tooltip(
                                              message: envio['plantilla'],
                                              child: Text(
                                                envio['plantilla'],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Chip(
                                              label: Text(
                                                envio['tipo'],
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              backgroundColor:
                                                  _getTipoColor(envio['tipo']),
                                            ),
                                          ),
                                          DataCell(
                                            Chip(
                                              label: Text(
                                                envio['estado'],
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              backgroundColor: _getEstadoColor(
                                                  envio['estado']),
                                            ),
                                          ),
                                          DataCell(
                                            IconButton(
                                              icon: Icon(Icons.info),
                                              onPressed: () =>
                                                  _showDetalles(envio),
                                              tooltip: 'Ver detalles',
                                            ),
                                          ),
                                        ]))
                                    .toList(),
                              ),
                            ),
                    ),
                  ],
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

  Color _getEstadoColor(String estado) {
    switch (estado) {
      case 'Enviada':
        return Colors.blue;
      case 'Leída':
        return Colors.green;
      case 'Error':
        return Colors.red;
      case 'Pendiente':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

class _DetalleItem extends StatelessWidget {
  final String label;
  final String valor;

  const _DetalleItem({
    required this.label,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Text(
          valor,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
