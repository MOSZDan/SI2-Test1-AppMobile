# 🔨 Comandos Útiles para Desarrollo - SmartSales365 Flutter

Una guía rápida de comandos útiles para desarrollar en este proyecto.

## 📦 Gestión de Dependencias

```bash
# Obtener todas las dependencias
flutter pub get

# Actualizar dependencias a las últimas versiones compatibles
flutter pub upgrade

# Actualizar a las últimas versiones mayores (cuidado)
flutter pub upgrade --major-versions

# Eliminar caché de dependencias
flutter pub cache clean

# Limpiar todo el proyecto
flutter clean

# Después de flutter clean, obtener dependencias nuevamente
flutter pub get
```

## 🏃 Ejecutar la Aplicación

```bash
# Ejecución estándar
flutter run

# Ejecución en modo release (más rápido)
flutter run --release

# Ejecución en modo profile (análisis de rendimiento)
flutter run --profile

# Ejecutar en dispositivo específico
flutter run -d <device_id>

# Listar dispositivos disponibles
flutter devices

# Ejecutar con logs verbosos
flutter run -v

# Hot reload después de cambios
r (en la terminal)

# Hot restart (reinicia completamente la app)
R (en la terminal)

# Detener la aplicación
q (en la terminal)
```

## 🧪 Testing

```bash
# Ejecutar todos los tests
flutter test

# Ejecutar tests específicos
flutter test test/widget_test.dart

# Ejecutar tests con cobertura
flutter test --coverage

# Tests en modo watch (se repite con cambios)
flutter test --watch
```

## 🏗️ Compilación

```bash
# Android APK
flutter build apk

# Android Bundle (Google Play)
flutter build appbundle

# iOS (requiere macOS)
flutter build ios

# Web
flutter build web

# Windows (requiere Windows)
flutter build windows

# Linux (requiere Linux)
flutter build linux

# macOS (requiere macOS)
flutter build macos
```

## 🔍 Análisis de Código

```bash
# Análisis estático
flutter analyze

# Análisis con información detallada
dart analyze --fatal-infos

# Formateo automático de código
dart format .

# Formateo de archivo específico
dart format lib/main.dart

# Verificar si el código está formateado
dart format --output=none --set-exit-if-changed .
```

## 🎨 Estilo de Código

```bash
# Lint del código
flutter analyze --write-metrics

# Ver problemas de lint
flutter analyze --no-pub

# Ejecutar análisis con reglas personalizadas
flutter analyze lib/
```

## 🔐 Seguridad

```bash
# Verificar dependencias vulnerables
flutter pub outdated

# Auditoría de seguridad (Dart/Flutter)
dart pub outdated --mode=null-safety

# Chequear vulnerabilidades conocidas
dart pub audit
```

## 📊 DevTools

```bash
# Abrir DevTools en el navegador
flutter pub global activate devtools
devtools

# Con la app corriendo, abre DevTools
flutter pub global run devtools

# Analytics y performance monitoring
flutter pub global activate devtools
flutter pub global run devtools --port=9100
```

## 🧩 Generación de Código

```bash
# Generar archivos .g.dart (si usas build_runner)
flutter pub run build_runner build

# Generar con watch
flutter pub run build_runner watch

# Limpiar generados
flutter pub run build_runner clean
```

## 📱 Dispositivos/Emuladores

```bash
# Listar dispositivos disponibles
flutter devices

# Crear emulador (Android)
flutter emulators --create --name pixel_device

# Listar emuladores
flutter emulators

# Lanzar emulador
flutter emulators --launch pixel_device

# Conectar dispositivo físico
adb devices
```

## 🌐 Web

```bash
# Ejecutar en Chrome
flutter run -d chrome

# Ejecutar en Firefox
flutter run -d firefox

# Ejecutar en Safari (macOS)
flutter run -d safari

# Ejecutar en Edge
flutter run -d edge

# Build web optimizado
flutter build web --release
```

## 💾 Git Workflow

```bash
# Ver cambios
git status

# Agregar cambios
git add .

# Commit
git commit -m "mensaje descriptivo"

# Ver diferencias
git diff

# Ver log de commits
git log --oneline

# Revert a versión anterior
git revert <commit-hash>

# Reset (descartar cambios locales)
git reset --hard
```

## 🔧 Troubleshooting Commands

```bash
# Limpiar cache de Flutter
flutter clean

# Limpiar caché de Dart
dart cache clean

# Eliminar carpeta build
rm -rf build/

# Eliminar carpeta .dart_tool
rm -rf .dart_tool/

# Verificar integridad de Flutter
flutter doctor

# Verificar integridad detallada
flutter doctor -v

# Actualizar Flutter a la última versión
flutter upgrade

# Cambiar rama de Flutter (dev, beta, stable)
flutter channel stable
flutter upgrade

# Ver versión actual
flutter --version

# Ver Dart version
dart --version
```

## 📝 Logging

```bash
# Ver logs en tiempo real
flutter logs

# Con app corriendo, ver logs
flutter run --verbose

# Filtrar logs específicos
flutter logs -f "ClassName"

# Limpiar logs previos
flutter logs -c
```

## 🚀 Performance

```bash
# Ejecutar en modo profile para análisis
flutter run --profile

# Memory profiling
flutter run --profile --trace-startup

# Timeline event (performance)
dart devtools --port=9100

# Frame rate monitoring
flutter run -v 2>&1 | grep "vsync"
```

## 🛠️ Utilidades

```bash
# Obtener información del proyecto
flutter pub get --example

# Ver árbol de dependencias
flutter pub deps

# Ver diferencias en pubspec.lock
git diff pubspec.lock

# Actualizar versión en pubspec.yaml
# (manual, editar pubspec.yaml)

# Ver changelog de dependencias
flutter pub outdated --mode=null-safety
```

## ⚡ Atajos Rápidos

```bash
# Crear nuevo proyecto
flutter create my_project

# Crear proyecto con plantilla
flutter create -t plugin my_plugin

# Crear proyecto con más configuración
flutter create --org com.example --project-name my_app --template app .

# Agregar dependencia
flutter pub add package_name

# Eliminar dependencia
flutter pub remove package_name

# Ver help
flutter help
dart help
```

## 📊 Monitoreo

```bash
# Ver uso de RAM de la app
adb shell dumpsys meminfo | grep "flutter"

# Ver FPS en tiempo real (Android)
adb shell dumpsys gfxinfo

# Profiling continuo
flutter run --profile --trace-startup > trace.json

# Analizar trace (requiere herramientas especiales)
# chrome://tracing -> cargar trace.json
```

## 🔄 Workflow Recomendado

```bash
# 1. Comenzar el día
flutter upgrade
flutter pub get

# 2. Desarrollo
flutter run      # Hot reload con 'r'

# 3. Antes de commit
flutter analyze
dart format lib/

# 4. Testing
flutter test

# 5. Build final
flutter build apk --release

# 6. Commit cambios
git add .
git commit -m "descripción"
git push
```

## 🎯 Casos de Uso Comunes

### Problema: "Packages not up to date"
```bash
flutter pub get
flutter pub upgrade
flutter clean
```

### Problema: La app no carga
```bash
flutter clean
flutter pub get
flutter run -v
```

### Problema: Cambios no se ven
```bash
# Presiona R en la terminal (hot restart)
# Si no funciona:
flutter clean
flutter run
```

### Problema: No hay dispositivos
```bash
flutter devices
flutter emulators --launch pixel_device
flutter run -d <device_id>
```

### Problema: Errores de compilación
```bash
flutter clean
flutter pub get
flutter pub upgrade --major-versions
flutter doctor
```

---

## 💡 Tips Pro

1. **Usa `flutter run -v`** para ver errores detallados
2. **Usa `flutter analyze`** antes de hacer push
3. **Crea un alias**: `alias fr='flutter run'`
4. **Usa `devtools`** para debugging avanzado
5. **Monitorea la memoria** en apps grandes
6. **Usa `--profile`** para optimizar rendimiento
7. **Documenta cambios** con commits claros
8. **Prueba en múltiples dispositivos**
9. **Usa `flutter pub outdated`** regularmente
10. **Mantén `pubspec.lock`** sincronizado con el repo

---

**Última actualización**: 11 de Noviembre, 2025
