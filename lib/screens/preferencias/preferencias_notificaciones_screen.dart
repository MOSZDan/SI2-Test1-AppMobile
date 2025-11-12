import 'package:flutter/material.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_widget.dart' as error_widget;

class PreferenciasNotificacionesScreen extends StatefulWidget {
  @override
  State<PreferenciasNotificacionesScreen> createState() =>
      _PreferenciasNotificacionesScreenState();
}

class _PreferenciasNotificacionesScreenState
    extends State<PreferenciasNotificacionesScreen> {
  bool _notificacionesPush = true;
  bool _notificacionesEmail = true;
  bool _pedidosConfirmacion = true;
  bool _pedidosEnvio = true;
  bool _pedidosEntrega = true;
  bool _promociones = true;
  bool _alertas = true;
  bool _novedades = false;
  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _cargarPreferencias();
  }

  Future<void> _cargarPreferencias() async {
    setState(() => _isLoading = true);
    try {
      // Aquí iría la llamada real al servicio
      // Por ahora usamos las preferencias por defecto
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _guardarPreferencias() async {
    setState(() => _isSaving = true);
    try {
      // Aquí iría la llamada real al servicio
      // NotificacionService.actualizarPreferencias({...})

      setState(() {
        _isSaving = false;
        _successMessage = 'Preferencias guardadas correctamente';
      });

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_successMessage!),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preferencias de Notificaciones'),
        elevation: 0,
      ),
      body: _isLoading
          ? LoadingIndicator(message: 'Cargando preferencias...')
          : _error != null
              ? error_widget.ErrorWidget(
                  message: _error ?? 'Error desconocido',
                  onRetry: _cargarPreferencias,
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      // Sección de canales
                      _buildSectionHeader('Canales de notificación'),
                      _buildSwitchTile(
                        icon: Icons.notifications,
                        title: 'Notificaciones Push',
                        subtitle:
                            'Recibe alertas en tu dispositivo móvil',
                        value: _notificacionesPush,
                        onChanged: (v) =>
                            setState(() => _notificacionesPush = v),
                      ),
                      Divider(height: 0),
                      _buildSwitchTile(
                        icon: Icons.email,
                        title: 'Notificaciones por Email',
                        subtitle: 'Recibe resúmenes y alertas por correo',
                        value: _notificacionesEmail,
                        onChanged: (v) =>
                            setState(() => _notificacionesEmail = v),
                      ),
                      SizedBox(height: 24),

                      // Sección de tipos de notificación
                      _buildSectionHeader('Tipos de notificaciones'),
                      _buildExpansionTile(
                        title: 'Notificaciones de Pedidos',
                        icon: Icons.shopping_bag,
                        children: [
                          _buildSwitchTile(
                            icon: Icons.check_circle,
                            title: 'Confirmación de Pedido',
                            subtitle:
                                'Cuando tu pedido ha sido confirmado',
                            value: _pedidosConfirmacion,
                            onChanged: (v) =>
                                setState(() => _pedidosConfirmacion = v),
                          ),
                          Divider(height: 0),
                          _buildSwitchTile(
                            icon: Icons.local_shipping,
                            title: 'Pedido en Envío',
                            subtitle: 'Cuando tu pedido está en camino',
                            value: _pedidosEnvio,
                            onChanged: (v) =>
                                setState(() => _pedidosEnvio = v),
                          ),
                          Divider(height: 0),
                          _buildSwitchTile(
                            icon: Icons.done_all,
                            title: 'Pedido Entregado',
                            subtitle: 'Cuando tu pedido ha sido entregado',
                            value: _pedidosEntrega,
                            onChanged: (v) =>
                                setState(() => _pedidosEntrega = v),
                          ),
                        ],
                      ),
                      Divider(height: 0),
                      _buildExpansionTile(
                        title: 'Otras Notificaciones',
                        icon: Icons.more_horiz,
                        children: [
                          _buildSwitchTile(
                            icon: Icons.local_offer,
                            title: 'Promociones y Ofertas',
                            subtitle: 'Descuentos especiales y promociones',
                            value: _promociones,
                            onChanged: (v) =>
                                setState(() => _promociones = v),
                          ),
                          Divider(height: 0),
                          _buildSwitchTile(
                            icon: Icons.warning,
                            title: 'Alertas',
                            subtitle: 'Problemas y alertas importantes',
                            value: _alertas,
                            onChanged: (v) => setState(() => _alertas = v),
                          ),
                          Divider(height: 0),
                          _buildSwitchTile(
                            icon: Icons.info,
                            title: 'Novedades',
                            subtitle: 'Nuevas características y actualizaciones',
                            value: _novedades,
                            onChanged: (v) =>
                                setState(() => _novedades = v),
                          ),
                        ],
                      ),
                      SizedBox(height: 32),

                      // Información adicional
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info, color: Colors.blue),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Puedes cambiar estas preferencias en cualquier momento. Siempre recibirás notificaciones importantes sobre tu cuenta.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.blue[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
      bottomSheet: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey[200]!),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _isSaving ? null : () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _isSaving ? null : _guardarPreferencias,
                child: _isSaving
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text('Guardar Cambios'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildExpansionTile({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.grey[600]),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        children: children,
      ),
    );
  }
}
