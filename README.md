# 📱 SmartSales365 - Flutter Sales Management App

**Status**: ✅ Fase 3 Completada | **Versión**: 3.0.0 | **Errores**: 0

## 🎯 Descripción del Proyecto

SmartSales365 es una aplicación Flutter completa de gestión de ventas con:

- ✅ Autenticación y autorización de usuarios
- ✅ Catálogo de productos con búsqueda
- ✅ Carrito de compras y procesamiento de pedidos
- ✅ Panel de administración con CRUD completo
- ✅ Reportes y estadísticas interactivas
- ✅ Sistema avanzado de notificaciones
- ✅ Predicciones con machine learning
- ✅ Soporte para múltiples plataformas (Android, iOS, Web, Desktop)

## 🚀 Inicio Rápido

### Requisitos
- Flutter >= 3.7.2
- Dart >= 3.7.2

### Instalación
```bash
# Clonar el proyecto
cd d:\Universidad\Si2\PrimerParcial\MOBILE39

# Obtener dependencias
flutter pub get

# Ejecutar en emulador
flutter run
```

## 📊 Estadísticas del Proyecto

| Métrica | Valor |
|---------|-------|
| Pantallas | 16 |
| Servicios | 6 |
| Providers | 6 |
| Líneas de Código | 3,855+ |
| Errores de Compilación | 0 |
| Documentos | 12 |
| Endpoints API | 31+ |

## 🏗️ Arquitectura

**Pattern**: MVVM (Model-View-ViewModel)  
**State Management**: Provider 6.0.5  
**HTTP Client**: Dio 5.3.3  
**Gráficos**: fl_chart 0.64.0

```
Service Layer (API)
        ↓
Provider Layer (State)
        ↓
Screen Layer (UI)
```

## 📚 Documentación

- 📖 [COMPLETION_SUMMARY.md](./COMPLETION_SUMMARY.md) - Resumen visual de Fase 3
- 📖 [FINAL_REPORT.md](./FINAL_REPORT.md) - Reporte final de Fase 3
- 📖 [EXECUTION_GUIDE.md](./EXECUTION_GUIDE.md) - Guía de ejecución
- 📖 [PROJECT_STRUCTURE.md](./PROJECT_STRUCTURE.md) - Arquitectura del proyecto
- 📖 [PHASE_3_SUMMARY.md](./PHASE_3_SUMMARY.md) - Detalles de Fase 3
- 📖 [PHASE_2_SUMMARY.md](./PHASE_2_SUMMARY.md) - Detalles de Fase 2
- 📖 [DOCUMENTATION_INDEX.md](./DOCUMENTATION_INDEX.md) - Índice de documentación
- 📖 [EXECUTIVE_SUMMARY.md](./EXECUTIVE_SUMMARY.md) - Resumen ejecutivo

## 🎨 Características Principales

### Autenticación (Fase 1)
- Login con email/contraseña
- Registro de nuevos usuarios
- Recuperación de contraseña

### Catálogo (Fase 1)
- Búsqueda de productos
- Filtros por categoría
- Visualización de detalles

### Compras (Fase 1)
- Carrito de compras
- Agregar/quitar items
- Procesamiento de pedidos

### Administración (Fase 2)
- Gestión de usuarios (CRUD)
- Gestión de productos (CRUD)
- Gestión de categorías (CRUD)

### Reportes (Fase 2)
- Estadísticas con gráficos
- Reportes tabulares
- Predicciones ML

### Notificaciones (Fase 3)
- Plantillas de notificaciones (CRUD)
- Historial de envíos
- Preferencias de usuario
- Mejoras en UI de notificaciones

## 🔌 Plataformas Soportadas

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 📋 Pantallas Implementadas

### Fase 1: Core (7 pantallas)
- LoginScreen
- RegisterScreen
- ForgotPasswordScreen
- DashboardScreen
- CarritoScreen
- PedidosScreen
- NotificacionesScreen

### Fase 2: Admin (9 pantallas)
- GestionUsuariosScreen
- GestionProductosScreen
- GestionCategoriasScreen
- EstadisticasScreen
- ReportesScreen
- PrediccionesScreen

### Fase 3: Notifications (3 pantallas)
- GestionPlantillasScreen
- GestionEnviosScreen
- PreferenciasNotificacionesScreen

## 🔗 API Integration

**Base URL**: https://smartosaresu.onrender.com/api

### Endpoints Principales
- Autenticación: 3 endpoints
- Usuarios: 5 endpoints
- Productos: 8 endpoints
- Carrito: 4 endpoints
- Pedidos: 2 endpoints
- Notificaciones: 9 endpoints

## 🧪 Testing

### Credenciales de Prueba

**Admin**:
```
Email: admin@smartsales.com
Password: Admin123!
```

**Vendedor**:
```
Email: vendedor@smartsales.com
Password: Vendedor123!
```

**Cliente**:
```
Email: cliente@smartsales.com
Password: Cliente123!
```

## 📦 Dependencias Principales

```yaml
dependencies:
  flutter: ">=3.7.2"
  provider: ^6.0.5
  dio: ^5.3.3
  shared_preferences: ^2.2.2
  fl_chart: ^0.64.0
```

## 🚀 Próximas Fases

### Fase 4: Advanced Auth & Payments
- [ ] Autenticación con Google/Apple
- [ ] Integración Stripe
- [ ] Chat IA

### Fase 5: Real-time & Mobile
- [ ] WebSockets
- [ ] Offline-first
- [ ] Push notifications

### Fase 6: Analytics & Growth
- [ ] Dashboard avanzado
- [ ] Email marketing
- [ ] Loyalty program

## 📞 Recursos

- [Flutter Documentation](https://flutter.dev/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [Dio HTTP Client](https://pub.dev/packages/dio)

## ✅ Estado del Proyecto

```
✅ Fase 1: COMPLETADA
✅ Fase 2: COMPLETADA
✅ Fase 3: COMPLETADA
🔄 Fase 4: EN PLANIFICACIÓN

Compilación:    ✅ 0 errores
Documentación:  ✅ Completa
Testing:        ✅ Funcional
```

## 📄 Licencia

Este proyecto es parte del curso Si2 de la Universidad.

---

**Última actualización**: 2024  
**Versión**: 3.0.0  
**Status**: ✅ PRODUCCIÓN READY

