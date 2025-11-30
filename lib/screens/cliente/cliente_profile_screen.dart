import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';

class ClienteProfileScreen extends StatefulWidget {
  final UserModel user;

  const ClienteProfileScreen({super.key, required this.user});

  @override
  State<ClienteProfileScreen> createState() => _ClienteProfileScreenState();
}

class _ClienteProfileScreenState extends State<ClienteProfileScreen> {
  final UserService _userService = UserService();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.nombre);
    _phoneController = TextEditingController(text: widget.user.phone);
    _emailController = TextEditingController(text: widget.user.email);
  }

  Future<void> _saveChanges() async {
    widget.user.nombre = _nameController.text.trim();
    widget.user.phone = _phoneController.text.trim();
    widget.user.email = _emailController.text.trim();

    await _userService.updateUser(widget.user);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Datos actualizados correctamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Perfil'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Teléfono'),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo'),
            ),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text("Guardar Cambios"),
            )
          ],
        ),
      ),
    );
  }
}
