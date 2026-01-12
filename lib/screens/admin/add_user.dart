import 'package:flutter/material.dart';
import '../../services/user_service.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _usuarioController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String _role = "cliente"; // valor por defecto

  @override
  void dispose() {
    _nombreController.dispose();
    _usuarioController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _createUser() async {
    if (!_formKey.currentState!.validate()) return;

    final userService = UserService();

    final id = await userService.createUser(
      nombre: _nombreController.text.trim(),
      usuario: _usuarioController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      plainPassword: _passwordController.text.trim(),
      role: _role,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Usuario creado con id=$id")),
    );

    _formKey.currentState!.reset();
    setState(() {
      _role = "cliente"; // reset al valor por defecto
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Agregar Usuario")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: "Nombre"),
                validator: (v) => v!.isEmpty ? "Ingrese nombre" : null,
              ),
              TextFormField(
                controller: _usuarioController,
                decoration: const InputDecoration(labelText: "Usuario"),
                validator: (v) => v!.isEmpty ? "Ingrese usuario" : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Teléfono"),
                validator: (v) => v!.isEmpty ? "Ingrese teléfono" : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Contraseña"),
                obscureText: true,
                validator: (v) => v!.isEmpty ? "Ingrese contraseña" : null,
              ),
              DropdownButtonFormField<String>(
                value: _role,
                items: const [
                  DropdownMenuItem(value: "cliente", child: Text("Cliente")),
                  DropdownMenuItem(value: "admin", child: Text("Admin")),
                ],
                onChanged: (val) => setState(() => _role = val!),
                decoration: const InputDecoration(labelText: "Rol"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createUser,
                child: const Text("Crear Usuario"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}