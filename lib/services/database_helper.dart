import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('control_cuentas.db');
    return _database!;
  }

  Future<int> insertLoan(Map<String, dynamic> loan) async {
    final db = await database;
    return await db.insert('loans', loan);
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

  Future<int> updateLoan(int id, Map<String, dynamic> loan) async {
    final db = await database;
    return await db.update(
      'loans',
      loan,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteLoan(int id) async {
    final db = await database;
    return await db.delete(
      'loans',
      where: 'id = ?',
      whereArgs: [id],
    );
  }



  FutureOr<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _createDB(Database db, int version) async {
    // Crear tabla USERS
    await db.execute('''
    CREATE TABLE usuarios (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      identifier TEXT NOT NULL,
      nombre TEXT NOT NULL,
      usuario TEXT NOT NULL UNIQUE,
      email TEXT,
      phone TEXT,
      password TEXT NOT NULL,
      role TEXT NOT NULL,
      createdAt TEXT
    );
  ''');

    // Crear tabla LOANS
    await db.execute('''
    CREATE TABLE loans (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER NOT NULL,
      amount REAL NOT NULL,
      interest REAL NOT NULL,
      startDate TEXT NOT NULL,
      notes TEXT,
      createdAt TEXT NOT NULL,
      FOREIGN KEY (userId) REFERENCES usuarios (id)
    );
  ''');
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

    // Insertar admin inicial
    await db.insert('usuarios', {
      'identifier': 'admin',
      'nombre': 'Administrador del Sistema',
      'usuario': 'admin',
      'email': 'admin@test.com',
      'password': '1234',
      'role': 'admin',
      'createdAt': DateTime.now().toIso8601String(),
    });

  }


  /// 🔥 Añadimos ensureDefaultAdmin()
  Future<void> ensureDefaultAdmin() async {
    final db = await instance.database;

    // ¿Existe un admin?
    final res = await db.query(
      'usuarios',
      where: 'role = ?',
      whereArgs: ['admin'],
      limit: 1,
    );

    // Si NO existe → lo crea
    if (res.isEmpty) {
      await db.insert('usuarios', {
        'identifier': 'admin',
        'nombre': 'Administrador del Sistema',
        'usuario': 'admin',
        'email': 'admin@test.com',
        'password': '1234',
        'role': 'admin',
        'createdAt': DateTime.now().toIso8601String(),
      });
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
