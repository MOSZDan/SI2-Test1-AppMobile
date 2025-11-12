import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/resena_provider.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_widget.dart' as error_widget;

class ResenaScreen extends StatefulWidget {
  final int productoId;
  final String productoNombre;

  const ResenaScreen({
    Key? key,
    required this.productoId,
    required this.productoNombre,
  }) : super(key: key);

  @override
  State<ResenaScreen> createState() => _ResenaScreenState();
}

class _ResenaScreenState extends State<ResenaScreen> {
  int _filtroCalificacion = 0; // 0 = todas
  bool _ordenDescendente = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ResenaProvider>(context, listen: false)
          .cargarResenas(widget.productoId);
      Provider.of<ResenaProvider>(context, listen: false)
          .cargarEstadisticas(widget.productoId);
    });
  }

  void _mostrarFormularioResena() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return _FormularioResena(
          productoId: widget.productoId,
          onCreated: () {
            Navigator.pop(dialogContext);
            Provider.of<ResenaProvider>(context, listen: false)
                .cargarResenas(widget.productoId);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reseñas de ${widget.productoNombre}'),
        elevation: 0,
      ),
      body: Consumer<ResenaProvider>(
        builder: (context, resenaProvider, _) {
          if (resenaProvider.isLoading && resenaProvider.resenas.isEmpty) {
            return LoadingIndicator(message: 'Cargando reseñas...');
          }

          if (resenaProvider.error != null && resenaProvider.resenas.isEmpty) {
            return error_widget.ErrorWidget(
              message: resenaProvider.error ?? 'Error desconocido',
              onRetry: () {
                resenaProvider.cargarResenas(widget.productoId);
              },
            );
          }

          return Column(
            children: [
              // Estadísticas
              if (resenaProvider.estadisticas != null)
                _EstadisticasResenas(
                  estadisticas: resenaProvider.estadisticas!,
                  promedio: resenaProvider.promedioCalificacion,
                  total: resenaProvider.resenas.length,
                ),

              // Filtros y opciones
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButton<int>(
                        isExpanded: true,
                        value: _filtroCalificacion,
                        items: [
                          DropdownMenuItem(
                            value: 0,
                            child: Text('Todas las reseñas'),
                          ),
                          DropdownMenuItem(
                            value: 5,
                            child: Text('⭐⭐⭐⭐⭐ 5 estrellas'),
                          ),
                          DropdownMenuItem(
                            value: 4,
                            child: Text('⭐⭐⭐⭐ 4 estrellas'),
                          ),
                          DropdownMenuItem(
                            value: 3,
                            child: Text('⭐⭐⭐ 3 estrellas'),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text('⭐⭐ 2 estrellas'),
                          ),
                          DropdownMenuItem(
                            value: 1,
                            child: Text('⭐ 1 estrella'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _filtroCalificacion = value);
                            resenaProvider.filtrarPorCalificacion(value);
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        _ordenDescendente
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                      ),
                      onPressed: () {
                        setState(
                            () => _ordenDescendente = !_ordenDescendente);
                        resenaProvider.ordenarPorFecha(
                            descendente: _ordenDescendente);
                      },
                    ),
                  ],
                ),
              ),

              // Lista de reseñas
              Expanded(
                child: resenaProvider.resenas.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.rate_review,
                                size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No hay reseñas aún',
                              style:
                                  Theme.of(context).textTheme.titleMedium,
                            ),
                            SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: _mostrarFormularioResena,
                              icon: Icon(Icons.add),
                              label: Text('Escribir reseña'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: resenaProvider.resenas.length,
                        itemBuilder: (context, index) {
                          final resena =
                              resenaProvider.resenas[index];
                          return _TarjetaResena(
                            resena: resena,
                            onEditar: () {
                              // Implementar edición
                            },
                            onEliminar: () {
                              resenaProvider.eliminarResena(
                                  resena['id']);
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarFormularioResena,
        child: Icon(Icons.add),
      ),
    );
  }
}

class _EstadisticasResenas extends StatelessWidget {
  final Map<String, dynamic> estadisticas;
  final double promedio;
  final int total;

  const _EstadisticasResenas({
    required this.estadisticas,
    required this.promedio,
    required this.total,
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
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calificación general',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          promedio.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Column(
                          children: [
                            _BuildStarRating(rating: promedio, size: 16),
                            SizedBox(height: 4),
                            Text(
                              '($total reseñas)',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (int i = 5; i >= 1; i--)
                      _DistribucionBarra(
                        calificacion: i,
                        porcentaje: (estadisticas['distribucion']?[i.toString()] ?? 0)
                            .toDouble(),
                        total: total,
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

class _DistribucionBarra extends StatelessWidget {
  final int calificacion;
  final double porcentaje;
  final int total;

  const _DistribucionBarra({
    required this.calificacion,
    required this.porcentaje,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$calificacion⭐', style: TextStyle(fontSize: 11)),
        SizedBox(width: 4),
        SizedBox(
          width: 80,
          child: LinearProgressIndicator(
            value: total > 0 ? porcentaje / total : 0,
            minHeight: 6,
          ),
        ),
        SizedBox(width: 4),
        Text(
          '${porcentaje.toInt()}',
          style: TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }
}

class _TarjetaResena extends StatelessWidget {
  final Map<String, dynamic> resena;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const _TarjetaResena({
    required this.resena,
    required this.onEditar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BuildStarRating(rating: resena['calificacion'].toDouble()),
                    SizedBox(height: 4),
                    Text(
                      resena['titulo'] ?? 'Sin título',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text('Editar'),
                      onTap: onEditar,
                    ),
                    PopupMenuItem(
                      child: Text('Eliminar', style: TextStyle(color: Colors.red)),
                      onTap: onEliminar,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              resena['comentario'] ?? '',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[700]),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Por: ${resena['cliente_nombre'] ?? 'Anónimo'}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  _formatearFecha(resena['fecha_creacion']),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatearFecha(String? fechaStr) {
    if (fechaStr == null) return '';
    try {
      final fecha = DateTime.parse(fechaStr);
      final hoy = DateTime.now();
      final diferencia = hoy.difference(fecha);

      if (diferencia.inDays == 0) {
        if (diferencia.inHours == 0) {
          return 'Hace ${diferencia.inMinutes} min';
        }
        return 'Hace ${diferencia.inHours} h';
      } else if (diferencia.inDays == 1) {
        return 'Ayer';
      } else if (diferencia.inDays < 7) {
        return 'Hace ${diferencia.inDays} días';
      } else {
        return '${fecha.day}/${fecha.month}/${fecha.year}';
      }
    } catch (e) {
      return '';
    }
  }
}

class _BuildStarRating extends StatelessWidget {
  final double rating;
  final double size;

  const _BuildStarRating({
    required this.rating,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) => Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: size,
        ),
      ),
    );
  }
}

class _FormularioResena extends StatefulWidget {
  final int productoId;
  final VoidCallback onCreated;

  const _FormularioResena({
    required this.productoId,
    required this.onCreated,
  });

  @override
  State<_FormularioResena> createState() => _FormularioResenaState();
}

class _FormularioResenaState extends State<_FormularioResena> {
  late TextEditingController _tituloController;
  late TextEditingController _comentarioController;
  int _calificacion = 5;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController();
    _comentarioController = TextEditingController();
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _comentarioController.dispose();
    super.dispose();
  }

  void _submitResena() async {
    if (_tituloController.text.isEmpty ||
        _comentarioController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Complete todos los campos')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final success = await Provider.of<ResenaProvider>(context, listen: false)
        .crearResena(
          productoId: widget.productoId,
          clienteId: 'cliente_${DateTime.now().millisecondsSinceEpoch}',
          calificacion: _calificacion,
          titulo: _tituloController.text,
          comentario: _comentarioController.text,
        );

    setState(() => _isLoading = false);

    if (success) {
      widget.onCreated();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear reseña')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Escribir reseña'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calificación
            Text(
              'Calificación:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => GestureDetector(
                    onTap: () => setState(() => _calificacion = index + 1),
                    child: Icon(
                      index < _calificacion
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Título
            Text(
              'Título:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _tituloController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Resumen de tu experiencia',
              ),
            ),
            SizedBox(height: 20),

            // Comentario
            Text(
              'Comentario:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _comentarioController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Cuéntanos más sobre tu experiencia...',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submitResena,
          child: _isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text('Enviar'),
        ),
      ],
    );
  }
}
