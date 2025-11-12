import 'package:flutter/material.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_widget.dart' as error_widget;

class PagosHistorialScreen extends StatefulWidget {
  @override
  State<PagosHistorialScreen> createState() => _PagosHistorialScreenState();
}

class _PagosHistorialScreenState extends State<PagosHistorialScreen> {
  List<Map<String, dynamic>> _transacciones = [];
  bool _isLoading = false;
  String? _error;
  String _filtroEstado = '';
  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  @override
  void initState() {
    super.initState();
    _cargarTransacciones();
  }

  Future<void> _cargarTransacciones() async {
    setState(() => _isLoading = true);
    try {
      // Mock data para desarrollo
      _transacciones = [
        {
          'id': '1',
          'fecha': DateTime.now().subtract(Duration(days: 2)),
          'monto': 150.50,
          'descripcion': 'Compra en tienda - Producto A',
          'estado': 'Completada',
          'metodo': 'Visa •••• 4242',
          'referencia': 'TXN-2024-001',
        },
        {
          'id': '2',
          'fecha': DateTime.now().subtract(Duration(days: 5)),
          'monto': 89.99,
          'descripcion': 'Compra en tienda - Producto B',
          'estado': 'Completada',
          'metodo': 'Mastercard •••• 5555',
          'referencia': 'TXN-2024-002',
        },
        {
          'id': '3',
          'fecha': DateTime.now().subtract(Duration(days: 7)),
          'monto': 250.00,
          'descripcion': 'Compra en tienda - Paquete Premium',
          'estado': 'Completada',
          'metodo': 'Visa •••• 4242',
          'referencia': 'TXN-2024-003',
        },
        {
          'id': '4',
          'fecha': DateTime.now().subtract(Duration(days: 10)),
          'monto': 45.00,
          'descripcion': 'Reembolso - Producto defectuoso',
          'estado': 'Reembolsada',
          'metodo': 'Visa •••• 4242',
          'referencia': 'TXN-2024-004',
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

  List<Map<String, dynamic>> _getTransaccionesFiltradas() {
    var filtradas = _transacciones;

    // Filtro por estado
    if (_filtroEstado.isNotEmpty) {
      filtradas = filtradas
          .where((t) => t['estado'] == _filtroEstado)
          .toList();
    }

    // Filtro por fecha
    if (_fechaInicio != null) {
      filtradas = filtradas
          .where((t) => t['fecha'].isAfter(_fechaInicio!))
          .toList();
    }
    if (_fechaFin != null) {
      filtradas = filtradas
          .where((t) => t['fecha'].isBefore(_fechaFin!))
          .toList();
    }

    return filtradas;
  }

  Color _getColorEstado(String estado) {
    switch (estado) {
      case 'Completada':
        return Colors.green;
      case 'Pendiente':
        return Colors.orange;
      case 'Fallida':
        return Colors.red;
      case 'Reembolsada':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getIconoEstado(String estado) {
    switch (estado) {
      case 'Completada':
        return Icons.check_circle;
      case 'Pendiente':
        return Icons.schedule;
      case 'Fallida':
        return Icons.cancel;
      case 'Reembolsada':
        return Icons.undo;
      default:
        return Icons.help_outline;
    }
  }

  void _mostrarDetalles(Map<String, dynamic> transaccion) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Detalles de Transacción'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetalleItem(
                  label: 'Referencia',
                  valor: transaccion['referencia'],
                ),
                SizedBox(height: 12),
                _DetalleItem(
                  label: 'Fecha',
                  valor:
                      '${transaccion['fecha'].day}/${transaccion['fecha'].month}/${transaccion['fecha'].year}',
                ),
                SizedBox(height: 12),
                _DetalleItem(
                  label: 'Descripción',
                  valor: transaccion['descripcion'],
                ),
                SizedBox(height: 12),
                _DetalleItem(
                  label: 'Monto',
                  valor: '\$${transaccion['monto'].toStringAsFixed(2)}',
                ),
                SizedBox(height: 12),
                _DetalleItem(
                  label: 'Estado',
                  valor: transaccion['estado'],
                ),
                SizedBox(height: 12),
                _DetalleItem(
                  label: 'Método de Pago',
                  valor: transaccion['metodo'],
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
    final transaccionesFiltradas = _getTransaccionesFiltradas();

    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de Pagos'),
        elevation: 0,
      ),
      body: _isLoading
          ? LoadingIndicator(message: 'Cargando historial...')
          : _error != null
              ? error_widget.ErrorWidget(
                  message: _error ?? 'Error desconocido',
                  onRetry: _cargarTransacciones,
                )
              : Column(
                  children: [
                    // Filtros
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Filtro por estado
                          DropdownButton<String>(
                            isExpanded: true,
                            hint: Text('Filtrar por estado'),
                            value: _filtroEstado.isEmpty ? null : _filtroEstado,
                            items: [
                              DropdownMenuItem(
                                value: '',
                                child: Text('Todos'),
                              ),
                              DropdownMenuItem(
                                value: 'Completada',
                                child: Text('Completadas'),
                              ),
                              DropdownMenuItem(
                                value: 'Pendiente',
                                child: Text('Pendientes'),
                              ),
                              DropdownMenuItem(
                                value: 'Fallida',
                                child: Text('Fallidas'),
                              ),
                              DropdownMenuItem(
                                value: 'Reembolsada',
                                child: Text('Reembolsadas'),
                              ),
                            ],
                            onChanged: (v) {
                              setState(() => _filtroEstado = v ?? '');
                            },
                          ),
                          SizedBox(height: 12),
                          // Botones de rango de fechas
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final fecha = await showDatePicker(
                                      context: context,
                                      initialDate: _fechaInicio ?? DateTime.now(),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime.now(),
                                    );
                                    if (fecha != null) {
                                      setState(() => _fechaInicio = fecha);
                                    }
                                  },
                                  icon: Icon(Icons.calendar_today),
                                  label: Text(_fechaInicio == null
                                      ? 'Desde'
                                      : '${_fechaInicio!.day}/${_fechaInicio!.month}'),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final fecha = await showDatePicker(
                                      context: context,
                                      initialDate: _fechaFin ?? DateTime.now(),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime.now(),
                                    );
                                    if (fecha != null) {
                                      setState(() => _fechaFin = fecha);
                                    }
                                  },
                                  icon: Icon(Icons.calendar_today),
                                  label: Text(_fechaFin == null
                                      ? 'Hasta'
                                      : '${_fechaFin!.day}/${_fechaFin!.month}'),
                                ),
                              ),
                              if (_fechaInicio != null || _fechaFin != null)
                                IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _fechaInicio = null;
                                      _fechaFin = null;
                                    });
                                  },
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Lista de transacciones
                    Expanded(
                      child: transaccionesFiltradas.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.history,
                                      size: 64, color: Colors.grey),
                                  SizedBox(height: 16),
                                  Text('No hay transacciones',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.all(16),
                              itemCount: transaccionesFiltradas.length,
                              itemBuilder: (context, index) {
                                final transaccion =
                                    transaccionesFiltradas[index];
                                return Card(
                                  margin: EdgeInsets.only(bottom: 12),
                                  child: ListTile(
                                    leading: Icon(
                                      _getIconoEstado(
                                          transaccion['estado']),
                                      color: _getColorEstado(
                                          transaccion['estado']),
                                      size: 32,
                                    ),
                                    title: Text(
                                      transaccion['descripcion'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      transaccion['referencia'],
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    trailing: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '\$${transaccion['monto'].toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          transaccion['estado'],
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: _getColorEstado(
                                                transaccion['estado']),
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () =>
                                        _mostrarDetalles(transaccion),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
    );
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
