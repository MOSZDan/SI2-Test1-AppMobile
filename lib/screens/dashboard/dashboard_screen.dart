import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/producto_provider.dart';
import '../../widgets/producto_card.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_widget.dart' as custom_error;
import '../../widgets/dashboard_app_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late TextEditingController _searchController;
  int? _selectedCategoriaId;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    // Cargar datos
    Future.microtask(() {
      final productoProvider =
          Provider.of<ProductoProvider>(context, listen: false);
      productoProvider.cargarCategorias();
      productoProvider.cargarDashboard();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    final productoProvider =
        Provider.of<ProductoProvider>(context, listen: false);
    productoProvider.cargarDashboard(
      busqueda: value.isNotEmpty ? value : null,
      categoriaId: _selectedCategoriaId,
    );
  }

  void _onCategoriaChanged(int? categoriaId) {
    setState(() {
      _selectedCategoriaId = categoriaId;
    });
    final productoProvider =
        Provider.of<ProductoProvider>(context, listen: false);
    productoProvider.cargarDashboard(
      busqueda: _searchController.text.isNotEmpty
          ? _searchController.text
          : null,
      categoriaId: categoriaId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DashboardAppBar(
        title: 'SmartSales365',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Buscar productos...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
            ),

            // Estadísticas (Cards)
            Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      if (authProvider.isVendedor ||
                          authProvider.isAdmin) ...[
                        Row(
                          children: [
                            Expanded(
                              child: _StatisticCard(
                                title: 'Ventas',
                                value: '0',
                                icon: Icons.trending_up,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StatisticCard(
                                title: 'Ingresos',
                                value: '\$0.00',
                                icon: Icons.attach_money,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                      Row(
                        children: [
                          Expanded(
                            child: _StatisticCard(
                              title: 'Productos',
                              value: '0',
                              icon: Icons.shopping_bag_outlined,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatisticCard(
                              title: 'Pendientes',
                              value: '0',
                              icon: Icons.pending_actions,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Filtros
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Consumer<ProductoProvider>(
                builder: (context, productoProvider, _) {
                  return DropdownButton<int?>(
                    value: _selectedCategoriaId,
                    hint: const Text('Filtrar por categoría'),
                    isExpanded: true,
                    onChanged: _onCategoriaChanged,
                    items: [
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: Text('Todas las categorías'),
                      ),
                      ...productoProvider.categorias.map((categoria) {
                        return DropdownMenuItem<int>(
                          value: categoria.id,
                          child: Text(categoria.nombre),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Productos recomendados
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Productos Recomendados',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Consumer<ProductoProvider>(
                    builder: (context, productoProvider, _) {
                      if (productoProvider.isLoading) {
                        return const LoadingIndicator(
                          message: 'Cargando productos...',
                        );
                      }

                      if (productoProvider.error != null) {
                        return custom_error.ErrorWidget(
                          message: productoProvider.error ?? 'Error desconocido',
                          onRetry: () {
                            productoProvider.cargarDashboard();
                          },
                        );
                      }

                      if (productoProvider.productos.isEmpty) {
                        return Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.shopping_bag_outlined,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No hay productos disponibles',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: productoProvider.productos.length,
                        itemBuilder: (context, index) {
                          final producto =
                              productoProvider.productos[index];
                          return ProductoCard(
                            producto: producto,
                            onAddToCart: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${producto.nombre} agregado al carrito',
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _StatisticCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatisticCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
