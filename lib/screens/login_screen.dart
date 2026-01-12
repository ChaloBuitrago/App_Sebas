import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'admin/dashboard_admin.dart';
import 'cliente/dashboard_cliente.dart';
import 'package:permission_handler/permission_handler.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usuarioController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _loading = false;

  @override
  void initState() {
    super.initState();

    // 👇 Solicitar permisos después de que se muestre la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final status = await Permission.notification.status;
      if (status.isDenied) {
        await Permission.notification.request();
      }
    });
  }


  Future<void> _login() async {
    //Validación de campos vacios
    if (_usuarioController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Complete todos los campos")),
      );
      return;
    }
      // log de Inicio
    print('[LOGIN] Intentando iniciar sesión para usuario="${_usuarioController.text.trim()}"');
    setState(() => _loading = true);

    final user = await _authService.login(
      _usuarioController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() => _loading = true);
    try {
      final user = await _authService.login(
        _usuarioController.text.trim(),
        _passwordController.text.trim(),
      );
      setState(() => _loading = false);

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Credenciales incorrectas")),
        );
        return;
      }

      final r = (user.role ?? '').toLowerCase();
      print('[LOGIN] Usuario ${user.usuario} con rol="$r" ha iniciado sesión.');

      if (r == 'admin') {
        Navigator.pushReplacement( context,
          MaterialPageRoute(builder: (_) => const DashboardAdmin()),
        );
      } else if ( r == 'cliente') {
        Navigator.pushReplacement( context,
          MaterialPageRoute(builder: (_) => const DashboardCliente()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Rol de usuario desconocido")),
        );
      }

    } catch (e) {
      setState(() => _loading = false);
      print('[LOGIN] Error durante el inicio de sesión: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error durante el inicio de sesión: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 1,
                )
              ],
            ),
            child: Column(
              children: [
                const Icon(Icons.account_circle,
                    size: 90, color: Colors.blueAccent),
                const SizedBox(height: 20),
                const Text(
                  "Iniciar Sesión",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: _usuarioController,
                  decoration: const InputDecoration(
                    labelText: "Usuario",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Contraseña",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _login,
                    child: _loading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text("Ingresar"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


