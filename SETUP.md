# SmartSales365 - Aplicación Flutter

Una aplicación móvil Flutter que se conecta al backend Django REST API de SmartSales365.

## 🚀 Instalación y Configuración

### Requisitos Previos

- Flutter SDK 3.7.2 o superior
- Dart 3.7.2 o superior
- Un dispositivo emulado o físico

### Paso 1: Obtener dependencias

```bash
flutter pub get
```

### Paso 2: Ejecutar la aplicación

```bash
flutter run
```

Para ejecución específica:

```bash
# En Android
flutter run -d android

# En iOS
flutter run -d ios

# En Web
flutter run -d chrome
```

## 📱 Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada
├── config/
│   ├── constants.dart       # Constantes de la app
│   └── theme.dart           # Tema global
├── models/
│   ├── usuario.dart         # Modelo de usuario
│   ├── producto.dart        # Modelo de producto y categoría
│   ├── carrito.dart         # Modelo de carrito
│   ├── pedido.dart          # Modelo de pedido
│   └── notificacion.dart    # Modelo de notificación
├── services/
│   ├── api_service.dart     # Cliente HTTP base
│   ├── auth_service.dart    # Servicios de autenticación
│   ├── producto_service.dart # Servicios de productos
│   ├── carrito_service.dart  # Servicios de carrito
│   ├── pedido_service.dart   # Servicios de pedidos
│   └── notificacion_service.dart # Servicios de notificaciones
├── providers/
│   ├── auth_provider.dart   # State management para auth
│   ├── carrito_provider.dart # State management para carrito
│   └── producto_provider.dart # State management para productos
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   └── forgot_password_screen.dart
│   ├── dashboard/
│   │   └── dashboard_screen.dart
│   ├── carrito/
│   │   └── carrito_screen.dart
│   ├── pedidos/
│   │   └── mis_pedidos_screen.dart
│   └── admin/
│       ├── gestion_usuarios_screen.dart
│       ├── gestion_productos_screen.dart
│       └── gestion_categorias_screen.dart
├── widgets/
│   ├── producto_card.dart
│   ├── loading_indicator.dart
│   └── error_widget.dart
└── utils/
    └── validators.dart
```

## 🔐 Configuración de API

### Base URL

La aplicación está configurada para conectarse a:

```
https://smartosaresu.onrender.com/api
```

### Header Requerido

Todos los endpoints autenticados requieren el header:

```
X-User-Email: usuario@email.com
```

Este header se configura automáticamente cuando el usuario inicia sesión.

### Endpoints Disponibles

Consulta `lib/services/` para ver los endpoints implementados:

- **Autenticación**: `POST /sync-stack-auth/`
- **Productos**: `GET/POST /productos/`, `GET /productos/dashboard/`
- **Categorías**: `GET/POST /categorias/`
- **Carrito**: `GET /carrito/mi_carrito/`, `POST /carrito/agregar_item/`
- **Pedidos**: `GET /pedidos/mis-pedidos/`, `POST /pedidos/create-checkout-session/`
- **Notificaciones**: `GET /notificaciones/`

## 🎨 Paleta de Colores

- **Color Principal**: `#ABC4FF` (Azul claro)
- **Color Secundario**: `#B6CCFE` (Azul más claro)
- **Color Acentuado**: `#6C5CE7` (Púrpura)

## 📦 Dependencias Principales

- **provider**: ^6.0.5 - State management
- **dio**: ^5.3.3 - Cliente HTTP
- **shared_preferences**: ^2.2.2 - Almacenamiento local
- **flutter_svg**: ^2.0.9 - Soporte para SVG
- **cached_network_image**: ^3.3.0 - Caché de imágenes
- **fl_chart**: ^0.64.0 - Gráficos
- **intl**: ^0.18.1 - Internacionalización

## 🔑 Stack Auth Integration

La aplicación está configurada para integración con Stack Auth:

- **Project ID**: `348e3f23-8198-4809-aaea-967b61e22fb2`
- **Publishable Key**: `pck_jvf06s21qyp325zf5011nqtd11g63rd6n8fmnj0jagg30`

> **Nota**: La integración completa de Stack Auth está pendiente en LoginScreen y RegisterScreen.

## 🧪 Desarrollo

### Hot Reload

La aplicación soporta hot reload. Después de hacer cambios, presiona `r` en la terminal.

### Hot Restart

Para reiniciar completamente la aplicación, presiona `R` en la terminal.

### Debugging

Para ejecutar la aplicación en modo debug:

```bash
flutter run
```

Para ejecutar en modo release:

```bash
flutter run --release
```

## 📝 Pantallas Implementadas

✅ **Autenticación**
- Login Screen
- Register Screen
- Forgot Password Screen

✅ **Dashboard**
- Dashboard Principal con productos y estadísticas

⏳ **En desarrollo**
- Pantalla de Carrito
- Mis Pedidos
- Gestión de Admin (usuarios, productos, categorías)
- Reportes y Estadísticas
- Chat IA
- Notificaciones

## 🐛 Troubleshooting

### Problema: "Target of URI doesn't exist"

**Solución**: Ejecuta `flutter pub get` para descargar las dependencias.

### Problema: Error de conexión a API

**Solución**: Verifica que:
1. El dispositivo tiene conexión a internet
2. La API está disponible en `https://smartosaresu.onrender.com`
3. El header `X-User-Email` está siendo enviado correctamente

### Problema: Estado de carrito no se actualiza

**Solución**: Asegúrate de que estés usando `Consumer<CarritoProvider>` en lugar de acceder directamente al provider.

## 📧 Contacto

Para preguntas o reportar issues, contacta al equipo de desarrollo.

---

**Última actualización**: 11 de Noviembre, 2025
**Estado del Proyecto**: 🚧 En Desarrollo - Fase 1 completada
