import '../models/user_model.dart';
import 'database_helper.dart';

class AuthService {
  final db = DatabaseHelper.instance;
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;


  /// 🔹 Iniciar sesión
  Future<UserModel?> login(String usuario, String password) async {
    final dbClient = await db.database;

    final res = await dbClient.query(
      'usuarios',
      where: 'usuario = ? AND password = ?',
      whereArgs: [usuario, password],
    );

    if (res.isEmpty) return null;

    _currentUser = UserModel.fromMap(res.first);
    return _currentUser;
  }

  /// Obtener el usuario actulal
  Future<UserModel?> getLoggedUser() async {
    return _currentUser;
  }

  /// 🔹 Cerrar sesión
  void logout() {
    _currentUser = null;
  }
}

