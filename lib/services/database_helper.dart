import 'dart:async';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:src/services/notifications_service.dart';
import 'auth_service.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('control_cuentas.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, fileName);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onConfigure: _onConfigure,
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute("DROP TABLE IF EXISTS loans");
        await db.execute("DROP TABLE IF EXISTS usuarios");
        await _createDB(db, newVersion);
      },
    );
  }

  FutureOr<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _createDB(Database db, int version) async {
    // Crear tabla USERS
    print('[DB] Creando tablas...');
    await db.execute('''
    CREATE TABLE usuarios (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      identifier TEXT NOT NULL,
      nombre TEXT NOT NULL,
      usuario TEXT NOT NULL UNIQUE,
      email TEXT,
      phone TEXT,
      status TEXT DEFAULT 'active',
      password TEXT NOT NULL,
      role TEXT NOT NULL,
      createdAt TEXT
    );
  ''');
    print('[DB] Tabla usuarios creada');

    // Crear tabla LOANS
    print('[DB] Creando tabla loans...');
    await db.execute('''
    CREATE TABLE loans (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER NOT NULL,
      amount REAL NOT NULL,
      interest REAL NOT NULL,
      startDate TEXT NOT NULL,
      dueDate TEXT,    
      status TEXT NOT NULL DEFAULT 'active', 
      periodicidad TEXT NOT NULL, 
      customMessage TEXT, 
      notes TEXT,
      createdAt TEXT NOT NULL,
      FOREIGN KEY (userId) REFERENCES usuarios (id)
    );
  ''');
    print('[DB] Tabla loans creada');

    //Crear tabla notificaciones
    print('[DB] Creando tabla notificaciones...');
    await db.execute('''CREATE TABLE notificaciones (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  userId INTEGER NOT NULL,
  mensaje TEXT NOT NULL,
  fecha TEXT NOT NULL,
  FOREIGN KEY (userId) REFERENCES usuarios(id)
  );
 ''');
    print('[DB] Tabla notificaciones creada');


    // Crear tabla PRESTAMOS
    print('[DB] Creando tabla prestamos...');
    await db.execute('''
    CREATE TABLE prestamos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    userId INTEGER NOT NULL,
    monto REAL NOT NULL,
    fechaInicio TEXT NOT NULL,
    periodicidad TEXT NOT NULL,
    tasa REAL NOT NULL,
    createdAt TEXT,
    FOREIGN KEY (userId) REFERENCES usuarios(id)
  );
''');
    print('[DB] Tabla prestamos creada');

    // insertar admin y cliente por defecto
    await ensureDefaultUsers(db);
    print('[DB] Usuarios por defecto asegurados');
  }

  /// 🔥 Añadimos ensureDefaultUsers()
  Future<void> ensureDefaultUsers(Database db) async {
    print('[DB] Verificando admin por defecto...');
    final auth = AuthService(); // Esta es a instancia para usar hashPassword

    // 🔹 Admin por defecto
    final admin = await db.query('usuarios', where: 'role = ?', whereArgs: ['admin'], limit: 1);
    print('[DB] Resultado consulta admin: $admin');

    if (admin.isEmpty) {
      await db.insert('usuarios', {
        'identifier': 'ADM-0001',
        'nombre': 'Administrador',
        'usuario': 'admin',
        'email': 'admin@demo.com',
        'phone': '0000000000',
        'status': 'active',
        'password': auth.hashPassword('admin123'), // 🔐 en hash
        'role': 'admin',
        'createdAt': DateTime.now().toIso8601String(),
      });
    }

    // 🔹 Cliente por defecto
    final cliente = await db.query('usuarios', where: 'role = ?', whereArgs: ['cliente'], limit: 1);
    if (cliente.isEmpty) {
      await db.insert('usuarios', {
        'identifier': 'CLI-0001',
        'nombre': 'Cliente Demo',
        'usuario': 'cliente',
        'email': 'cliente@demo.com',
        'phone': '1111111111',
        'status': 'active',
        'password': auth.hashPassword('cliente123'),
        'role': 'cliente',
        'createdAt': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Método temporal para confirmar usuarios en BD
  Future<void> debugUsers() async {
    final db = await database;
    final res = await db.query('usuarios');
    print('[DEBUG] Usuarios en BD:');
    for (final u in res) {
      print(u);
    }
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('usuarios', user);
  }

  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    final db = await database;

    final result = await db.query(
      'usuarios',
      where: 'usuario = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> getPendingPayments() async {
    final db = await database;

    return await db.rawQuery('''
    SELECT p.id, p.amount, p.fechaInicio AS fecha, p.loanId, u.nombre AS userName
    FROM prestamos p
    JOIN usuarios u ON p.userId = u.id
    WHERE p.estado = ?
  ''', ['pendiente']);
  }

  Future<int> insertLoan(Map<String, dynamic> loan) async {
    final db = await database;
    return await db.insert('loans', loan);
  }

  Future<int> deleteLoan(int id) async {
    final db = await database;
    return await db.delete(
      'loans',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateLoan(int id, Map<String, dynamic> loan) async {
    final db = await database;
    return await db.update(
      'loans',
      loan,
      where: 'id = ?',
      whereArgs: [id],
    );
  }



  Future<List<Map<String, dynamic>>> getAllLoans() async {
    final db = await database;
    return await db.rawQuery('''
    SELECT loans.*, usuarios.nombre AS userName, usuarios.identifier AS userIdentifier
    FROM loans
    INNER JOIN usuarios ON usuarios.id = loans.userId
    ORDER BY loans.id DESC
  ''');
  }

  Future<List<Map<String, dynamic>>> getLoansByUser(int userId) async {
    final db = await database;
    return await db.query(
      'loans',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  Future<int> updateUser(int id, Map<String, dynamic> user) async {
    final db = await database;
    return await db.update(
      'usuarios',
      user,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      'usuarios',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getLoansForNotifications() async {
    final db = await database;
    return await db.query('loans', where: 'status = ?', whereArgs: ['active']);
  }

  Future<void> checkAndSendNotifications() async {
    final loans = await DatabaseHelper.instance.getLoansForNotifications();
    for (var loan in loans) {
      final periodicidad = loan['periodicidad'];
      final mensaje = loan['customMessage'] ?? "Recuerde su pago de préstamo";
      final fechaInicio = DateTime.parse(loan['startDate']);
      final dueDate = loan['dueDate'] != null ? DateTime.parse(loan['dueDate']) : null;

      bool debeNotificar = false;

      switch (periodicidad) {
        case 'Diario':
          debeNotificar = true;
          break;
        case 'Semanal':
          debeNotificar = DateTime.now().weekday == fechaInicio.weekday;
          break;
        case 'Mensual':
          debeNotificar = DateTime.now().day == fechaInicio.day;
          break;
      }

      // Extra: notificar si está próximo a vencer
      if (dueDate != null && dueDate.difference(DateTime.now()).inDays <= 2) {
        debeNotificar = true;
      }

      if (debeNotificar) {
        await NotificationService().showNotification(
          "Recordatorio de préstamo",
          "$mensaje - Monto: \$${loan['amount']} - Interés: ${loan['interest'] * 100}%",
        );
      }
    }
  }

  Future<void> close() async {
    final db = await database; // ✅ usa directamente la propiedad
    await db.close();
  }
}




