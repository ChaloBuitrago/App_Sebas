import 'package:flutter/material.dart';
import '../../../services/database_helper.dart';
import '../../../models/auth_user.dart';
import 'user_edit_screen.dart';

class UserListScreen extends StatefulWidget {
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
      appBar: AppBar(title: Text("Usuarios Registrados")),
      body: ListView.builder(
        itemCount: usuarios.length,
        itemBuilder: (context, i) {
          final u = usuarios[i];

          return Card(
            child: ListTile(
              title: Text(u["nombre"]),
              subtitle: Text("Usuario: ${u["usuario"]} · Rol: ${u["role"]}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.monetization_on, color: Colors.green),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UserEditScreen(user: u["id"]),
                        ),
                      ).then((_) => cargarUsuarios());
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
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
