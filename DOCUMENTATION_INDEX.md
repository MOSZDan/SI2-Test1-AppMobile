# 📚 ÍNDICE DE DOCUMENTACIÓN - SmartSales365 Flutter

## 🎯 Comienza Aquí

Si es tu **primera vez** en este proyecto, lee estos documentos en orden:

1. **[EXECUTIVE_SUMMARY.md](EXECUTIVE_SUMMARY.md)** ⭐ *5 min*
   - Resumen ejecutivo del proyecto
   - Progreso y estado actual
   - Características principales

2. **[SETUP.md](SETUP.md)** ⭐ *5 min*
   - Instalación y configuración
   - Cómo ejecutar la app
   - Estructura básica

3. **[PROJECT_STATUS.md](PROJECT_STATUS.md)** *10 min*
   - Estado detallado del proyecto
   - Checklist de funcionalidades
   - Bugs conocidos

---

## 👨‍💻 Para Desarrolladores

### Empezando con el Desarrollo
- **[SETUP.md](SETUP.md)** - Instalación y configuración
- **[USEFUL_COMMANDS.md](USEFUL_COMMANDS.md)** - Comandos útiles diarios
- **[lib/main.dart](lib/main.dart)** - Punto de entrada de la app

### Entendiendo la Arquitectura
- **[IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)** - Resumen técnico
- **[lib/config/](lib/config/)** - Constantes y tema
- **[lib/services/](lib/services/)** - Cómo funcionan los servicios API
- **[lib/providers/](lib/providers/)** - State management

### Estructura de Código
```
lib/
├── config/              # Constantes y tema
├── models/              # Modelos de datos
├── services/            # Servicios API
├── providers/           # State Management
├── screens/             # Pantallas de la app
├── widgets/             # Widgets reutilizables
└── utils/               # Utilidades
```

---

## 🎨 Diseño & UI

### Colores
- 🔵 **Primario**: #ABC4FF (Azul claro)
- 🔵 **Secundario**: #B6CCFE (Azul más claro)
- 🟣 **Acentuado**: #6C5CE7 (Púrpura)

### Tipografía
- **Font**: Inter (Google Fonts)
- **Diseño**: Material 3

Véase: **[lib/config/theme.dart](lib/config/theme.dart)**

---

## 📱 Pantallas Implementadas

### ✅ Autenticación (8% completada)
- **[LoginScreen](lib/screens/auth/login_screen.dart)** - Login con email/contraseña
- **[RegisterScreen](lib/screens/auth/register_screen.dart)** - Registro de usuarios
- **[ForgotPasswordScreen](lib/screens/auth/forgot_password_screen.dart)** - Recuperación de contraseña

### ✅ Tienda (70% completada)
- **[DashboardScreen](lib/screens/dashboard/dashboard_screen.dart)** - Página principal
- **[CarritoScreen](lib/screens/carrito/carrito_screen.dart)** - Carrito de compras
- **[MisPedidosScreen](lib/screens/pedidos/mis_pedidos_screen.dart)** - Mis pedidos

### ✅ Otras (50% completada)
- **[NotificacionesScreen](lib/screens/notificaciones/notificaciones_screen.dart)** - Centro de notificaciones

### ⏳ Admin (0% completada)
Véase: **[ADMIN_SCREENS_GUIDE.md](ADMIN_SCREENS_GUIDE.md)**

---

## 🔌 Integración API

### Base URL
```
https://smartosaresu.onrender.com/api
```

### Servicios Disponibles
- **[AuthService](lib/services/auth_service.dart)** - Autenticación
- **[UsuarioService](lib/services/usuario_service.dart)** - Gestión de usuarios
- **[ProductoService](lib/services/producto_service.dart)** - Productos y categorías
- **[CarritoService](lib/services/carrito_service.dart)** - Carrito
- **[PedidoService](lib/services/pedido_service.dart)** - Pedidos
- **[NotificacionService](lib/services/notificacion_service.dart)** - Notificaciones

Véase: **[lib/services/api_service.dart](lib/services/api_service.dart)** para el cliente base

---

## 📊 State Management

### Providers Implementados
1. **[AuthProvider](lib/providers/auth_provider.dart)** - Autenticación y usuario actual
2. **[UsuarioProvider](lib/providers/usuario_provider.dart)** - Gestión de usuarios
3. **[CarritoProvider](lib/providers/carrito_provider.dart)** - Carrito de compras
4. **[ProductoProvider](lib/providers/producto_provider.dart)** - Productos

Utilizamos **Provider** por su:
- ✨ Simplicidad
- ✨ Rendimiento
- ✨ Escalabilidad

---

## 🛠️ Desarrollo

### Comandos Esenciales
```bash
flutter pub get          # Descargar dependencias
flutter run              # Ejecutar la app
flutter run --release   # Ejecutar en release
flutter analyze          # Analizar código
dart format lib/         # Formatear código
flutter test             # Ejecutar tests
```

Véase: **[USEFUL_COMMANDS.md](USEFUL_COMMANDS.md)** para más comandos

---

## 📖 Modelos de Datos

| Modelo | Archivo | Descripción |
|--------|---------|-------------|
| Usuario | [usuario.dart](lib/models/usuario.dart) | Usuario + Rol |
| Producto | [producto.dart](lib/models/producto.dart) | Producto + Categoría |
| Carrito | [carrito.dart](lib/models/carrito.dart) | Carrito + Items |
| Pedido | [pedido.dart](lib/models/pedido.dart) | Pedido + Items |
| Notificación | [notificacion.dart](lib/models/notificacion.dart) | Notificación |

---

## 🧩 Widgets Reutilizables

| Widget | Archivo | Uso |
|--------|---------|-----|
| ProductoCard | [producto_card.dart](lib/widgets/producto_card.dart) | Card de producto |
| LoadingIndicator | [loading_indicator.dart](lib/widgets/loading_indicator.dart) | Indicador de carga |
| ErrorWidget | [error_widget.dart](lib/widgets/error_widget.dart) | Mensaje de error |

---

## 🔐 Seguridad

### Headers Requeridos
```
X-User-Email: usuario@email.com
```

Se configura automáticamente en:
- **[ApiService](lib/services/api_service.dart)** - `setUserEmail()`
- **[AuthProvider](lib/providers/auth_provider.dart)** - Al hacer login

### Stack Auth Integration
- **Project ID**: 348e3f23-8198-4809-aaea-967b61e22fb2
- **Publishable Key**: pck_jvf06s21qyp325zf5011nqtd11g63rd6n8fmnj0jagg30
- **Estado**: Pendiente de integración en screens de auth

---

## 📚 Documentación Detallada

| Documento | Contenido | Duración |
|-----------|----------|----------|
| [EXECUTIVE_SUMMARY.md](EXECUTIVE_SUMMARY.md) | Resumen ejecutivo | 5 min |
| [SETUP.md](SETUP.md) | Instalación y setup | 5 min |
| [PROJECT_STATUS.md](PROJECT_STATUS.md) | Estado del proyecto | 10 min |
| [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) | Resumen técnico | 15 min |
| [ADMIN_SCREENS_GUIDE.md](ADMIN_SCREENS_GUIDE.md) | Guía de admin | 10 min |
| [USEFUL_COMMANDS.md](USEFUL_COMMANDS.md) | Comandos útiles | 5 min |

---

## 🎯 Próximas Fases

### Fase 2: Pantallas de Admin (Próxima)
- Gestión de usuarios
- Gestión de productos
- Gestión de categorías
- Gestión de roles

Véase: **[ADMIN_SCREENS_GUIDE.md](ADMIN_SCREENS_GUIDE.md)**

### Fase 3: Reportes y Gráficos
- Estadísticas
- Gráficos con fl_chart
- Exportación PDF/CSV

### Fase 4: Features Avanzadas
- Integración Stack Auth
- Integración Stripe
- Notificaciones push
- WebSocket tiempo real
- Chat IA

---

## 🐛 Troubleshooting

### "Target of URI doesn't exist"
```bash
flutter pub get
```

### "No es compilable"
```bash
flutter clean
flutter pub get
flutter run
```

### "No hay dispositivos"
```bash
flutter devices
flutter emulators --launch <nombre>
```

Véase: **[USEFUL_COMMANDS.md](USEFUL_COMMANDS.md)** para más soluciones

---

## 💡 Tips

1. **Hot reload es tu amigo**: Presiona `r` para hot reload durante desarrollo
2. **Usa `flutter analyze`**: Antes de hacer commit
3. **Lee el code**: Estudia `lib/screens/` para entender patrones
4. **Prueba en múltiples dispositivos**: Web, Android, iOS si es posible
5. **Mantén la documentación actualizada**: Cuando hagas cambios

---

## 📞 Contacto & Soporte

Para preguntas:
1. Revisar documentación relevante arriba
2. Buscar ejemplos en `lib/screens/`
3. Consultar `ADMIN_SCREENS_GUIDE.md` para nuevas features
4. Usar `USEFUL_COMMANDS.md` para troubleshooting

---

## ✅ Checklist de Lectura Inicial

- [ ] Leí EXECUTIVE_SUMMARY.md
- [ ] Leí SETUP.md
- [ ] Configuré la app con `flutter pub get`
- [ ] Ejecuté `flutter run` exitosamente
- [ ] Exploré lib/ structure
- [ ] Leí PROJECT_STATUS.md
- [ ] Guardé ADMIN_SCREENS_GUIDE.md para referencia
- [ ] Guardé USEFUL_COMMANDS.md para referencia

---

## 📊 Documentación por Rol

### 👨‍💼 Project Manager
→ **[EXECUTIVE_SUMMARY.md](EXECUTIVE_SUMMARY.md)** (progreso y status)

### 👨‍💻 Developer Frontend
→ **[SETUP.md](SETUP.md)** → **[USEFUL_COMMANDS.md](USEFUL_COMMANDS.md)** → **[lib/screens/](lib/screens/)**

### 👨‍💻 Developer Backend
→ **[IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)** → **[lib/services/](lib/services/)**

### 🏗️ Architect
→ **[PROJECT_STATUS.md](PROJECT_STATUS.md)** → **[IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)**

### 🎓 Nuevo en el Proyecto
→ **[EXECUTIVE_SUMMARY.md](EXECUTIVE_SUMMARY.md)** → **[SETUP.md](SETUP.md)** → Explorar código

---

## 🎉 ¡Bienvenido al Proyecto!

Esperamos que esta documentación te ayude a entender y contribuir al desarrollo de **SmartSales365 Flutter**.

Si tienes preguntas, **no dudes en consultarla nuevamente** - la encontrarás bien estructurada para referencia rápida.

---

**Última actualización**: 11 de Noviembre, 2025  
**Versión del Proyecto**: 1.0.0  
**Fase**: 1 (Completa) → 2 (Próxima)

**¡Que disfrutes desarrollando!** 🚀
