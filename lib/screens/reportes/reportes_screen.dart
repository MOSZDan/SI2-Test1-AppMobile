import 'package:flutter/material.dart';

class ReportesScreen extends StatefulWidget {
  @override
  State<ReportesScreen> createState() => _ReportesScreenState();
}

class _ReportesScreenState extends State<ReportesScreen> {
  String _tipoReporte = 'ventas';
  late DateTime _fechaInicio;
  late DateTime _fechaFin;

  @override
  void initState() {
    super.initState();
    _fechaInicio = DateTime.now().subtract(Duration(days: 30));
    _fechaFin = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reportes'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Selector de tipo de reporte
              Text(
                'Tipo de Reporte',
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
                  _ReporteTile(
                    title: 'Ventas por Período',
                    icon: Icons.trending_up,
                    isSelected: _tipoReporte == 'ventas',
                    onTap: () => setState(() => _tipoReporte = 'ventas'),
                  ),
                  _ReporteTile(
                    title: 'Productos Vendidos',
                    icon: Icons.shopping_bag,
                    isSelected: _tipoReporte == 'productos',
                    onTap: () => setState(() => _tipoReporte = 'productos'),
                  ),
                  _ReporteTile(
                    title: 'Ingresos por Vendedor',
                    icon: Icons.people,
                    isSelected: _tipoReporte == 'vendedores',
                    onTap: () => setState(() => _tipoReporte = 'vendedores'),
                  ),
                  _ReporteTile(
                    title: 'Clientes Frecuentes',
                    icon: Icons.person_add,
                    isSelected: _tipoReporte == 'clientes',
                    onTap: () => setState(() => _tipoReporte = 'clientes'),
                  ),
                ],
              ),
              SizedBox(height: 24),
              // Filtros
              Text(
                'Filtros',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 12),
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
                          firstDate: _fechaInicio,
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
              // Tabla de resultados
              Text(
                'Resultados',
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
                  child: _buildResultTable(),
                ),
              ),
              SizedBox(height: 24),
              // Botones de exportación
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Exportando a PDF...'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: Icon(Icons.picture_as_pdf),
                      label: Text('Exportar PDF'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Exportando a CSV...'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: Icon(Icons.table_chart),
                      label: Text('Exportar CSV'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultTable() {
    switch (_tipoReporte) {
      case 'ventas':
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text('Período')),
              DataColumn(label: Text('Ventas')),
              DataColumn(label: Text('Ingresos')),
              DataColumn(label: Text('Ticket Promedio')),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Text('Nov 2025')),
                DataCell(Text('125')),
                DataCell(Text('\$12,500')),
                DataCell(Text('\$100')),
              ]),
              DataRow(cells: [
                DataCell(Text('Oct 2025')),
                DataCell(Text('118')),
                DataCell(Text('\$11,800')),
                DataCell(Text('\$100')),
              ]),
              DataRow(cells: [
                DataCell(Text('Sep 2025')),
                DataCell(Text('132')),
                DataCell(Text('\$13,200')),
                DataCell(Text('\$100')),
              ]),
            ],
          ),
        );
      case 'productos':
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text('Producto')),
              DataColumn(label: Text('Cantidad')),
              DataColumn(label: Text('Ingresos')),
              DataColumn(label: Text('% Total')),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Text('Producto A')),
                DataCell(Text('450')),
                DataCell(Text('\$4,500')),
                DataCell(Text('35%')),
              ]),
              DataRow(cells: [
                DataCell(Text('Producto B')),
                DataCell(Text('380')),
                DataCell(Text('\$3,800')),
                DataCell(Text('30%')),
              ]),
              DataRow(cells: [
                DataCell(Text('Producto C')),
                DataCell(Text('320')),
                DataCell(Text('\$3,200')),
                DataCell(Text('25%')),
              ]),
            ],
          ),
        );
      case 'vendedores':
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text('Vendedor')),
              DataColumn(label: Text('Ventas')),
              DataColumn(label: Text('Ingresos')),
              DataColumn(label: Text('Comisión')),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Text('Juan Pérez')),
                DataCell(Text('45')),
                DataCell(Text('\$4,500')),
                DataCell(Text('\$450')),
              ]),
              DataRow(cells: [
                DataCell(Text('María García')),
                DataCell(Text('38')),
                DataCell(Text('\$3,800')),
                DataCell(Text('\$380')),
              ]),
              DataRow(cells: [
                DataCell(Text('Carlos López')),
                DataCell(Text('32')),
                DataCell(Text('\$3,200')),
                DataCell(Text('\$320')),
              ]),
            ],
          ),
        );
      case 'clientes':
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text('Cliente')),
              DataColumn(label: Text('Compras')),
              DataColumn(label: Text('Gasto Total')),
              DataColumn(label: Text('Promedio')),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Text('Cliente 1')),
                DataCell(Text('12')),
                DataCell(Text('\$1,200')),
                DataCell(Text('\$100')),
              ]),
              DataRow(cells: [
                DataCell(Text('Cliente 2')),
                DataCell(Text('10')),
                DataCell(Text('\$950')),
                DataCell(Text('\$95')),
              ]),
              DataRow(cells: [
                DataCell(Text('Cliente 3')),
                DataCell(Text('8')),
                DataCell(Text('\$750')),
                DataCell(Text('\$94')),
              ]),
            ],
          ),
        );
      default:
        return Text('Selecciona un tipo de reporte');
    }
  }
}

class _ReporteTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ReporteTile({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: isSelected ? 4 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color:
                isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: isSelected ? Colors.blue : Colors.grey[600],
              ),
              SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.blue : null,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
