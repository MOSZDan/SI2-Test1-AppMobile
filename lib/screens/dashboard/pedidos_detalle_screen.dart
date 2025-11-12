import 'package:flutter/material.dart';
import '../../services/pedidos_tracking_service.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_widget.dart' as error_widget;

class PedidosDetalleScreen extends StatefulWidget {
  final String pedidoId;
  final Map<String, dynamic>? pedidoData;

  const PedidosDetalleScreen({
    Key? key,
    required this.pedidoId,
    this.pedidoData,
  }) : super(key: key);

  @override
  State<PedidosDetalleScreen> createState() => _PedidosDetalleScreenState();
}

class _PedidosDetalleScreenState extends State<PedidosDetalleScreen> {
  late Future<Map<String, dynamic>> _trackingFuture;
  late Future<List<Map<String, dynamic>>> _eventosFuture;
  Map<String, dynamic>? _transportista;

  @override
  void initState() {
    super.initState();
    _trackingFuture = PedidosTrackingService.obtenerTracking(widget.pedidoId);
    _eventosFuture = PedidosTrackingService.obtenerEventos(widget.pedidoId);
    _cargarTransportista();
  }

  void _cargarTransportista() async {
    try {
      final transportista =
          await PedidosTrackingService.obtenerTransportista(widget.pedidoId);
      setState(() => _transportista = transportista);
    } catch (e) {
      // Ignorar error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Pedido'),
        elevation: 0,
      ),
      body: FutureBuilder(
        future: Future.wait([_trackingFuture, _eventosFuture]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingIndicator(message: 'Cargando detalles...');
          }

          if (snapshot.hasError) {
            return error_widget.ErrorWidget(
              message: 'Error al cargar detalles',
              onRetry: () => setState(() {
                _trackingFuture =
                    PedidosTrackingService.obtenerTracking(widget.pedidoId);
                _eventosFuture =
                    PedidosTrackingService.obtenerEventos(widget.pedidoId);
              }),
            );
          }

          final tracking = snapshot.data?[0] as Map<String, dynamic>?;
          final eventos = snapshot.data?[1] as List<Map<String, dynamic>>? ?? [];

          if (tracking == null) {
            return Center(child: Text('No se pudo cargar el pedido'));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Estado actual
                _EstadoActualCard(
                  estado: tracking['estado'],
                  codigoSeguimiento: tracking['codigo_seguimiento'],
                  fechaEstimada: tracking['fecha_estimada_entrega'],
                ),

                // Timeline de eventos
                _TimelineEventos(eventos: eventos),

                // Información de entrega
                _InformacionEntrega(tracking: tracking),

                // Transportista
                if (_transportista != null)
                  _TarjetaTransportista(transportista: _transportista!),

                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EstadoActualCard extends StatelessWidget {
  final String estado;
  final String codigoSeguimiento;
  final String? fechaEstimada;

  const _EstadoActualCard({
    required this.estado,
    required this.codigoSeguimiento,
    this.fechaEstimada,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Estado con icono
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(
                        PedidosTrackingService.getColorEstado(estado)),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    _getIconoEstado(estado),
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      estado,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Código: $codigoSeguimiento',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            if (fechaEstimada != null) ...[
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Fecha estimada de entrega:',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Text(
                    _formatearFecha(fechaEstimada!),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getIconoEstado(String estado) {
    switch (estado) {
      case 'Entregado':
        return Icons.check_circle;
      case 'En tránsito':
        return Icons.local_shipping;
      case 'Procesado':
        return Icons.inventory_2;
      case 'Confirmado':
        return Icons.thumb_up;
      default:
        return Icons.info;
    }
  }

  String _formatearFecha(String fechaStr) {
    try {
      final fecha = DateTime.parse(fechaStr);
      return '${fecha.day}/${fecha.month}/${fecha.year}';
    } catch (e) {
      return '';
    }
  }
}

class _TimelineEventos extends StatelessWidget {
  final List<Map<String, dynamic>> eventos;

  const _TimelineEventos({required this.eventos});

  @override
  Widget build(BuildContext context) {
    final sorted = List<Map<String, dynamic>>.from(eventos);
    sorted.sort((a, b) => DateTime.parse(b['fecha'])
        .compareTo(DateTime.parse(a['fecha'])));

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Historial del pedido',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          ...sorted.asMap().entries.map((entry) {
            final index = entry.key;
            final evento = entry.value;
            final esUltimo = index == sorted.length - 1;

            return _EventoTimeline(
              evento: evento,
              esUltimo: esUltimo,
            );
          }).toList(),
        ],
      ),
    );
  }
}

class _EventoTimeline extends StatelessWidget {
  final Map<String, dynamic> evento;
  final bool esUltimo;

  const _EventoTimeline({
    required this.evento,
    required this.esUltimo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Línea de tiempo vertical
        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIcono(evento['icono']),
                color: Colors.white,
                size: 20,
              ),
            ),
            if (!esUltimo)
              Container(
                width: 2,
                height: 60,
                color: Colors.grey[300],
              ),
          ],
        ),
        SizedBox(width: 16),

        // Contenido del evento
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  evento['estado'] ?? 'Evento',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  evento['descripcion'] ?? '',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _formatearFecha(evento['fecha']),
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  IconData _getIcono(String? icono) {
    switch (icono) {
      case 'check_circle':
        return Icons.check_circle;
      case 'local_shipping':
        return Icons.local_shipping;
      case 'inventory_2':
        return Icons.inventory_2;
      case 'thumb_up':
        return Icons.thumb_up;
      default:
        return Icons.info;
    }
  }

  String _formatearFecha(String fechaStr) {
    try {
      final fecha = DateTime.parse(fechaStr);
      final hoy = DateTime.now();
      final diferencia = hoy.difference(fecha);

      if (diferencia.inDays == 0) {
        if (diferencia.inHours == 0) {
          return 'Hace ${diferencia.inMinutes} minutos';
        }
        return 'Hace ${diferencia.inHours} horas';
      } else if (diferencia.inDays == 1) {
        return 'Ayer';
      } else {
        return '${fecha.day}/${fecha.month}/${fecha.year}';
      }
    } catch (e) {
      return '';
    }
  }
}

class _InformacionEntrega extends StatelessWidget {
  final Map<String, dynamic> tracking;

  const _InformacionEntrega({required this.tracking});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dirección de entrega',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on, size: 24, color: Colors.red),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    tracking['direccion'] ?? 'No disponible',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TarjetaTransportista extends StatelessWidget {
  final Map<String, dynamic> transportista;

  const _TarjetaTransportista({required this.transportista});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Información del transportista',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, size: 30),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transportista['nombre'] ?? 'Transportista',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        transportista['empresa'] ?? '',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          SizedBox(width: 4),
                          Text(
                            '${transportista['calificacion'] ?? 0} ⭐',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // Llamar transportista
                      },
                      icon: Icon(Icons.call, size: 18),
                      label: Text('Llamar'),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Enviar mensaje
                      },
                      icon: Icon(Icons.message, size: 18),
                      label: Text('Chat'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
