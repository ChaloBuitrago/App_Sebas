import 'database_helper.dart';
import '../screens/admin/loans/sms_service.dart'; // ✅ Importar servicio de notificaciones

class LoanService {
  final db = DatabaseHelper.instance;

  /// 🔹 Crear nuevo préstamo
  Future<int> createLoan(Map<String, dynamic> loanData) async {
    final dbClient = await db.database;
    final loanId = await dbClient.insert('prestamos', loanData);

    return loanId;
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

  /// 🔹 Obtener préstamo por ID (con datos del usuario)
  Future<Map<String, dynamic>?> getLoanById(int id) async {
    final dbClient = await db.database;

    final result = await dbClient.rawQuery('''
      SELECT p.*, u.nombre AS userName, u.identifier AS userIdentifier
      FROM prestamos p
      INNER JOIN usuarios u ON u.id = p.userId
      WHERE p.id = ?
      LIMIT 1
    ''', [id]);

    return result.isNotEmpty ? result.first : null;
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
    final result = await dbClient.update(
      'prestamos',
      loanData,
      where: 'id = ?',
      whereArgs: [id],
    );

    return result;
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