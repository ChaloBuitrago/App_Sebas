import '../models/user_model.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'database_helper.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  // Singleton
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  void setCurrentUser(UserModel user) {
    _currentUser = user;
  }

  /// 🔹 Iniciar sesión
  Future<UserModel?> login(String usuario, String password) async {
    final dbClient = await DatabaseHelper.instance.database;
    final hashed = hashPassword(password); // aqui usa el metodo de AuthService

    print('[LOGIN] usuario="$usuario" hashed="$hashed"');

    final res = await dbClient.query(
      'usuarios',
      where: 'usuario = ? AND password = ?',
      whereArgs: [usuario, hashed],
      limit: 1,
    );

    if (res.isEmpty) return null;

    _currentUser = UserModel.fromMap(res.first); // 👈 Guardamos sesión
    print('[LOGIN] Usuario ${_currentUser!.usuario} con rol="${_currentUser!.role}" ha iniciado sesión.');
    return _currentUser;
  }
  /// 🔹 Obtener usuario logueado
  Future<UserModel?> getLoggedUser() async {
    return _currentUser;
  }
  // Cerrar sesión
  void logout() => _currentUser = null;

  /// 🔹 Hashear contraseña
  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString(); // devuelve el hash en hex
  }

  /// Actualizar contraseña en sesión
  void updateCurrentUserPassword(String newPass){
    if (_currentUser != null){
      _currentUser = _currentUser!.copyWith(password: hashPassword(newPass));
    }
  }
}

