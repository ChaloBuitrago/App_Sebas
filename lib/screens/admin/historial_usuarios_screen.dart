import 'package:flutter/material.dart';
import '../../services/database_helper.dart';

class HistorialUsuariosScreen extends StatefulWidget {
  const HistorialUsuariosScreen({Key? key}) : super(key: key);

  @override
  State<HistorialUsuariosScreen> createState() => _HistorialUsuariosScreenState();
}

class _HistorialUsuariosScreenState extends State<HistorialUsuariosScreen> {
  final db = DatabaseHelper.instance;
  List<Map<String, dynamic>> usuarios = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargarUsuarios();
  }

  Future<void> cargarUsuarios() async {
    final database = await db.database;
    final res = await database.query("usuarios");

    setState(() {
      usuarios = res;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial de Usuarios"),
        backgroundColor: Colors.blueAccent,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : usuarios.isEmpty
          ? const Center(child: Text("No hay usuarios registrados"))
          : ListView.builder(
        itemCount: usuarios.length,
        itemBuilder: (context, index) {
          final u = usuarios[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.blueAccent),
              title: Text(u["nombre"] ?? ""),
              subtitle: Text("Usuario: ${u["usuario"]}\nRol: ${u["role"]}"),
            ),
          );
        },
      ),
    );
  }
}
