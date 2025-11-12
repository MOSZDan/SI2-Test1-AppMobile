import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/notificacion_service.dart';
import '../../models/notificacion.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_widget.dart' as custom_error;

class NotificacionesScreen extends StatefulWidget {
  const NotificacionesScreen({Key? key}) : super(key: key);

  @override
  State<NotificacionesScreen> createState() => _NotificacionesScreenState();
}

class _NotificacionesScreenState extends State<NotificacionesScreen> {
  bool _soloNoLeidas = false;
  late Future<List<Notificacion>> _notificacionesFuture;

  @override
  void initState() {
    super.initState();
    _loadNotificaciones();
  }

  void _loadNotificaciones() {
    _notificacionesFuture =
        NotificacionService.getNotificaciones(soloNoLeidas: _soloNoLeidas);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filtro
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CheckboxListTile(
              value: _soloNoLeidas,
              onChanged: (value) {
                setState(() {
                  _soloNoLeidas = value ?? false;
                  _loadNotificaciones();
                });
              },
              title: const Text('Solo no leídas'),
            ),
          ),

          // Lista de notificaciones
          Expanded(
            child: FutureBuilder<List<Notificacion>>(
              future: _notificacionesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingIndicator(
                    message: 'Cargando notificaciones...',
                  );
                }

                if (snapshot.hasError) {
                  return custom_error.ErrorWidget(
                    message: snapshot.error.toString(),
                    onRetry: () {
                      _loadNotificaciones();
                      setState(() {});
                    },
                  );
                }

                final notificaciones = snapshot.data ?? [];

                if (notificaciones.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_none_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay notificaciones',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: notificaciones.length,
                  itemBuilder: (context, index) {
                    final notificacion = notificaciones[index];
                    return _NotificacionItem(
                      notificacion: notificacion,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificacionItem extends StatefulWidget {
  final Notificacion notificacion;

  const _NotificacionItem({required this.notificacion});

  @override
  State<_NotificacionItem> createState() => _NotificacionItemState();
}

class _NotificacionItemState extends State<_NotificacionItem> {
  @override
  void initState() {
    super.initState();
  }

  IconData _getIconForTipo(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'pedido':
        return Icons.shopping_bag_outlined;
      case 'promocion':
        return Icons.local_offer_outlined;
      case 'alerta':
        return Icons.warning_outlined;
      case 'envio':
        return Icons.local_shipping_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getColorForTipo(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'pedido':
        return AppTheme.primaryColor;
      case 'promocion':
        return Colors.orange;
      case 'alerta':
        return Colors.red;
      case 'envio':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Future<void> _marcarLeida() async {
    if (widget.notificacion.leida) return;

    try {
      await NotificacionService.marcarLeida(widget.notificacion.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notificación marcada como leída'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _eliminar() async {
    try {
      await NotificacionService.eliminarNotificacion(widget.notificacion.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notificación eliminada'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          color: widget.notificacion.leida ? Colors.white : Colors.blue[50],
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getColorForTipo(widget.notificacion.tipo)
                    .withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getIconForTipo(widget.notificacion.tipo),
                color: _getColorForTipo(widget.notificacion.tipo),
              ),
            ),
            title: Text(
              widget.notificacion.titulo,
              style: TextStyle(
                fontWeight: widget.notificacion.leida
                    ? FontWeight.normal
                    : FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  widget.notificacion.mensaje,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Hace ${_getTimeAgo(widget.notificacion.fecha)}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
            isThreeLine: true,
            trailing: PopupMenuButton(
              itemBuilder: (context) {
                return [
                  if (!widget.notificacion.leida)
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.done, size: 18),
                          SizedBox(width: 8),
                          Text('Marcar como leída'),
                        ],
                      ),
                      value: 'read',
                    ),
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Eliminar',
                            style: TextStyle(color: Colors.red)),
                      ],
                    ),
                    value: 'delete',
                  ),
                ];
              },
              onSelected: (value) {
                if (value == 'read') {
                  _marcarLeida();
                } else if (value == 'delete') {
                  showDialog(
                    context: context,
                    builder: (dialogContext) {
                      return AlertDialog(
                        title: Text('Eliminar notificación'),
                        content: Text('¿Deseas eliminar esta notificación?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: Text('Cancelar'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                              _eliminar();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: Text('Eliminar'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
            onTap: () {
              if (widget.notificacion.enlace != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Navegación a enlace implementada'),
                  ),
                );
              }
            },
          ),
        ),
        if (!widget.notificacion.leida)
          Positioned(
            right: 16,
            top: 8,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
      ],
    );
  }

  String _getTimeAgo(DateTime fecha) {
    final ahora = DateTime.now();
    final diferencia = ahora.difference(fecha);

    if (diferencia.inSeconds < 60) {
      return 'ahora';
    } else if (diferencia.inMinutes < 60) {
      return '${diferencia.inMinutes}m';
    } else if (diferencia.inHours < 24) {
      return '${diferencia.inHours}h';
    } else if (diferencia.inDays < 7) {
      return '${diferencia.inDays}d';
    } else {
      return '${(diferencia.inDays / 7).floor()}sem';
    }
  }
}
