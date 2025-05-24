import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BD {
  //instanciarla
  static final BD _instance = BD._internal();
  factory BD() => _instance;
  BD._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'usuarios.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          Create table usuarios(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          usuario TEXT NOT NULL,
          password TEXT NOT NULL
          )

          ''');
      },
    );
  }

  Future<int> insertarUsuario(String usuario, String password) async {
    final db = await database;
    return await db.insert('usuarios', {
      'usuario': usuario,
      'password': password,
    });
  }

  Future<List<Map<String, dynamic>>> obtenerUsuarios() async {
    final db = await database;
    return await db.query('usuarios');
    //query = seleccionar datos
  }

  Future<int> EliminarUsuario(int id) async {
    final db = await database;
    return await db.delete('usuarios', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> ModificarUsuario(int id, String nu, String np) async {
    final db = await database;
    return await db.update('usuarios', {'usuario': nu, 'password': np},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> ValidarUsuario(String nu, String np) async {
    final db = await database;
    List<Map<String, dynamic>> respuesta = await db.query(
      'usuarios',
      where: 'usuario = ? and password = ?',
      whereArgs: [nu, np],
    );
    return respuesta.isNotEmpty;
  }
}
