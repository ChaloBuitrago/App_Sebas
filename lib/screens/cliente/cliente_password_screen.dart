import 'package:flutter/material.dart';

class ClientePasswordScreen extends StatefulWidget {
  const ClientePasswordScreen({super.key});

  @override
  State<ClientePasswordScreen> createState() => _ClientePasswordScreenState();
}

class _ClientePasswordScreenState extends State<ClientePasswordScreen> {
  final _oldPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmController = TextEditingController();

  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  Future<void> _changePassword() async {
    final user = _authService.currentUser;

    if (user == null) return;

    final oldPass = _oldPassController.text.trim();
    final newPass = _newPassController.text.trim();
    final confirm = _confirmController.text.trim();

    if (newPass != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Las contraseñas no coinciden")),
      );
      return;
    }

    if (oldPass != user.password) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Contraseña actual incorrecta")),
      );
      return;
    }

    user.password = newPass;
    await _userService.updateUser(user);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Contraseña actualizada")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cambiar Contraseña'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _oldPassController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Contraseña actual"),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _newPassController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Nueva contraseña"),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _confirmController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Confirmar nueva contraseña"),
            ),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: _changePassword,
              child: Text("Guardar"),
            )
          ],
        ),
      ),
    );
  }
}