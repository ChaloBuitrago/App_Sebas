// lib/screens/admin/usuarios/user_edit_screen.dart
import 'package:flutter/material.dart';
import '../../../services/database_helper.dart';

class UserEditScreen extends StatefulWidget {
  final Map<String, dynamic> user; // recibimos la fila de la DB

  const UserEditScreen({super.key, required this.user});

  @override
  State<UserEditScreen> createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreC;
  late TextEditingController _usuarioC;
  late TextEditingController _emailC;
  late String _role;

  @override
  void initState() {
    super.initState();
    final u = widget.user;
    _nombreC = TextEditingController(text: u['nombre']?.toString() ?? '');
    _usuarioC = TextEditingController(text: u['usuario']?.toString() ?? '');
    _emailC = TextEditingController(text: u['email']?.toString() ?? '');
    _role = u['role']?.toString() ?? 'cliente';
  }

  @override
  void dispose() {
    _nombreC.dispose();
    _usuarioC.dispose();
    _emailC.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final db = await DatabaseHelper.instance.database;
    await db.update(
      'usuarios',
      {
        'nombre': _nombreC.text.trim(),
        'usuario': _usuarioC.text.trim(),
        'email': _emailC.text.trim(),
        'role': _role,
      },
      where: 'id = ?',
      whereArgs: [widget.user['id']],
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuario actualizado ✅')),
    );

    Navigator.pop(context); // vuelve y el then() recargará la lista
  }

  Future<void> _delete() async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('usuarios', where: 'id = ?', whereArgs: [widget.user['id']]);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuario eliminado ✅')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Usuario'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (c) => AlertDialog(
                  title: const Text('Confirmar eliminación'),
                  content: const Text('¿Eliminar este usuario?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('No')),
                    TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Sí')),
                  ],
                ),
              );
              if (ok == true) await _delete();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreC,
                decoration: const InputDecoration(labelText: 'Nombre completo'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa el nombre' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _usuarioC,
                decoration: const InputDecoration(labelText: 'Usuario (único)'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa el usuario' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailC,
                decoration: const InputDecoration(labelText: 'Email (opcional)'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _role,
                items: ['admin', 'cliente'].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                onChanged: (v) => setState(() => _role = v ?? _role),
                decoration: const InputDecoration(labelText: 'Rol'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                child: const Text('Guardar cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

