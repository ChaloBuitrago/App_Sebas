import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

class LoanService {
  final db = DatabaseHelper.instance;

  /// 🔹 Crear nuevo préstamo
  Future<int> createLoan(Map<String, dynamic> loanData) async {
    final dbClient = await db.database;
    return await dbClient.insert('prestamos', loanData);
  }

  /// 🔹 Obtener todos los préstamos (Admin)
  Future<List<Map<String, dynamic>>> getAllLoans() async {
    final dbClient = await db.database;
    return await dbClient.rawQuery('''
      SELECT prestamos.*, usuarios.nombre AS userName, usuarios.identifier AS userIdentifier
      FROM prestamos
      INNER JOIN usuarios ON usuarios.id = prestamos.userId
      ORDER BY prestamos.id DESC
    ''');
  }

  /// 🔹 Obtener préstamos por usuario específico
  Future<List<Map<String, dynamic>>> getLoansByUser(int userId) async {
    final dbClient = await db.database;
    return await dbClient.query(
      'prestamos',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'id DESC',
    );
  }

  /// 🔹 Actualizar préstamo
  Future<int> updateLoan(int id, Map<String, dynamic> loanData) async {
    final dbClient = await db.database;
    return await dbClient.update(
      'prestamos',
      loanData,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 🔹 Eliminar préstamo
  Future<int> deleteLoan(int id) async {
    final dbClient = await db.database;
    return await dbClient.delete(
      'prestamos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

