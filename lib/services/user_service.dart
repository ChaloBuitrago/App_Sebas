import 'database_helper.dart';
import '../models/user_model.dart';
import 'auth_service.dart';

class UserService {
  final db = DatabaseHelper.instance;

  /// Obtener todos los usuarios (como lista de Map)
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final dbClient = await db.database;
    return await dbClient.query(
      'usuarios',
      orderBy: 'nombre ASC',
    );
  }

  /// Si prefieres devolver modelos en vez de Map
  Future<List<UserModel>> getAllUsersAsModels() async {
    final rows = await getAllUsers();
    return rows.map((r) => UserModel.fromMap(r)).toList();
  }

  /// Actualizar usuario
  Future<int> updateUser(UserModel user) async {
    final dbClient = await db.database;
    return await dbClient.update(
      'usuarios',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> updateUserPassword(int userId, String newHashedPassword) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'usuarios',
      {'password': newHashedPassword},
      where: 'id = ?',
      whereArgs: [userId],
    );
    // Actualiza tambien el usuario en memoria
    final auth = AuthService();
    if (auth.currentUser != null && auth.currentUser!.id == userId) {
      final oldUser = auth.currentUser!;
      auth.setCurrentUser(
        UserModel(
          id: oldUser.id,
          identifier: oldUser.identifier,
          nombre: oldUser.nombre,
            usuario: oldUser.usuario,
            email: oldUser.email,
            phone: oldUser.phone,
            status: oldUser.status,
            password: newHashedPassword, // 👈 nueva contraseña
            role: oldUser.role,
            createdAt: oldUser.createdAt,
        )
      );
    }
  }

  /// Cambiar contraseña
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

  //Crear el usuario desde Admin
  Future<int> createUser({
    required String nombre,
    required String usuario,
    required String email,
    required String phone,
    required String plainPassword,
    required String role, // "cliente" o "admin"
  })async {
    final dbClient = await db.database;
    final auth = AuthService();

    final hashedPassword = auth.hashPassword(plainPassword);

    final userMap = {
      'identifier': "USR-${DateTime
          .now()
          .millisecondsSinceEpoch}",
      'nombre': nombre,
      'usuario': usuario,
      'email': email,
      'phone': phone,
      'password': hashedPassword,
      'status': 'active',
      'role': role.toLowerCase(),
      'createdAt': DateTime.now().toIso8601String(),
    };
    // insertar en la base de datos
    final id = await dbClient.insert('usuarios', userMap);
    print ('[USER SERVICE] Usuario creado con ID=$id y rol="$role"');
    return id;
  }
}