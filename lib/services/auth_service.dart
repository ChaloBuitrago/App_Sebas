import '../models/auth_user.dart';
import 'database_helper.dart';

class AuthService {
  final dbHelper = DatabaseHelper.instance;

  Future<AuthUser?> login(String usuarioOrEmail, String password) async {
    final db = await dbHelper.database;

    final res = await db.query(
      'usuarios',
      where: '(usuario = ? OR email = ?) AND password = ?',
      whereArgs: [usuarioOrEmail, usuarioOrEmail, password],
      limit: 1,
    );

    if (res.isEmpty) return null;
    return AuthUser.fromMap(res.first);
  }

  Future<int> createUser(AuthUser u) async {
    final db = await dbHelper.database;
    return db.insert('usuarios', u.toMap());
  }
}


