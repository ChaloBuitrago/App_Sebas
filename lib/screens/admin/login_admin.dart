import 'package:flutter/material.dart';
import 'package:src/screens/admin/loans/loan_notification_controller.dart';
import 'package:src/screens/admin/loans/loan_notification_service.dart';
import '../../services/auth_service.dart';
import '../admin/dashboard_admin.dart';

class LoginAdminScreen extends StatefulWidget {
  const LoginAdminScreen({super.key});

  @override
  State<LoginAdminScreen> createState() => _LoginAdminScreenState();
}

class _LoginAdminScreenState extends State<LoginAdminScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    //Ejecutar logica en segundoplano al abrir la pantalla si es necesario
    Future.microtask(() async {
      // lógica: revisar prestamos y programar notificaciones
      await LoanNotificationController.checkAndScheduleNotifications();
    });
  }

  Future<void> _login() async {
    setState(() => _isLoading = true);

    // CORRECCIÓN: usar el método login() que sí existe
    final user = await _authService.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (user != null && user.role == "admin") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardAdmin()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credenciales incorrectas o no es administrador')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Administrador')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Correo'),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            const SizedBox(height: 25),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _login,
              child: const Text('Ingresar'),
            ),
          ],
        ),
      ),
    );
  }
}

