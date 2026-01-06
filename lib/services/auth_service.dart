import '../models/user_model.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'database_helper.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final db = DatabaseHelper.instance;
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  /// Función para encriptar la contraseñas
  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
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

    _currentUser = UserModel.fromMap(res.first);
    return _currentUser;
  }

  Future<UserModel?> getLoggedUser() async => _currentUser;



  /// Actualizar contraseña en sesión
  void updateCurrentUserPassword(String newPass){
    if (_currentUser != null){
      _currentUser = _currentUser!.copyWith(password: hashPassword(newPass));
    }
  }


  /// 🔹 Cerrar sesión
  Future<void> logout() async {
    _currentUser = null;
  }
}

