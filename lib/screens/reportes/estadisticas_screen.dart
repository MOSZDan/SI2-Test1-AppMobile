import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class EstadisticasScreen extends StatefulWidget {
  @override
  State<EstadisticasScreen> createState() => _EstadisticasScreenState();
}

class _EstadisticasScreenState extends State<EstadisticasScreen> {
  // Datos de ejemplo (en producción vendrían de la API)
  final List<String> _meses = [
    'Ene',
    'Feb',
    'Mar',
    'Abr',
    'May',
    'Jun',
    'Jul',
    'Ago',
    'Sep',
    'Oct',
    'Nov',
    'Dic'
  ];
  final List<double> _ventasData = [
    1200, 1500, 1100, 1800, 2100, 1900, 2300, 2100, 1800, 2200, 2400, 2100
  ];
  final List<double> _ingresoData = [
    12000, 15000, 11000, 18000, 21000, 19000, 23000, 21000, 18000, 22000, 24000, 21000
  ];

  late DateTime _fechaInicio;
  late DateTime _fechaFin;

  @override
  void initState() {
    super.initState();
    _fechaInicio = DateTime.now().subtract(Duration(days: 365));
    _fechaFin = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    // Calcular métricas
    final totalVentas = _ventasData.fold(0.0, (a, b) => a + b);
    final totalIngresos = _ingresoData.fold(0.0, (a, b) => a + b);
    final promedioVentas = totalVentas / _ventasData.length;
    final ventasMaximas = _ventasData.reduce((a, b) => a > b ? a : b);

    return Scaffold(
      appBar: AppBar(
        title: Text('Estadísticas de Ventas'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Selector de fechas
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final fecha = await showDatePicker(
                          context: context,
                          initialDate: _fechaInicio,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (fecha != null) {
                          setState(() => _fechaInicio = fecha);
                        }
                      },
                      icon: Icon(Icons.calendar_today),
                      label: Text('Desde'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final fecha = await showDatePicker(
                          context: context,
                          initialDate: _fechaFin,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (fecha != null) {
                          setState(() => _fechaFin = fecha);
                        }
                      },
                      icon: Icon(Icons.calendar_today),
                      label: Text('Hasta'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              // Métricas clave
              Text(
                'Métricas Clave',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  _MetricCard(
                    title: 'Total Ventas',
                    value: totalVentas.toStringAsFixed(0),
                    unit: 'unidades',
                    color: Colors.blue,
                    icon: Icons.trending_up,
                  ),
                  _MetricCard(
                    title: 'Ingresos',
                    value: '\$${(totalIngresos / 1000).toStringAsFixed(1)}K',
                    unit: 'total',
                    color: Colors.green,
                    icon: Icons.attach_money,
                  ),
                  _MetricCard(
                    title: 'Promedio Diario',
                    value: promedioVentas.toStringAsFixed(0),
                    unit: 'unidades',
                    color: Colors.orange,
                    icon: Icons.show_chart,
                  ),
                  _MetricCard(
                    title: 'Máximo Alcanzado',
                    value: ventasMaximas.toStringAsFixed(0),
                    unit: 'unidades',
                    color: Colors.purple,
                    icon: Icons.flag,
                  ),
                ],
              ),
              SizedBox(height: 24),
              // Gráfico de línea - Ventas por mes
              Text(
                'Ventas por Mes',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 12),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey[300]!),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    height: 300,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: true),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  _meses[value.toInt() % _meses.length],
                                  style: TextStyle(fontSize: 10),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: true),
                        lineBarsData: [
                          LineChartBarData(
                            spots: _ventasData
                                .asMap()
                                .entries
                                .map((e) => FlSpot(e.key.toDouble(), e.value))
                                .toList(),
                            isCurved: true,
                            color: Colors.blue,
                            barWidth: 3,
                            dotData: FlDotData(show: true),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              // Gráfico de pastel - Estado de pedidos
              Text(
                'Estado de Pedidos',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 12),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey[300]!),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    height: 300,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: 40,
                            title: 'Completado\n40%',
                            color: Colors.green,
                            radius: 100,
                          ),
                          PieChartSectionData(
                            value: 30,
                            title: 'Pendiente\n30%',
                            color: Colors.orange,
                            radius: 100,
                          ),
                          PieChartSectionData(
                            value: 20,
                            title: 'En Camino\n20%',
                            color: Colors.blue,
                            radius: 100,
                          ),
                          PieChartSectionData(
                            value: 10,
                            title: 'Cancelado\n10%',
                            color: Colors.red,
                            radius: 100,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              // Gráfico de barras - Top 5 productos
              Text(
                'Top 5 Productos Más Vendidos',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 12),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey[300]!),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    height: 300,
                    child: BarChart(
                      BarChartData(
                        barGroups: [
                          _createBarGroup(0, 450, 'Producto A'),
                          _createBarGroup(1, 380, 'Producto B'),
                          _createBarGroup(2, 320, 'Producto C'),
                          _createBarGroup(3, 290, 'Producto D'),
                          _createBarGroup(4, 250, 'Producto E'),
                        ],
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final productos = [
                                  'A',
                                  'B',
                                  'C',
                                  'D',
                                  'E'
                                ];
                                return Text(productos[value.toInt()]);
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(show: true),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData _createBarGroup(int x, double y, String label) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.blue,
          width: 20,
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final Color color;
  final IconData icon;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
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
