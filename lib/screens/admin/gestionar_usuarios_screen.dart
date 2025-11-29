import 'package:flutter/material.dart';
import '../../services/database_helper.dart';
import 'usuarios/user_edit_screen.dart';

class GestionarUsuariosScreen extends StatefulWidget {
  const GestionarUsuariosScreen({super.key});

  @override
  State<GestionarUsuariosScreen> createState() =>
      _GestionarUsuariosScreenState();
}

class _GestionarUsuariosScreenState extends State<GestionarUsuariosScreen> {
  List<Map<String, dynamic>> users = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    final db = await DatabaseHelper.instance.database;
    final res = await db.query('usuarios');

    setState(() {
      users = res;
      loading = false;
    });
  }

  Future<void> deleteUser(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('usuarios', where: 'id = ?', whereArgs: [id]);
    loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestionar Usuarios"),
        backgroundColor: Colors.blueAccent,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
          ? const Center(child: Text("No hay usuarios registrados"))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: users.length,
        itemBuilder: (_, i) {
          final u = users[i];

          return Card(
            child: ListTile(
              title: Text(u["nombre"]),
              subtitle: Text(
                  "Usuario: ${u["usuario"]} - Rol: ${u["role"]}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // EDITAR
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              UserEditScreen(user: u),
                        ),
                      ).then((_) => loadUsers());
                    },
                  ),

                  // ELIMINAR
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteUser(u["id"]),
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

