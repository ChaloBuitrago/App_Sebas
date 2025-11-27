import 'package:flutter/material.dart';
import 'package:src/screens/admin/historial_usuarios_screen.dart';
import 'package:src/screens/login_screen.dart';
import 'screens/admin/dashboard_admin.dart';
import 'screens/admin/add_user.dart';
import 'screens/admin/loans/add_loan.dart';
import 'screens/admin/loans/admin_loans_list.dart';
import 'screens/admin/loans/loan_detail_screen.dart';
import 'screens/admin/usuarios/user_detail_screen.dart';
import 'screens/admin/reportes/reportes_financieros_screen.dart';
import 'screens/admin/loans/pagos_pendientes_screen.dart';
// Si más adelante tendrás listado de usuarios:


void main() {
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
        "/historialUsuarios": (context) => const HistorialUsuariosScreen(),
        "/pagosPendientes": (context) => const PagosPendientesScreen(),
        "/reportesFinancieros": (context) => const ReportesFinancierosScreen(),
        "/addLoan": (context) => const AddLoanScreen(),
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