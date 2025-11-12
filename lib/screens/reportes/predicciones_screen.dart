import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PrediccionesScreen extends StatefulWidget {
  @override
  State<PrediccionesScreen> createState() => _PrediccionesScreenState();
}

class _PrediccionesScreenState extends State<PrediccionesScreen> {
  int _diasPrediccion = 30;
  String? _categoriaSeleccionada;
  String? _productoSeleccionado;

  // Datos de ejemplo
  final List<String> _categorias = ['Electrónica', 'Ropa', 'Alimentos', 'Todas'];
  final List<String> _productos = [
    'Producto A',
    'Producto B',
    'Producto C',
    'Todos'
  ];

  // Datos históricos y predicciones (ejemplo)
  final List<FlSpot> _datosHistoricos = [
    FlSpot(0, 100),
    FlSpot(1, 120),
    FlSpot(2, 115),
    FlSpot(3, 140),
    FlSpot(4, 135),
    FlSpot(5, 150),
    FlSpot(6, 145),
    FlSpot(7, 160),
    FlSpot(8, 155),
    FlSpot(9, 170),
  ];

  final List<FlSpot> _predicciones = [
    FlSpot(10, 165),
    FlSpot(11, 180),
    FlSpot(12, 190),
    FlSpot(13, 195),
    FlSpot(14, 200),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Predicciones de Ventas'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filtros
              Text(
                'Filtros',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 12),
              // Días de predicción (Slider)
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey[300]!),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Días a Predecir'),
                          Chip(
                            label: Text('$_diasPrediccion días'),
                            backgroundColor: Colors.blue,
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Slider(
                        value: _diasPrediccion.toDouble(),
                        min: 7,
                        max: 90,
                        divisions: 11,
                        label: '$_diasPrediccion días',
                        onChanged: (value) {
                          setState(() => _diasPrediccion = value.toInt());
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12),
              // Categoría y Producto
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: Text('Categoría'),
                      value: _categoriaSeleccionada,
                      items: _categorias
                          .map((cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(cat),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() => _categoriaSeleccionada = value);
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: Text('Producto'),
                      value: _productoSeleccionado,
                      items: _productos
                          .map((prod) => DropdownMenuItem(
                                value: prod,
                                child: Text(prod),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() => _productoSeleccionado = value);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              // Métricas del modelo
              Text(
                'Métricas del Modelo',
                style: Theme.of(context).textTheme.titleMedium,
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
                    title: 'MAE',
                    value: '8.5',
                    description: 'Error Medio Absoluto',
                  ),
                  _MetricCard(
                    title: 'RMSE',
                    value: '12.3',
                    description: 'Error Cuadrático Medio',
                  ),
                  _MetricCard(
                    title: 'Precisión',
                    value: '92.5%',
                    description: 'Exactitud del Modelo',
                  ),
                  _MetricCard(
                    title: 'Tendencia',
                    value: '+8.5%',
                    description: 'Crecimiento Esperado',
                  ),
                ],
              ),
              SizedBox(height: 24),
              // Gráfico de predicción
              Text(
                'Gráfico de Predicción',
                style: Theme.of(context).textTheme.titleMedium,
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
                                  '${value.toInt()}d',
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
                          // Datos históricos
                          LineChartBarData(
                            spots: _datosHistoricos,
                            isCurved: true,
                            color: Colors.blue,
                            barWidth: 3,
                            dotData: FlDotData(show: false),
                          ),
                          // Predicciones
                          LineChartBarData(
                            spots: _predicciones,
                            isCurved: true,
                            color: Colors.orange,
                            barWidth: 3,
                            dotData: FlDotData(show: true),
                            dashArray: [5, 5],
                          ),
                        ],
                        lineTouchData: LineTouchData(
                          enabled: true,
                          touchTooltipData: LineTouchTooltipData(
                            tooltipBgColor: Colors.grey[800] ?? Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              // Resumen de predicciones
              Text(
                'Resumen de Predicciones',
                style: Theme.of(context).textTheme.titleMedium,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ResumenItem(
                        label: 'Ventas Predichas',
                        valor: '${200 + (_diasPrediccion ~/ 10)} unidades',
                        icon: Icons.trending_up,
                        color: Colors.blue,
                      ),
                      SizedBox(height: 12),
                      _ResumenItem(
                        label: 'Ingresos Estimados',
                        valor:
                            '\$${((200 + (_diasPrediccion ~/ 10)) * 100).toStringAsFixed(0)}',
                        icon: Icons.attach_money,
                        color: Colors.green,
                      ),
                      SizedBox(height: 12),
                      _ResumenItem(
                        label: 'Pico de Demanda',
                        valor: 'Día ${5 + (_diasPrediccion ~/ 15)}',
                        icon: Icons.flag,
                        color: Colors.orange,
                      ),
                      SizedBox(height: 12),
                      _ResumenItem(
                        label: 'Banda de Confianza',
                        valor: '±${(5 + (_diasPrediccion ~/ 20)).toStringAsFixed(1)}%',
                        icon: Icons.info,
                        color: Colors.purple,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              // Botón de descargar reporte
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Descargando reporte de predicciones...'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: Icon(Icons.download),
                  label: Text('Descargar Reporte'),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String description;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.description,
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
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[500],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ResumenItem extends StatelessWidget {
  final String label;
  final String valor;
  final IconData icon;
  final Color color;

  const _ResumenItem({
    required this.label,
    required this.valor,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                valor,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
