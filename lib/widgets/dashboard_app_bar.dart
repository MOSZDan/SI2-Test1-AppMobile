import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onLogout;

  const DashboardAppBar({
    Key? key,
    required this.title,
    this.onLogout,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 12);

  void _showUserMenu(BuildContext context, AuthProvider auth) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Información del usuario
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${auth.usuario?.nombre} ${auth.usuario?.apellido}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 4),
                    Text(
                      auth.usuario?.email ?? '',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    SizedBox(height: 8),
                    Chip(
                      label: Text(auth.usuario?.rol?.descripcion ?? 'Usuario'),
                      backgroundColor: _getRolColor(auth),
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Divider(),
              // Opciones admin
              if (auth.isAdmin || auth.isVendedor) ...[
                ListTile(
                  leading: Icon(Icons.people),
                  title: Text('Gestión de Usuarios'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/admin/usuarios');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.shopping_bag),
                  title: Text('Gestión de Productos'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/admin/productos');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.category),
                  title: Text('Gestión de Categorías'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/admin/categorias');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.notifications_active),
                  title: Text('Gestión de Plantillas'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/admin/plantillas');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.mail_outline),
                  title: Text('Historial de Envíos'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/admin/envios');
                  },
                ),
                Divider(),
              ],
              // Opciones generales
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Preferencias de Notificaciones'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/preferencias-notificaciones');
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text(
                  'Cerrar sesión',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  auth.logout();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login',
                    (route) => false,
                  );
                },
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Color _getRolColor(AuthProvider auth) {
    if (auth.isAdmin) return Colors.red;
    if (auth.isVendedor) return Colors.orange;
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return AppBar(
          title: Text(title),
          elevation: 0,
          centerTitle: true,
          actions: [
            IconButton(
              icon: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.blue),
              ),
              onPressed: () => _showUserMenu(context, auth),
              tooltip: 'Menú de usuario',
            ),
          ],
        );
      },
    );
  }
}
