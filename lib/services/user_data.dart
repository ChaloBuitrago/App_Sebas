import '../models/user_model.dart';
import '../models/auth_user.dart';

class UserData {
  // Lista de usuarios del sistema (login)
  static final List<AuthUser> authUsers = [
    AuthUser(
      identifier: "admin",
      usuario: 'admin',
      password: "1234",
      email: "admin@test.com",
      role: "Administrador",
      nombre: "Administrador del Sistema",
    ),
    AuthUser(
      identifier: "cliente",
      usuario: 'cliente',
      password: "1234",
      email: "juan@test.com",
      role: "Cliente",
      nombre: "Cliente General",
    ),
  ];

  // Lista de clientes (préstamos)
  static final List<UserModel> users = [];

  // Login REAL
  static AuthUser? login(String identifier, String password) {
    try {
      return authUsers.firstWhere(
            (u) => u.identifier == identifier && u.password == password,
      );
    } catch (_) {
      return null;
    }
  }

  // Registrar cliente
  static void addUser(UserModel user) {
    users.add(user);
  }

  static List<UserModel> getAllUsers() => users;

  static UserModel? findUserById(String id) {
    try {
      return users.firstWhere((u) => u.identifier == id);
    } catch (_) {
      return null;
    }
  }

  static bool deleteUser(String id) {
    final before = users.length;
    users.removeWhere((u) => u.identifier == id);
    return users.length < before;
  }
}
