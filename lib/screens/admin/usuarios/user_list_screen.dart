import 'package:flutter/material.dart';
import '../../../services/database_helper.dart';
import 'user_edit_screen.dart';
import '../loans/loan_create_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<Map<String, dynamic>> usuarios = [];

  @override
  void initState() {
    super.initState();
    cargarUsuarios();
  }

  Future<void> cargarUsuarios() async {
    final db = await DatabaseHelper.instance.database;
    final data = await db.query("usuarios");
    setState(() => usuarios = data);
  }

  Future<void> eliminarUsuario(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete("usuarios", where: "id = ?", whereArgs: [id]);
    cargarUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Usuarios Registrados"),
        backgroundColor: Colors.blueAccent,
      ),
      body: usuarios.isEmpty
          ? const Center(child: Text("No hay usuarios registrados"))
          : ListView.builder(
        itemCount: usuarios.length,
        itemBuilder: (context, i) {
          final u = usuarios[i];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(u["nombre"] ?? "Sin nombre"),
              subtitle: Text("Usuario: ${u["usuario"]} · Rol: ${u["role"]}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserEditScreen(user: u['id']), // ✅ corregido
                        ),
                      ).then((_) => cargarUsuarios());
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.attach_money, color: Colors.green),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoanCreateScreen(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => eliminarUsuario(u["id"]),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
