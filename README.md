# Proyecto Flutter - Natillera Digital Tejadas

Aplicación movil desarrollada en Flutter/Dart para llevar la contabilidad acerca de prestamos, 
permitiendo llevar control de los pretamos activos, hacer recordatorios automaticos a los usuarios 
días antes de la cuota,

##Flujos principales 

### Admin 
- Registro e inicio de sesión > acceso a dashboard
- Crear/ agregar usuario > guardar en base de datos
- Asignar Prestamo > gestionar usuario > relacion Entre User Y Loans
- Prestamos Activos > ver lista de prestamos activos
- Enviar Recordatorios > notificaciones automaticas a usuarios
- Reportes y Estadísticas > generar reportes financieros


### Modulo: Cliente
- Registro e inicio de sesión > acceso a Home
- Ver Prestamos > lista de prestamos asignados
- Ver Cuotas > detalle de cuotas pendientes y pagadas
- Ver Notificaiones > alertas de pagos proximos o pendientes
- Historial de Pagos > registro de pagos realizados
- Perfil de Usuario > ver y editar informacion personal(incluyendo contraseña)
- Contacto y Soporte > canal de comunicación con admin. //pendiente para crear

##Pantallas 

### Admin 
- 'dashboard_admin.dart' > vista principal luego de iniciar sesión
- 

### Dashboard Admin 
- Agregar Usuario > /addUser > 'add_user.dart'
- Gestionar Usuario > /gestionarUsuarios > gestionar_usuarios_screen.dart
- Cambiar Contraseña → /cambiarPassword > 'cambiar_password_screen.dart'
- Pagos Pendientes → /pagosPendientes > 'pagos_pendientes_screen.dart'
- Préstamos Activos → /prestamosActivos > 'prestamos_activos_screen.dart'
- Crear Préstamo → /crearPrestamo > 'loan_create_screen.dart'
- Reportes Financieros → /reportesFinancieros > 'reportes_financieros_screen.dart'
- Cerrar Sesión → /cerrarSesion > 'cerrar_sesion.dart'
















































# src

Aplicacion para llevar las cuentas de natilleras, pretamistas o pagadiarios

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
