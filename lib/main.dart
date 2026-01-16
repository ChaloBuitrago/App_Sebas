import 'package:flutter/material.dart';
import 'package:src/screens/admin/loans/loan_create_screen.dart';
import 'package:src/services/database_helper.dart';
import 'screens/admin/gestionar_usuarios_screen.dart';
import 'screens/login_screen.dart';
import 'screens/admin/dashboard_admin.dart';
import 'screens/cliente/dashboard_cliente.dart';
import 'screens/cambiar_password_screen.dart';
import 'screens/admin/add_user.dart';
import 'screens/admin/loans/add_loan.dart';
import 'screens/admin/loans/admin_loans_list.dart';
import 'screens/admin/loans/loan_detail_screen.dart';
import 'screens/admin/usuarios/user_detail_screen.dart';
import 'screens/admin/prestamos_activos_screen.dart';
import 'screens/admin/reportes/reportes_financieros_screen.dart';
import 'screens/admin/loans/pagos_pendientes_screen.dart';
import 'screens/admin/loans/sms_service.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final phone = inputData?['telefono'];
    final message = inputData?['mensaje'];

    if (phone != null && message != null) {
      await SmsService().sendSms(phone, message); // Enviar SMS usando el servicio
      print('SMS enviado a $phone: $message');
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true, //poner en false en produccion
  );

    try {
      final db = await DatabaseHelper.instance.database;
      print('[MAIN] ususarios inicializado correctamente' );
    } catch (e) {
      print('[MAIN] Error al inicializar usuarios por defecto: $e' );
    }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sistema de Préstamos',
      initialRoute: '/login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/login": (context) => const LoginScreen(),
        "/dashboardAdmin": (context) => const DashboardAdmin(),
        "/addUser": (context) => const AddUserScreen(),
        "/gestionarUsuarios": (context) => const GestionarUsuariosScreen(),
        "/cambiarPassword": (context) => const CambiarPasswordScreen(),
        "/pagosPendientes": (context) => const PagosPendientesScreen(),
        "/prestamosActivos": (context) => const PrestamosActivosScreen(),
        "/crearPrestamo": (context) => const LoanCreateScreen(),
        "/addLoan": (context) => const AddLoanScreen(),
        "/dashboardCliente": (context) => const DashboardCliente(),
        "/cerrarSesion": (context) => const LoginScreen(),
        "/loansList": (context) => const AdminLoansList(),
        '/loanDetail': (context) {
          final loanId = ModalRoute
              .of(context)!
              .settings
              .arguments as int;
          return LoanDetailScreen(loanId: loanId);
        },
        "/userDetail": (context) {
          final userId = ModalRoute
              .of(context)!
              .settings
              .arguments as int;
          return UserDetailScreen(userId: userId);
        },
      },
    );
  }
}