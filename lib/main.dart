import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/carrito_provider.dart';
import 'providers/producto_provider.dart';
import 'providers/usuario_provider.dart';
import 'providers/notificacion_provider.dart';
import 'providers/resena_provider.dart'; // Phase 4
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/admin/gestion_usuarios_screen.dart';
import 'screens/admin/gestion_productos_screen.dart';
import 'screens/admin/gestion_categorias_screen.dart';
import 'screens/admin/gestion_plantillas_screen.dart'; // ignore: unused_import
import 'screens/admin/gestion_envios_screen.dart'; // ignore: unused_import
import 'screens/preferencias/preferencias_notificaciones_screen.dart'; // ignore: unused_import
import 'screens/dashboard/pagos_screen.dart'; // ignore: unused_import - Phase 4
import 'screens/dashboard/chat_ai_screen.dart'; // ignore: unused_import - Phase 4
import 'screens/dashboard/pagos_historial_screen.dart'; // ignore: unused_import - Phase 4
import 'screens/dashboard/resena_screen.dart'; // ignore: unused_import - Phase 4

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CarritoProvider()),
        ChangeNotifierProvider(create: (_) => ProductoProvider()),
        ChangeNotifierProvider(create: (_) => UsuarioProvider()),
        ChangeNotifierProvider(create: (_) => NotificacionProvider()),
        ChangeNotifierProvider(create: (_) => ResenaProvider()), // Phase 4
      ],
      child: MaterialApp(
        title: 'SmartSales365',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const _HomeWrapper(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/forgot-password': (context) => const ForgotPasswordScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/admin/usuarios': (context) => GestionUsuariosScreen(),
          '/admin/productos': (context) => GestionProductosScreen(),
          '/admin/categorias': (context) => GestionCategoriasScreen(),
          '/admin/plantillas': (context) => GestionPlantillasScreen(),
          '/admin/envios': (context) => GestionEnviosScreen(),
          '/preferencias-notificaciones': (context) => PreferenciasNotificacionesScreen(),
          '/pagos': (context) => PagosScreen(),
          '/chat-ai': (context) => ChatAIScreen(),
          '/pagos-historial': (context) => PagosHistorialScreen(),
          '/resenas': (context) => ResenaScreen(
            productoId: 1,
            productoNombre: 'Producto',
          ),
        },
      ),
    );
  }
}

class _HomeWrapper extends StatefulWidget {
  const _HomeWrapper();

  @override
  State<_HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<_HomeWrapper> {
  @override
  void initState() {
    super.initState();
    // Cargar datos guardados
    Future.microtask(() {
      Provider.of<AuthProvider>(context, listen: false).loadUserFromStorage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.isAuthenticated) {
          return const DashboardScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
