# 1 Proyecto Flutter - Natillera Digital Tejadas

Aplicación movil modular para la gestión de préstamos y pagos, con recordatorios automaticos.

## Características principales

- Gestión de Usuarios: Registro, inicio de sesión y administración de perfiles para administradores y clientes.
- Prestamos activos: Visualización y gestión de préstamos activos, con detalles completos.
- Pagos pendientes: Seguimiento de pagos pendientes y notificaciones automáticas para los clientes.
- Creación de préstamos: Formularios intuitivos para crear y asignar préstamos a los usuarios.
- Dashboard admin y cliente: Interfaces diferentes segun el rol.
- 
## ESTRUCTURA DEL PROYECTO 

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
                loan_notification_controller.dart
                loan_notification_service.dart
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
        notification_service.dart
        user_service.dart
        pago_data.dart
        prestamo_data.dart
        session.dart
        user_data.dart
        
    ├── widgets/                 # Componentes reutilizables de UI
    main.dart                    # Punto de entrada de la aplicación

## Instalación y configuración
### Requisitos previos
- Flutter 3.x o superior
- Dart 2.x o superior
- Android SDK configurado

### Pasos de instalación
''' bash
# Clonar el repositorio
git clone  https://github.com/ChaloBuitrago/App_Sebas.git

# Instalar dependencias
flutter pub get

# Ejecutar la aplicación
flutter run

## Dependencias principales 

- flutter sdk Framework para desarrollo de la app 
- flutter_local_notifications: 17.2.1  // Manejo de notificaciones locales(recordatorios)
- timezone: 0.9.0 // Manejo de zonas horarias para notificaciones
- permission_handler: 11.3.2 // Solicitud y la gestión de los permisos del dispositivo
- flutter_localizations: SDK // Soporte multiidioma y localización en la app
- sqflite: 2.2.8+4 // Base de datos SQLite para persistencia local de datos(prestamos,pagos,usuarios)
- path_provider: 2.0.15 // Acceso a directorios del sistema de archivos para almacenamiento local
- path: 1.8.4 // Manipulación de rutas de archivos y directorios
- cupertino_icons: 1.0.8 // Iconos estilo iOS para la interfaz de usuario
- hive: 2.2.3 // Base de datos NoSQL ligera para almacenamiento rapido 
- hive_flutter: 1.1.0 // Integración de Hive con Flutter para almacenamiento local rapido

## Dependencias de desarrollo
- flutter_test: SDK // Framework de pruebas unitarias e integración}
- flutter_lints: 2.0.0 // Reglas de estilo y buenas prácticas para el código Flutter

## Flujos principales 

### Admin 
- Registro e inicio de sesión > acceso a dashboard
- Crear usuario > guardar en base de datos
- Asignar Prestamo > relación entre usuario y prestamo
- Ver Pagos Pendientes > cuotas próximas o vencidas
- Prestamos Activos > ver lista de prestamos en curso
- Notificaciones > recordatorios automaticos a usuarios
- Reportes y Estadísticas > generar reportes financieros  //pendiente aun hoy 03/01/2025


### Cliente
- Registro e inicio de sesión > acceso a Cliente Home
- Ver Prestamos > lista de prestamos asignados
- Ver Cuotas > detalle de cuotas pendientes y pagadas
- Ver Notificaiones > alertas de pagos proximos o pendientes
- Historial de Pagos > registro de pagos realizados
- Perfil de Usuario > ver y editar informacion personal(incluyendo contraseña)
- Contacto y Soporte > canal de comunicación con admin. //pendiente para crear

## Pantallas 

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


## Diagrama de relaciones

El sistema se organiza en tres tablas principales:

- Usuarios: Información de los clientes.
- Loans: Prestamos asociados a cada usuario.
- Prestamos: pagos/cuotas asociadas a cada préstamo.

### Entidad-Relación

Tablas Principales 
- Usuarios (User)
    - id (PK)
    - nombre
    - email
    - phone
    - status
    - password
    - role (admin/cliente)
    - createdAt
- Loans (Prestamo)
    - id (PK)
    - userId (FK a Usuarios.id)
    - amount (monto del préstamo)
    - interest (tasa de interés)
    - startDate (fecha de inicio del préstamo)
    - status (estado del prestamo: activo, cerrado)
    - periodicidad (diario, semanal, mensual)
    - customMessage (mensaje personalizado para recordatorios)
    - notes (notas adicionales)
    - createdAt
- Prestamos 
    - id (PK)
    - userId
    - monto
    - fechaInicio
    - periodicidad
    - tasa
    - createdAt

## Capturas de pantalla

### Dashboard Admin
![Dashboard Admin](lib/assets/screenshots/panel_administrador.png)

### Crear Préstamo
![Crear Préstamo](lib/assets/screenshots/crear_prestamo.png)

### Préstamos Activos
![Prestamos Activos](lib/assets/screenshots/prestamos_activos.png)

### Gestionar Usuarios
![Gestionar Usuarios](lib/assets/screenshots/gestionar_usuarios.png)

### Agregar Usuario
![Agregar Usuario](lib/assets/screenshots/agregar_usuario.png)


## 🛣️ Roadmap

### 🐞 Errores conocidos

- [x] Revisar lógica de `database_helper.dart` para evitar duplicados en préstamos
- [] Mejorar manejo de errores en inicio de sesión (pantalla `login_admin.dart`)
- [] Revisar logica de `cambiar_password_screen.dart` para actualizar contraseñas correctamente
- [ ] Organizar lo titulos de los ultimos dos items del formulario crear préstamo `loan_create_screen.dart`
- [ ] Organizar el login para los usuarios creados por el administrador `login_screen.dart`

### 🔧 Mejoras pendientes

- [ ] Optimizar tiempos de carga en el arranque de la app
- [ ] Unificar mensajes de notificación para admins y clientes
- [ ] Documentar mejor la lógica de recordatorios automáticos
- [ ] Añadir validaciones de campos en formularios de creación de préstamos
- [ ] Crear los botones iniciales que tendrá la interfaz de cliente


### 🚀 Nuevas funcionalidades

- [ ] Canal de soporte cliente (chat o tickets)
- [ ] Exportación de reportes en PDF/Excel
- [ ] Multi-idioma (es/en)
- [ ] Integración con servicios en la nube
- [ ] Módulo de pagos en línea

✅ Checklist de pruebas 05/01/2024

🔐 Login

- [x] Login con admin/admin123 abre DashboardAdmin.
- [x] Login con cliente/cliente123 abre DashboardCliente. //ingresa pero queda cargando pantalla
- [x] Login con credenciales incorrectas muestra “Credenciales incorrectas”. // funciona bien con admin
- [x] Logout limpia la sesión y regresa a LoginScreen.


👤 Cliente // Aun no puede ingresar con las credenciales que le asigna el administrador (Interfaz pendiente)
- [ ] Cliente sin préstamos → mensaje “Tu acceso será habilitado cuando el administrador registre tu primer préstamo”.
- [ ] Cliente con préstamo → se muestran préstamos activos en DashboardCliente.
- [ ] Cliente puede cambiar su contraseña desde el panel (casilla + botón).
- [ ] Cliente ve notificaciones programadas por el admin.
- [ ] Cliente ve historial de pagos asociado a sus préstamos.

👨‍💼 Administrador
- [x] Admin puede crear un nuevo cliente con credenciales iniciales.
- [x] Admin puede crear un préstamo para ese cliente.
- [x] Admin puede programar notificaciones → aparecen en el panel del cliente.
- [] Admin puede consultar historial de pagos de todos los clientes.



🗄️ Base de datos
- [x] usuarios contiene admin y cliente por defecto.
- [x] usuarios guarda correctamente nuevos clientes creados por admin. // correcto en losta pero no en credenciales
- [x] prestamos se relaciona con el cliente correcto. // correcto
- [x] pagos se registran y se muestran en historial. // pendiente de prueba completa 
- [x] notificaciones se insertan y se muestran en el cliente. // pendiente de prueba completa















































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
