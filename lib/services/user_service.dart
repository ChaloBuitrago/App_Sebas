import 'database_helper.dart';
import '../models/user_model.dart';

class UserService {
  final db = DatabaseHelper.instance;

  Future<int> updateUser(UserModel user) async {
    final dbClient = await db.database;
    return await dbClient.update(
      'usuarios',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }
  Future<String> changePassword(int userId, String oldPass, String newPass) async {
    final dbClient = await db.database;

    final res = await dbClient.query(
    'usuarios',
    where: "id = ? AND password = ?",
    whereArgs: [userId, oldPass],
    );
    if (res.isEmpty) {
    return "Contraseña actual incorrecta";
    }

    await dbClient.update(
    'usuarios',
    {'password': newPass},
    where: 'id = ?',
    whereArgs: [userId],
    );

    return "ok";
  }
}


