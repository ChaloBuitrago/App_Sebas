import 'package:flutter/material.dart';
import 'package:src/screens/admin/loans/loan_create_screen.dart';
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
import 'services/notifications_service.dart';
import 'package:permission_handler/permission_handler.dart';
// Si más adelante tendrás listado de usuarios:


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initNotifications();

  // ✅ Pedir permiso en Android 13+
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
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
        "/reportesFinancieros": (context) => const ReportesFinancierosScreen(),
        "/prestamosActivos": (context) => const PrestamosActivosScreen(),
        "/crearPrestamo": (context) => const LoanCreateScreen(),
        '/cambiarPasswor':(_) => const CambiarPasswordScreen(),
        "/addLoan": (context) => const AddLoanScreen(),
        "/dashboardCliente": (context) => const DashboardCliente(),
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