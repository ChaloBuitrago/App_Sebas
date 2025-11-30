import 'package:flutter/material.dart';
import '../services/auth_service.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _loading = false;

  Future<void> _login() async {
    final user = _userController.text.trim();
    final pass = _passController.text.trim();

    if (user.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese usuario y contraseña')),
      );
      return;
    }

    setState(() => _loading = true);
    final authUser = await _authService.login(user, pass);
    setState(() => _loading = false);

    if (authUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credenciales incorrectas')),
      );
      return;
    }

    // Redirigir según rol
    final role = authUser.role.toLowerCase();

    if (role == 'admin') {
      Navigator.pushReplacementNamed(context, '/dashboardAdmin');
    } else if (role == 'cliente') {
      Navigator.pushReplacementNamed(context, '/dashboardCliente');
    } else {
    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Rol no reconocido')),
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
                  controller: _userController,
                  decoration: const InputDecoration(
                    labelText: "Usuario",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: _passController,
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
                        ? const CircularProgressIndicator(color: Colors.white)
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



