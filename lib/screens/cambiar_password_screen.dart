import 'package:flutter/material.dart';
import 'package:src/services/auth_service.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';

class CambiarPasswordScreen extends StatefulWidget {
  const CambiarPasswordScreen({super.key});

  @override
  State<CambiarPasswordScreen> createState() => _CambiarPasswordScreenState();
}

class _CambiarPasswordScreenState extends State<CambiarPasswordScreen> {
  final AuthService _authService = AuthService();
  final _oldPassController = TextEditingController();
  final _newPassController = TextEditingController();
  bool _loading = false;

  Future<void> _cambiarPassword() async {
    final oldPass = _oldPassController.text.trim();
    final newPass = _newPassController.text.trim();

    if (oldPass.isEmpty || newPass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Complete todos los campos")),
      );
      return;
    }

    // Obtener el usuario como UserModel
    final UserModel? user = _authService.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Usuario no autenticado")),
      );
      return;
    }

    setState(() => _loading = true);

    final response = await UserService().changePassword(user.id!, oldPass, newPass);

    setState(() => _loading = false);

    if (response == "ok") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Contraseña actualizada")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cambiar Contraseña"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _oldPassController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Contraseña actual",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _newPassController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Nueva contraseña",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _cambiarPassword,
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Actualizar"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
