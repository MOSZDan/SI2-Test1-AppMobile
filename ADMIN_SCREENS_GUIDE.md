# 🔧 Guía de Implementación - Pantallas de Admin

Este documento proporciona instrucciones paso a paso para implementar las pantallas de administrador.

## 📋 Pantallas a Implementar

### 1. Gestión de Usuarios (`gestion_usuarios_screen.dart`)

**Ubicación**: `lib/screens/admin/gestion_usuarios_screen.dart`

**Funcionalidades Requeridas**:
- [ ] Tabla de usuarios con columnas: Código, Nombre, Email, Teléfono, Rol
- [ ] Búsqueda por nombre o email
- [ ] Botón "Crear Usuario"
- [ ] Botón "Editar" por usuario
- [ ] Botón "Eliminar" con confirmación
- [ ] Selector desplegable para cambiar rol
- [ ] Paginación (si aplica)

**Servicios a Usar**:
```dart
UsuarioService.getUsuarios()          // GET /usuarios/
UsuarioService.crearUsuario(data)     // POST /usuarios/
UsuarioService.actualizarUsuario(id, data)  // PUT /usuarios/{id}/
UsuarioService.eliminarUsuario(id)    // DELETE /usuarios/{id}/
UsuarioService.cambiarRol(usuarioId, rolId)  // POST /usuarios/{id}/cambiar_rol/
UsuarioService.getRoles()             // GET /roles/
```

**Ejemplo de Código**:
```dart
// En el FutureBuilder
final usuarios = await UsuarioService.getUsuarios();
final roles = await UsuarioService.getRoles();

// En el diálogo de crear usuario
await UsuarioService.crearUsuario({
  'nombre': nombreController.text,
  'apellido': apellidoController.text,
  'email': emailController.text,
  'telefono': telefonoController.text,
  'direccion': direccionController.text,
  'rol_id': selectedRoleId,
});

// Para cambiar rol
await UsuarioService.cambiarRol(usuarioId, nuevoRolId);
```

---

### 2. Gestión de Categorías (`gestion_categorias_screen.dart`)

**Ubicación**: `lib/screens/admin/gestion_categorias_screen.dart`

**Funcionalidades Requeridas**:
- [ ] Tabla de categorías con columnas: ID, Nombre, Descripción, Acciones
- [ ] Búsqueda por nombre
- [ ] Botón "Crear Categoría"
- [ ] Botón "Editar"
- [ ] Botón "Eliminar" con validación (no si tiene productos)
- [ ] Modal para crear/editar

**Servicios a Usar**:
```dart
ProductoService.getCategorias()           // GET /categorias/
// Los siguientes necesitan ser agregados a ProductoService:
// POST /categorias/
// PUT /categorias/{id}/
// DELETE /categorias/{id}/
```

**Agregar a `producto_service.dart`**:
```dart
// POST /categorias/
static Future<Categoria> crearCategoria(Map<String, dynamic> data) async {
  try {
    final response = await ApiService.post('/categorias/', data: data);
    if (response.statusCode == 201) {
      return Categoria.fromJson(response.data);
    } else {
      throw Exception('Error al crear categoría');
    }
  } on DioException catch (e) {
    throw Exception('Error de conexión: ${e.message}');
  }
}

// PUT /categorias/{id}/
static Future<Categoria> actualizarCategoria(
  int id,
  Map<String, dynamic> data,
) async {
  try {
    final response = await ApiService.put('/categorias/$id/', data: data);
    if (response.statusCode == 200) {
      return Categoria.fromJson(response.data);
    } else {
      throw Exception('Error al actualizar categoría');
    }
  } on DioException catch (e) {
    throw Exception('Error de conexión: ${e.message}');
  }
}

// DELETE /categorias/{id}/
static Future<void> eliminarCategoria(int id) async {
  try {
    final response = await ApiService.delete('/categorias/$id/');
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Error al eliminar categoría');
    }
  } on DioException catch (e) {
    throw Exception('Error de conexión: ${e.message}');
  }
}
```

---

### 3. Gestión de Productos (`gestion_productos_screen.dart`)

**Ubicación**: `lib/screens/admin/gestion_productos_screen.dart`

**Funcionalidades Requeridas**:
- [ ] Tabla de productos con columnas: ID, Nombre, Categoría, Precio, Stock, Acciones
- [ ] Búsqueda por nombre
- [ ] Filtro por categoría
- [ ] Botón "Crear Producto"
- [ ] Botón "Editar"
- [ ] Botón "Eliminar" con confirmación
- [ ] Modal para crear/editar con:
  - Nombre, Descripción, Precio, Stock, Categoría
  - Upload de imagen (opcional para fase 1)

**Servicios a Usar**:
```dart
ProductoService.getProductos()         // GET /productos/
ProductoService.crearProducto(data)    // POST /productos/
ProductoService.actualizarProducto(id, data)  // PUT /productos/{id}/
ProductoService.eliminarProducto(id)   // DELETE /productos/{id}/
ProductoService.getCategorias()        // GET /categorias/
```

---

### 4. Estructura Común para Pantallas de Admin

Todas las pantallas de admin deben seguir este patrón:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/usuario_provider.dart';
// ... otros imports

class GestionUsuariosScreen extends StatefulWidget {
  const GestionUsuariosScreen({Key? key}) : super(key: key);

  @override
  State<GestionUsuariosScreen> createState() => _GestionUsuariosScreenState();
}

class _GestionUsuariosScreenState extends State<GestionUsuariosScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    
    // Cargar datos iniciales
    Future.microtask(() {
      final provider = Provider.of<UsuarioProvider>(context, listen: false);
      provider.cargarUsuarios();
      provider.cargarRoles();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCrearDialog() {
    // Mostrar diálogo de creación
  }

  void _showEditarDialog(Usuario usuario) {
    // Mostrar diálogo de edición
  }

  void _showConfirmarEliminacion(int id) {
    // Mostrar confirmación de eliminación
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Usuarios'),
        elevation: 0,
      ),
      body: Consumer<UsuarioProvider>(
        builder: (context, usuarioProvider, _) {
          if (usuarioProvider.isLoading) {
            return const LoadingIndicator();
          }

          if (usuarioProvider.error != null) {
            return ErrorWidget(message: usuarioProvider.error!);
          }

          return Column(
            children: [
              // Búsqueda
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar usuarios...',
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),

              // Tabla/Listado
              Expanded(
                child: ListView.builder(
                  itemCount: usuarioProvider.usuarios.length,
                  itemBuilder: (context, index) {
                    final usuario = usuarioProvider.usuarios[index];
                    return ListTile(
                      title: Text(usuario.nombreCompleto),
                      subtitle: Text(usuario.email),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: const Text('Editar'),
                            onTap: () => _showEditarDialog(usuario),
                          ),
                          PopupMenuItem(
                            child: const Text('Eliminar'),
                            onTap: () => _showConfirmarEliminacion(usuario.codigo),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCrearDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

---

## 🎯 Pasos de Implementación

### Paso 1: Crear archivos base
```bash
lib/screens/admin/
├── gestion_usuarios_screen.dart
├── gestion_categorias_screen.dart
└── gestion_productos_screen.dart
```

### Paso 2: Agregar métodos a ProductoService
- Agregar POST, PUT, DELETE para categorías
- Verificar que todos los servicios tienen manejo de errores

### Paso 3: Crear Providers adicionales
- Ya creado: `UsuarioProvider` en `lib/providers/usuario_provider.dart`
- Crear: `CategoriaProvider` (similar a `UsuarioProvider`)
- Crear: `GestionProductoProvider` (para admin)

### Paso 4: Actualizar main.dart
Agregar los nuevos providers:
```dart
MultiProvider(
  providers: [
    // ... providers existentes
    ChangeNotifierProvider(create: (_) => UsuarioProvider()),
    ChangeNotifierProvider(create: (_) => CategoriaProvider()),
    // ...
  ],
  // ...
)
```

### Paso 5: Agregar rutas de navegación
```dart
routes: {
  '/admin/usuarios': (context) => const GestionUsuariosScreen(),
  '/admin/categorias': (context) => const GestionCategoriasScreen(),
  '/admin/productos': (context) => const GestionProductosScreen(),
  // ...
}
```

---

## 💡 Tips de Implementación

### Para Búsqueda
```dart
// Filtrar lista localmente
final filtered = usuarios
    .where((u) => u.nombre.contains(_searchController.text))
    .toList();
```

### Para Modales de Crear/Editar
```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('Crear Usuario'),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: nombreController),
          TextField(controller: emailController),
          // ... más campos
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
      ElevatedButton(
        onPressed: () {
          usuarioProvider.crearUsuario({
            'nombre': nombreController.text,
            'email': emailController.text,
            // ...
          });
          Navigator.pop(context);
        },
        child: const Text('Crear'),
      ),
    ],
  ),
);
```

### Para Confirmaciones
```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('Confirmar eliminación'),
    content: const Text('¿Estás seguro?'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
      ElevatedButton(
        onPressed: () {
          usuarioProvider.eliminarUsuario(id);
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
        ),
        child: const Text('Eliminar'),
      ),
    ],
  ),
);
```

---

## 🧪 Pruebas Recomendadas

- [ ] Crear nuevo usuario
- [ ] Editar usuario existente
- [ ] Eliminar usuario con confirmación
- [ ] Cambiar rol de usuario
- [ ] Buscar usuario
- [ ] Crear categoría
- [ ] Editar categoría
- [ ] Eliminar categoría (validar si tiene productos)
- [ ] Crear producto
- [ ] Editar producto
- [ ] Eliminar producto
- [ ] Filtrar productos por categoría

---

## 📞 Soporte

Si tienes dudas sobre la implementación, consulta:
- `lib/providers/` para ver ejemplos de providers
- `lib/screens/dashboard/dashboard_screen.dart` para estructura de pantallas
- `lib/screens/pedidos/mis_pedidos_screen.dart` para tablas/listas

---

**Última actualización**: 11 de Noviembre, 2025
