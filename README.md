# Proyecto Flutter - Natillera Digital Tejadas

Aplicación movil desarrollada en Flutter/Dart para llevar la contabilidad acerca de prestamos, 
permitiendo llevar control de los pretamos activos, hacer recordatorios automaticos a los usuarios 
días antes de la cuota,

###ESTRUCTURA DEL PROYECTO 

 lib/
    ├── models/                  # Modelos de datos 
        auth_user.dart
        historial_model.dart
        loan_model.dart
        pago_model.dart
        prestamo_model.dart
        user_model.dart
    ├── screens/                 # Pantallas de la aplicación
        admin/
            loans/
                add_loan.dart
                admin_loans_list.dart
                loan_create_screen.dart
                loan_detail_screen.dart
                loan_form_screen.dart
                loans_list_screen.dart
                pagos_pendientes_screen.dart
            reportes/
                reportes_financieros_screen.dart
            usuarios/
                user_detail_screen.dart
                user_edit_screen.dart
                user_list_screen.dart
                user_loans_screen.dart
            dashboard_admin.dart
            add_user.dart
            gestionar_usuarios_screen.dart
            prestamos_activos_screen.dart
            cerrar_sesion.dart
            login_admin.dart
        cliente/
            cliente_cuentas_screen.dart
            cliente_password_screen.dart
            cliente_profile_screen.dart
            dashboard_cliente.dart
        cambiar_password_screen.dart
        login_screen.dart
    services/                # Lógica de negocio y servicios
        auth_service.dart
        loan_service.dart
        database_helper.dart
        user_service.dart
        pago_data.dart
        prestamo_data.dart
        session.dart
        user_data.dart
        
    ├── widgets/                 # Componentes reutilizables de UI
    main.dart                    # Punto de entrada de la aplicación


##Flujos principales 

### Admin 
- Registro e inicio de sesión > acceso a dashboard
- Crear/ agregar usuario > guardar en base de datos
- Asignar Prestamo > gestionar usuario > relacion Entre User Y Loans
- Prestamos Activos > ver lista de prestamos activos
- Enviar Recordatorios > notificaciones automaticas a usuarios
- Reportes y Estadísticas > generar reportes financieros


### Cliente
- Registro e inicio de sesión > acceso a Cliente Home
- Ver Prestamos > lista de prestamos asignados
- Ver Cuotas > detalle de cuotas pendientes y pagadas
- Ver Notificaiones > alertas de pagos proximos o pendientes
- Historial de Pagos > registro de pagos realizados
- Perfil de Usuario > ver y editar informacion personal(incluyendo contraseña)
- Contacto y Soporte > canal de comunicación con admin. //pendiente para crear

##Pantallas 

### Admin 
- 'dashboard_admin.dart' > vista principal luego de iniciar sesión
- ''

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
