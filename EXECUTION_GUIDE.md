# 🚀 Guía de Ejecución - SmartSales365

## ✅ Requisitos Previos

### Software Requerido
- **Flutter**: >= 3.7.2
- **Dart**: >= 3.7.2
- **Android Studio** o **Xcode** (para emuladores)
- **VS Code** o **Android Studio** (editor)
- **Git** (opcional, para versionamiento)

### Verificar Instalación
```powershell
# En PowerShell (Windows)
flutter --version
dart --version
flutter doctor  # Verificar dependencias
```

---

## 📥 Instalación y Setup

### 1. Clonar o Descargar el Proyecto
```powershell
# Navegar al directorio del proyecto
cd d:\Universidad\Si2\PrimerParcial\MOBILE39
```

### 2. Obtener Dependencias
```powershell
# Descargar/actualizar todas las dependencias
flutter pub get
```

### 3. Verificar Compilación
```powershell
# Analizar el código sin compilar
flutter analyze

# Compilar para verificar sintaxis (sin ejecutar)
flutter build apk --analyze-size  # Android
flutter build ios --analyze-size  # iOS
```

---

## ▶️ Ejecutar la Aplicación

### Opción 1: En Emulador Android
```powershell
# Listar emuladores disponibles
flutter emulators

# Ejecutar emulador específico
flutter emulators --launch emulator-5554

# Ejecutar la app en el emulador
flutter run

# Con modo hot reload (presiona 'r' para recargar código)
# Presiona 'q' para salir
```

### Opción 2: En Dispositivo Físico Android
```powershell
# Conectar dispositivo via USB
# Habilitar "Depuración USB" en Opciones de Desarrollador

# Listar dispositivos conectados
flutter devices

# Ejecutar en el dispositivo
flutter run -d <device-id>
```

### Opción 3: En Emulador/Simulador iOS
```powershell
# Requiere macOS

# Listar simuladores disponibles
xcrun simctl list devices

# Ejecutar en simulador
flutter run -d <simulador-id>
```

### Opción 4: En Navegador (Web)
```powershell
# Habilitar web (si no está habilitado)
flutter config --enable-web

# Ejecutar en navegador Chrome
flutter run -d chrome

# Ejecutar en navegador Firefox
flutter run -d firefox
```

---

## 🔑 Prueba de Características

### Credenciales de Prueba

#### Admin
```
Email: admin@smartsales.com
Password: Admin123!
Rol: ADMIN
```

#### Vendedor
```
Email: vendedor@smartsales.com
Password: Vendedor123!
Rol: VENDEDOR
```

#### Cliente
```
Email: cliente@smartsales.com
Password: Cliente123!
Rol: CLIENTE
```

---

## 🎯 Flujos de Prueba

### 1. Autenticación
```
1. Seleccionar pantalla de login
2. Ingresar credenciales de prueba
3. Presionar "Iniciar Sesión"
4. Validar que lleva al Dashboard
5. Cerrar sesión (menú de usuario)
```

### 2. Compra (Cliente)
```
1. En Dashboard, ver lista de productos
2. Buscar un producto (campo de búsqueda)
3. Agregar producto al carrito
4. Ir a Carrito y aumentar cantidad
5. Crear pedido
6. Ver pedido en Pedidos
```

### 3. Administración de Usuarios (Admin)
```
1. Menú de usuario → "Gestión de Usuarios"
2. Ver tabla de usuarios
3. Filtrar por rol
4. Crear nuevo usuario (botón +)
5. Editar usuario existente
6. Eliminar usuario con confirmación
```

### 4. Administración de Productos (Admin)
```
1. Menú de usuario → "Gestión de Productos"
2. Ver lista de productos con categoría
3. Filtrar por categoría
4. Buscar producto
5. Crear producto
6. Editar producto existente
7. Eliminar producto
```

### 5. Categorías (Admin)
```
1. Menú de usuario → "Gestión de Categorías"
2. Ver categorías con contador de productos
3. Crear nueva categoría
4. Editar categoría
5. Intentar eliminar categoría con productos (validación)
6. Eliminar categoría sin productos
```

### 6. Reportes (Admin/Vendedor)
```
1. Menú de usuario → "Estadísticas"
   - Ver 4 gráficos diferentes
   - Cambiar rango de fechas
   - Hoover en gráficos para ver detalles

2. Menú de usuario → "Reportes"
   - Seleccionar tipo de reporte
   - Ver tabla con datos
   - Exportar a CSV/PDF (si está implementado)

3. Menú de usuario → "Predicciones"
   - Mover slider de días (7-90)
   - Cambiar filtros
   - Ver métricas de error
   - Ver gráfico de predicción
```

### 7. Notificaciones
```
1. En Dashboard, ir a pestaña Notificaciones
2. Ver lista de notificaciones con tipos
3. Presionar menú (⋮) en notificación
4. Marcar como leída (si está sin leer)
5. Eliminar notificación
6. Validar confirmación antes de eliminar
```

### 8. Gestión de Plantillas (Admin)
```
1. Menú de usuario → "Gestión de Plantillas"
2. Ver tabla de plantillas existentes
3. Buscar plantilla por nombre
4. Crear plantilla:
   - Presionar botón +
   - Llenar formulario (Tipo, Título, Mensaje)
   - Guardar
5. Editar plantilla:
   - Presionar ✏️ en fila
   - Cambiar campos
   - Guardar
6. Eliminar plantilla:
   - Presionar 🗑️
   - Confirmar eliminación
```

### 9. Historial de Envíos (Admin)
```
1. Menú de usuario → "Historial de Envíos"
2. Ver tabla con envíos
3. Filtrar por Estado
4. Filtrar por Tipo
5. Buscar por destinatario o plantilla
6. Presionar 'i' para ver detalles del envío
```

### 10. Preferencias de Notificaciones (Todos)
```
1. Menú de usuario → "Preferencias de Notificaciones"
2. Alternar "Notificaciones Push"
3. Alternar "Notificaciones por Email"
4. Expandir "Notificaciones de Pedidos"
5. Alternar cada opción de pedido
6. Expandir "Otras Notificaciones"
7. Alternar Promociones, Alertas, Novedades
8. Presionar "Guardar Cambios"
9. Validar SnackBar de confirmación
```

---

## 🐛 Debugging y Solución de Problemas

### Error: "No se puede conectar a la API"
```powershell
# Verificar que el backend está en ejecución
# En emulador, usar: http://10.0.2.2:puerto en lugar de localhost

# En archivo de servicio, cambiar:
# http://localhost:3000 → http://10.0.2.2:3000
```

### Error: "Compilación fallida"
```powershell
# Limpiar build anterior
flutter clean

# Obtener dependencias de nuevo
flutter pub get

# Intentar compilar nuevamente
flutter run
```

### Hot Reload no funciona
```powershell
# Presionar 'R' en lugar de 'r'
# Si persiste, presionar 'q' y ejecutar de nuevo: flutter run
```

### Dispositivo/Emulador no detectado
```powershell
# Listar dispositivos conectados
flutter devices

# Reiniciar el bridge ADB (Android)
adb kill-server
adb start-server
```

---

## 📊 Verificación de Compilación

### Ejecutar Análisis de Código
```powershell
# Análisis estático del código
flutter analyze

# Debería mostrar 0 errores
# Algunos warnings son normales
```

### Ver Errores Específicos
```powershell
# En VS Code: Terminal → Run Build Task
# O en terminal: flutter run --verbose
```

---

## 🔄 Hot Reload vs Hot Restart

### Hot Reload (Recomendado)
```
Presionar: r
- Mantiene el estado de la app
- Solo recarga el código
- Más rápido (< 1 segundo)
- No reinicia la app
```

### Hot Restart
```
Presionar: R
- Reinicia completamente la app
- Limpia el estado
- Más lento (2-3 segundos)
- Útil si hot reload no funciona
```

### Salir
```
Presionar: q
- Detiene la ejecución
```

---

## 📱 Construcción de Release

### Android APK
```powershell
# Crear APK de release
flutter build apk --release

# El archivo estará en:
# build/app/outputs/flutter-apk/app-release.apk
```

### iOS IPA
```powershell
# Requiere macOS
flutter build ios --release

# Seguir instrucciones de Xcode para publicar
```

### Web
```powershell
# Compilar para web
flutter build web

# Los archivos estarán en: build/web/
```

---

## 🧪 Testing (Opcional)

### Ejecutar Unit Tests
```powershell
# Ejecutar todos los tests
flutter test

# Ejecutar test específico
flutter test test/models/usuario_test.dart
```

### Ejecutar Integration Tests
```powershell
# Requiere setup adicional
flutter drive --target=test_driver/app.dart
```

---

## 📚 Documentación Generada

El proyecto incluye 3 documentos markdown:

1. **PHASE_2_SUMMARY.md** - Detalles de Fase 2 (Admin & Analytics)
2. **PHASE_3_SUMMARY.md** - Detalles de Fase 3 (Advanced Notifications)
3. **PROJECT_STRUCTURE.md** - Estructura completa del proyecto

---

## 🔗 URLs Importantes

### API Backend
```
Base URL: https://smartosaresu.onrender.com/api
Status: Debe estar en línea para funcionalidad completa
```

### Documentación de Dependencias
- **Provider**: https://pub.dev/packages/provider
- **Dio**: https://pub.dev/packages/dio
- **fl_chart**: https://pub.dev/packages/fl_chart

---

## 💾 Guardar Estado y Persistencia

### SharedPreferences
La app usa SharedPreferences para guardar:
- Token de autenticación
- Email del usuario
- Preferencias locales

Estos datos persisten entre sesiones.

---

## 🎯 Próximas Acciones

1. **Conectar Backend Real**: Reemplazar URLs de mock con API real
2. **Implementar Autenticación Real**: Usar tokens JWT reales
3. **Habilitar Push Notifications**: Integrar Firebase Cloud Messaging
4. **Testing Completo**: Escribir unit y integration tests
5. **Publicar**: Google Play Store y Apple App Store

---

## 📞 Soporte

Si encuentras problemas:

1. Verificar que Flutter esté actualizado: `flutter upgrade`
2. Limpiar build: `flutter clean`
3. Revisar errores: `flutter analyze`
4. Consultar documentación oficial: https://flutter.dev/docs
5. Revisar logs detallados: `flutter run --verbose`

---

**Última actualización**: 2024  
**Estado**: Listo para ejecución y prueba
