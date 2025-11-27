import 'package:flutter/material.dart';
import '../../../services/database_helper.dart';

class UserDetailScreen extends StatefulWidget {
  final int userId;

  const UserDetailScreen({super.key, required this.userId});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final db = DatabaseHelper.instance;

  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final database = await db.database;

    final res = await database.query(
      'users',
      where: 'id = ?',
      whereArgs: [widget.userId],
      limit: 1,
    );

    if (res.isNotEmpty) {
      setState(() {
        user = res.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle del Usuario"),
        backgroundColor: Colors.blueAccent,
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoItem("Identificador:", user!['identifier']),
            _infoItem("Nombre:", user!['nombre']),
            _infoItem("Usuario:", user!['usuario']),
            _infoItem("Email:", user!['email'] ?? "No registrado"),
            _infoItem("Rol:", user!['role']),
            _infoItem("Creado:", user!['createdAt']),
            const SizedBox(height: 20),

            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text("Volver"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _infoItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
