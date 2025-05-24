import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BD {
  static final BD _instance = BD._internal();
  factory BD() => _instance;
  BD._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initBD();
    return _database!;
  }

  Future<Database> _initBD() async {
    String Path = join(await getDatabasesPath(), 'escuela.db');
    return await openDatabase(
      Path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
      
      CREATE TABLE tareas(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      titulo TEXT NOT NULL,
      descripcion TEXT NOT NULL,
      realizada INT NOT NULL )


''');
      },
    );
  }

  Future<int> insertartarea(
    String titulo,
    String descripcion,
    String realizada,
  ) async {
    final db = await database;

    return await db.insert('tareas', {
      'titulo': titulo,
      'descripcion': descripcion,
      'realizada': int.tryParse(realizada) ?? 0,
    });
  }

  Future<List<Map<String, dynamic>>> obtenerdatos() async {
    final db = await database;
    return await db.query('tareas');
    // selcionar la tabla y datos
  }
}
