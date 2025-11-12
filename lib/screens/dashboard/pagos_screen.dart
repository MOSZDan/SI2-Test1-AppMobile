import 'package:flutter/material.dart';
import '../../services/stripe_service.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_widget.dart' as error_widget;

class PagosScreen extends StatefulWidget {
  @override
  State<PagosScreen> createState() => _PagosScreenState();
}

class _PagosScreenState extends State<PagosScreen> {
  List<Map<String, dynamic>> _metodoPagos = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarMetodos();
  }

  Future<void> _cargarMetodos() async {
    setState(() => _isLoading = true);
    try {
      // Mock data para desarrollo
      _metodoPagos = [
        {
          'id': '1',
          'tipo': 'Visa',
          'ultimos_4': '4242',
          'expiry': '12/25',
          'nombre': 'Tarjeta Principal',
          'por_defecto': true,
        },
        {
          'id': '2',
          'tipo': 'Mastercard',
          'ultimos_4': '5555',
          'expiry': '06/24',
          'nombre': 'Tarjeta Secundaria',
          'por_defecto': false,
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

  void _mostrarFormularioAgregarTarjeta() {
    final _formKey = GlobalKey<FormState>();
    String _numero = '';
    String _nombre = '';
    String _expiry = '';
    String _cvc = '';
    String _apodo = '';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Agregar Tarjeta de Crédito'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Nombre del Titular'),
                    validator: (v) =>
                        v?.isEmpty ?? true ? 'Requerido' : null,
                    onSaved: (v) => _nombre = v ?? '',
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Número de Tarjeta',
                      hintText: '1234 5678 9012 3456',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v?.isEmpty ?? true) return 'Requerido';
                      if (!StripeService.validateCardNumber(v!)) {
                        return 'Tarjeta inválida';
                      }
                      return null;
                    },
                    onChanged: (v) => _numero = v,
                    onSaved: (v) => _numero = v ?? '',
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'MM/YY',
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 5,
                          validator: (v) =>
                              v?.isEmpty ?? true ? 'Requerido' : null,
                          onSaved: (v) => _expiry = v ?? '',
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'CVC',
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          obscureText: true,
                          validator: (v) =>
                              v?.isEmpty ?? true ? 'Requerido' : null,
                          onSaved: (v) => _cvc = v ?? '',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: 'Apodo (ej: Mi VISA)'),
                    validator: (v) =>
                        v?.isEmpty ?? true ? 'Requerido' : null,
                    onSaved: (v) => _apodo = v ?? '',
                  ),
                  SizedBox(height: 12),
                  if (_numero.isNotEmpty)
                    Chip(
                      label: Text(
                          '${StripeService.getCardType(_numero)} •••• ${_numero.length >= 4 ? _numero.substring(_numero.length - 4) : _numero}'),
                      backgroundColor: Colors.blue[100],
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
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Navigator.pop(dialogContext);
                  _agregarTarjeta(_numero, _nombre, _expiry, _cvc, _apodo);
                }
              },
              child: Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _agregarTarjeta(String numero, String nombre, String expiry,
      String cvc, String apodo) async {
    try {
      // Aquí iría la llamada a StripeService.savePaymentMethod()
      setState(() {
        _metodoPagos.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'tipo': StripeService.getCardType(numero),
          'ultimos_4': numero.substring(numero.length - 4),
          'expiry': expiry,
          'nombre': apodo,
          'por_defecto': false,
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tarjeta agregada correctamente'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _eliminarMetodo(String id) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Eliminar Método de Pago'),
          content: Text('¿Deseas eliminar este método de pago?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                setState(() {
                  _metodoPagos.removeWhere((m) => m['id'] == id);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Método de pago eliminado'),
                    backgroundColor: Colors.green,
                  ),
                );
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

  void _establecerPorDefecto(String id) {
    setState(() {
      for (var metodo in _metodoPagos) {
        metodo['por_defecto'] = metodo['id'] == id;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Método establecido como predeterminado'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Métodos de Pago'),
        elevation: 0,
      ),
      body: _isLoading
          ? LoadingIndicator(message: 'Cargando métodos de pago...')
          : _error != null
              ? error_widget.ErrorWidget(
                  message: _error ?? 'Error desconocido',
                  onRetry: _cargarMetodos,
                )
              : Column(
                  children: [
                    Expanded(
                      child: _metodoPagos.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.payment,
                                      size: 64, color: Colors.grey),
                                  SizedBox(height: 16),
                                  Text('No hay métodos de pago',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                  SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: _mostrarFormularioAgregarTarjeta,
                                    child: Text('Agregar Método'),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.all(16),
                              itemCount: _metodoPagos.length,
                              itemBuilder: (context, index) {
                                final metodo = _metodoPagos[index];
                                return Card(
                                  margin: EdgeInsets.only(bottom: 12),
                                  child: ListTile(
                                    leading: Icon(
                                      _getIconoTarjeta(metodo['tipo']),
                                      color: Colors.blue,
                                      size: 32,
                                    ),
                                    title: Text(metodo['nombre']),
                                    subtitle: Text(
                                      '${metodo['tipo']} •••• ${metodo['ultimos_4']} • Vence ${metodo['expiry']}',
                                    ),
                                    trailing: metodo['por_defecto']
                                        ? Chip(
                                            label: Text('Por defecto',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            backgroundColor: Colors.green,
                                          )
                                        : null,
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return SafeArea(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ListTile(
                                                  leading: Icon(Icons.check),
                                                  title: Text(
                                                      'Establecer como predeterminado'),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    _establecerPorDefecto(
                                                        metodo['id']);
                                                  },
                                                ),
                                                ListTile(
                                                  leading: Icon(Icons.delete,
                                                      color: Colors.red),
                                                  title: Text('Eliminar',
                                                      style: TextStyle(
                                                          color: Colors.red)),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    _eliminarMetodo(
                                                        metodo['id']);
                                                  },
                                                ),
                                                SizedBox(height: 12),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarFormularioAgregarTarjeta,
        child: Icon(Icons.add),
        tooltip: 'Agregar método de pago',
      ),
    );
  }

  IconData _getIconoTarjeta(String tipo) {
    switch (tipo) {
      case 'Visa':
        return Icons.credit_card;
      case 'Mastercard':
        return Icons.credit_card;
      case 'American Express':
        return Icons.credit_card;
      default:
        return Icons.payment;
    }
  }
}
