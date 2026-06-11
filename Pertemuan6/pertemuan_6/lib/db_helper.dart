import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/catatan.dart';

class DbHelper {
  DbHelper._();

  static final DbHelper instance = DbHelper._();

  static const String _dbName = 'catatan.db';
  static const int _dbVersion = 1;
  static const String tabel = 'catatan';

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await _openDb();
    return _db!;
  }

  Future<Database> _openDb() async {
    final String pathDb;

    if (kIsWeb) {
      pathDb = _dbName;
    } else {
      final dbPath = await getDatabasesPath();
      pathDb = join(dbPath, _dbName);
    }

    return openDatabase(
      pathDb,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tabel (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            judul TEXT NOT NULL,
            isi TEXT NOT NULL,
            kategori TEXT NOT NULL,
            email TEXT NOT NULL,
            dibuat_pada INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insert(Catatan catatan) async {
    final db = await database;
    return db.insert(tabel, catatan.toMap());
  }

  Future<List<Catatan>> getAll() async {
    final db = await database;
    final rows = await db.query(
      tabel,
      orderBy: 'dibuat_pada DESC',
    );

    return rows.map((row) => Catatan.fromMap(row)).toList();
  }

  Future<int> update(Catatan catatan) async {
    final db = await database;

    return db.update(
      tabel,
      catatan.toMap(),
      where: 'id = ?',
      whereArgs: [catatan.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;

    return db.delete(
      tabel,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}