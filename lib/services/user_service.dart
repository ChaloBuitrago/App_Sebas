import 'database_helper.dart';

class UserService {
  final db = DatabaseHelper.instance;

  // --- Obtener usuario logueado (guardaremos su ID luego) ---
  Map<String, dynamic>? _loggedUser;

  void setLoggedUser(Map<String, dynamic> user) {
    _loggedUser = user;
  }

  Future<Map<String, dynamic>> getLoggedUser() async {
    return _loggedUser!;
  }

  // --- Cambiar contraseña ---
  Future<String> changePassword(String oldPass, String newPass) async {
    if (_loggedUser == null) return "Error interno";

    final dbClient = await db.database;

    // Verificar si la contraseña actual es correcta
    final res = await dbClient.query(
      'usuarios',
      where: "id = ? AND password = ?",
      whereArgs: [_loggedUser!["id"], oldPass],
    );

    if (res.isEmpty) return "Contraseña actual incorrecta";

    // Actualizar contraseña
    await dbClient.update(
      'usuarios',
      {"password": newPass},
      where: "id = ?",
      whereArgs: [_loggedUser!["id"]],
    );

    return "ok";
  }
}