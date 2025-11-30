import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

class LoanService {
  final db = DatabaseHelper.instance;

  /// 🔹 Crear nuevo préstamo
  Future<int> createLoan(Map<String, dynamic> loanData) async {
    final dbClient = await db.database;
    return await dbClient.insert('loans', loanData);
  }

  /// 🔹 Obtener todos los préstamos (Admin)
  Future<List<Map<String, dynamic>>> getAllLoans() async {
    final dbClient = await db.database;
    return await dbClient.rawQuery('''
      SELECT loans.*, usuarios.nombre AS userName, usuarios.identifier AS userIdentifier
      FROM loans
      INNER JOIN usuarios ON usuarios.id = loans.userId
      ORDER BY loans.id DESC
    ''');
  }

  /// 🔹 Obtener préstamos por usuario
  Future<List<Map<String, dynamic>>> getLoansByUser(int userId) async {
    final dbClient = await db.database;
    return await dbClient.query(
      'loans',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'id DESC',
    );
  }

  /// 🔹 Actualizar préstamo
  Future<int> updateLoan(int id, Map<String, dynamic> loanData) async {
    final dbClient = await db.database;
    return await dbClient.update(
      'loans',
      loanData,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 🔹 Eliminar préstamo
  Future<int> deleteLoan(int id) async {
    final dbClient = await db.database;
    return await dbClient.delete(
      'loans',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
